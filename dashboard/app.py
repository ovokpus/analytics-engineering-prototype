"""Northwind trading desk.

Four views over the OBT models only:
overview, sales (obt_sales_overview), customers (obt_customer_reporting),
and inventory (obt_product_inventory).
"""

from __future__ import annotations

from datetime import date
from typing import Literal

import pandas as pd
import streamlit as st

from charts import bar, line, stacked_bar
from data import WarehouseError, load_tables
from metrics import (
    customer_links,
    display_product,
    inventory_position,
    label_transaction,
    money,
    net_revenue,
    person_name,
    purchase_header,
    purchase_lines,
    short_product,
)

Page = Literal["Overview", "Sales", "Customers", "Inventory"]
PAGES: tuple[Page, ...] = ("Overview", "Sales", "Customers", "Inventory")


def main() -> None:
    st.set_page_config(
        page_title="Northwind trading desk",
        page_icon=":seedling:",
        layout="wide",
    )
    st.markdown(
        """
        <div style="padding: 0.15rem 0 0.6rem 0;">
          <div style="font-size: 0.78rem; letter-spacing: 0.12em; text-transform: uppercase; color: #5C574E;">
            Northwind Traders
          </div>
          <div style="font-size: 2rem; font-weight: 700; color: #1C1917; line-height: 1.15;">
            Trading desk
          </div>
        </div>
        """,
        unsafe_allow_html=True,
    )

    try:
        tables = cached_tables()
    except WarehouseError as exc:
        st.error(str(exc))
        st.stop()

    sales = _prepare_sales(tables["sales"])
    customers = tables["customers"].copy()
    inventory = tables["inventory"].copy()
    inventory["product_name"] = display_product(inventory["product_name"], inventory["product_id"])
    inventory["movement"] = inventory["transaction_type"].map(label_transaction)
    position = inventory_position(inventory)

    start, end, category, country = _filters(sales, customers, inventory)
    sales_view = _filter_frame(sales, "order_date", start, end, category, country, "customer_country_region")
    customer_view = _filter_frame(
        customers, "creation_date", start, end, category, country, "customer_country_region"
    )
    inventory_view = _filter_frame(
        inventory, "transaction_created_date", start, end, category, None, None
    )
    position_view = inventory_position(inventory_view)

    page = st.sidebar.radio("Report", PAGES, label_visibility="visible")
    if st.sidebar.button("Reload warehouse"):
        cached_tables.clear()
        st.rerun()

    st.sidebar.caption(
        "Sales and customers respect the country filter. "
        "Inventory uses the date range and category. "
        "The sample books are from 2006."
    )

    _render(page, sales_view, customer_view, inventory_view, position_view, position)


@st.cache_data(ttl=60, show_spinner="Reading the OBT tables...")
def cached_tables() -> dict[str, pd.DataFrame]:
    return load_tables()


def _prepare_sales(sales: pd.DataFrame) -> pd.DataFrame:
    frame = sales.copy()
    frame["net_revenue"] = net_revenue(frame["quantity"], frame["unit_price"], frame["discount"])
    frame["seller"] = person_name(frame, "employee_first_name", "employee_last_name")
    frame["product_short"] = display_product(frame["product_name"], frame["product_id"])
    frame["customer_company"] = frame["customer_company"].fillna("Unknown company")
    frame["category"] = frame["category"].fillna("Uncategorized")
    return frame


def _filters(
    sales: pd.DataFrame,
    customers: pd.DataFrame,
    inventory: pd.DataFrame,
) -> tuple[date, date, str, str]:
    dates = pd.concat(
        [
            pd.to_datetime(sales["order_date"], errors="coerce"),
            pd.to_datetime(customers["creation_date"], errors="coerce"),
            pd.to_datetime(inventory["transaction_created_date"], errors="coerce"),
        ],
        ignore_index=True,
    ).dropna()
    if dates.empty:
        min_day = date(2006, 1, 1)
        max_day = date(2006, 12, 31)
    else:
        min_day = dates.min().date()
        max_day = dates.max().date()

    picked = st.sidebar.date_input(
        "Date range",
        value=(min_day, max_day),
        min_value=min_day,
        max_value=max_day,
    )
    start, end = _as_range(picked, min_day, max_day)

    categories = sorted(
        {
            str(value)
            for value in pd.concat(
                [sales["category"], customers["category"], inventory["category"]],
                ignore_index=True,
            ).dropna()
        }
    )
    category = st.sidebar.selectbox("Category", ["All", *categories])

    countries = sorted(
        {
            str(value)
            for value in pd.concat(
                [sales["customer_country_region"], customers["customer_country_region"]],
                ignore_index=True,
            ).dropna()
        }
    )
    country = st.sidebar.selectbox("Customer country", ["All", *countries])
    return start, end, category, country


def _as_range(picked: object, fallback_start: date, fallback_end: date) -> tuple[date, date]:
    if isinstance(picked, (tuple, list)):
        if len(picked) == 2 and picked[0] is not None and picked[1] is not None:
            return picked[0], picked[1]
        if len(picked) == 1 and picked[0] is not None:
            return picked[0], picked[0]
        return fallback_start, fallback_end
    if isinstance(picked, date):
        return picked, picked
    return fallback_start, fallback_end


def _filter_frame(
    frame: pd.DataFrame,
    date_column: str,
    start: date,
    end: date,
    category: str,
    country: str | None,
    country_column: str | None,
) -> pd.DataFrame:
    dates = pd.to_datetime(frame[date_column], errors="coerce")
    mask = dates.isna() | dates.dt.date.between(start, end)
    filtered = frame.loc[mask].copy()
    if category != "All":
        filtered = filtered.loc[filtered["category"].fillna("Uncategorized") == category]
    if country and country != "All" and country_column is not None:
        filtered = filtered.loc[filtered[country_column].fillna("") == country]
    return filtered


def _render(
    page: Page,
    sales: pd.DataFrame,
    customers: pd.DataFrame,
    inventory: pd.DataFrame,
    position: pd.DataFrame,
    position_all: pd.DataFrame,
) -> None:
    if page == "Overview":
        _overview(sales, customers, position, position_all)
    elif page == "Sales":
        _sales(sales)
    elif page == "Customers":
        _customers(customers)
    elif page == "Inventory":
        _inventory(inventory, position)
    else:
        unexpected: never = page
        raise AssertionError(unexpected)


def _overview(
    sales: pd.DataFrame,
    customers: pd.DataFrame,
    position: pd.DataFrame,
    position_all: pd.DataFrame,
) -> None:
    st.header("How the books look")
    st.caption("Sales revenue, purchase lines linked to customers, and stock that needs a reorder.")
    lines = purchase_lines(customers)
    alerts = position.loc[position["below_reorder"]] if not position.empty else position
    open_alerts = position_all.loc[position_all["below_reorder"]] if not position_all.empty else position_all

    revenue = float(sales["net_revenue"].sum()) if not sales.empty else 0.0
    orders = int(sales["order_id"].nunique()) if not sales.empty else 0
    purchase_cost = float(lines["extended_cost"].sum()) if not lines.empty else 0.0
    below = int(alerts["below_reorder"].sum()) if not alerts.empty else 0

    one, two, three, four = st.columns(4)
    one.metric("Net sales", money(revenue))
    two.metric("Orders", f"{orders:,}")
    three.metric("Purchase cost", money(purchase_cost))
    four.metric("Below reorder", f"{below:,}")

    if not open_alerts.empty:
        names = ", ".join(short_product(name) for name in open_alerts["product_name"].head(4))
        st.warning(f"{len(open_alerts)} active products are under their reorder level, including {names}.")

    left, right = st.columns(2)
    with left:
        _monthly_revenue(sales)
    with right:
        _top_products(sales)


def _sales(sales: pd.DataFrame) -> None:
    st.header("Sales")
    st.caption("One row in obt_sales_overview is a deduplicated order line. Revenue is price times quantity, after discount.")
    if sales.empty:
        st.info("No sales lines match those filters.")
        return

    revenue = float(sales["net_revenue"].sum())
    units = float(pd.to_numeric(sales["quantity"], errors="coerce").fillna(0).sum())
    orders = int(sales["order_id"].nunique())
    customers = int(sales["customer_company"].nunique())
    one, two, three, four = st.columns(4)
    one.metric("Net sales", money(revenue))
    two.metric("Units", f"{units:,.0f}")
    three.metric("Orders", f"{orders:,}")
    four.metric("Customers", f"{customers:,}")

    left, right = st.columns(2)
    with left:
        _monthly_revenue(sales)
    with right:
        _top_products(sales)

    sellers = (
        sales.groupby("seller", as_index=False)["net_revenue"]
        .sum()
        .sort_values("net_revenue", ascending=False)
    )
    buyers = (
        sales.groupby(["customer_company", "customer_city", "customer_country_region"], as_index=False)
        .agg(net_revenue=("net_revenue", "sum"), orders=("order_id", "nunique"))
        .sort_values("net_revenue", ascending=False)
    )
    left, right = st.columns(2)
    with left:
        st.plotly_chart(
            bar(
                sellers.sort_values("net_revenue"),
                "seller",
                "net_revenue",
                "Revenue by seller",
                horizontal=True,
                labels={"seller": "Seller", "net_revenue": "Net revenue"},
            ),
            use_container_width=True,
        )
    with right:
        top_buyers = buyers.head(8).sort_values("net_revenue")
        st.plotly_chart(
            bar(
                top_buyers,
                "customer_company",
                "net_revenue",
                "Revenue by customer",
                horizontal=True,
                labels={"customer_company": "Customer", "net_revenue": "Net revenue"},
            ),
            use_container_width=True,
        )

    detail = sales.sort_values("order_date", ascending=False)[
        ["order_date", "order_id", "customer_company", "product_name", "seller", "quantity", "net_revenue"]
    ].head(25)
    detail = detail.rename(
        columns={
            "order_date": "Order date",
            "order_id": "Order",
            "customer_company": "Customer",
            "product_name": "Product",
            "seller": "Seller",
            "quantity": "Units",
            "net_revenue": "Net revenue",
        }
    )
    st.dataframe(
        detail,
        use_container_width=True,
        hide_index=True,
        column_config={"Net revenue": st.column_config.NumberColumn(format="$%.2f")},
    )


def _customers(customers: pd.DataFrame) -> None:
    st.header("Customers")
    st.caption(
        "obt_customer_reporting links a purchase order to every customer who bought that product. "
        "Cost and payment totals below use one copy of each purchase line, so the fan-out is not added up twice. "
        "What each customer actually paid is on the Sales page."
    )
    if customers.empty:
        st.info("No purchase lines match those filters.")
        return

    lines = purchase_lines(customers)
    headers = purchase_header(lines)
    links = customer_links(customers)
    one, two, three, four = st.columns(4)
    one.metric("Customers linked", f"{int(links['customer_id'].nunique()):,}")
    two.metric("Purchase lines", f"{len(lines):,}")
    three.metric("Extended cost", money(float(lines["extended_cost"].sum())))
    four.metric(
        "Payments recorded",
        money(float(pd.to_numeric(headers["payment_amount"], errors="coerce").fillna(0).sum())),
        help="Purchase-order payment_amount, once per order. This extract stores 0 when no payment was entered.",
    )

    supplier_cost = lines.copy()
    supplier_cost["supplier"] = supplier_cost["supplier_company"].fillna("Unknown supplier")
    by_supplier = (
        supplier_cost.groupby("supplier", as_index=False)["extended_cost"]
        .sum()
        .sort_values("extended_cost")
    )
    left, right = st.columns(2)
    with left:
        st.plotly_chart(
            bar(
                by_supplier,
                "supplier",
                "extended_cost",
                "Purchase cost by supplier",
                horizontal=True,
                labels={"supplier": "Supplier", "extended_cost": "Extended cost"},
            ),
            use_container_width=True,
        )
    with right:
        top_links = links.head(8).sort_values("linked_orders")
        top_links["customer_company"] = top_links["customer_company"].fillna("Unknown company")
        st.plotly_chart(
            bar(
                top_links,
                "customer_company",
                "linked_orders",
                "Purchase orders linked to a customer",
                horizontal=True,
                labels={"customer_company": "Customer", "linked_orders": "Linked purchase orders"},
            ),
            use_container_width=True,
        )

    show = links.copy()
    show["customer_company"] = show["customer_company"].fillna("Unknown company")
    show = show.rename(
        columns={
            "customer_company": "Customer",
            "customer_city": "City",
            "customer_country_region": "Country",
            "linked_orders": "Linked POs",
            "linked_products": "Products",
            "linked_units": "Units on those POs",
        }
    )
    st.dataframe(
        show[["Customer", "City", "Country", "Linked POs", "Products", "Units on those POs"]],
        use_container_width=True,
        hide_index=True,
    )


def _inventory(inventory: pd.DataFrame, position: pd.DataFrame) -> None:
    st.header("Inventory")
    st.caption(
        "Quantities on obt_product_inventory are positive. "
        "On hand is purchased minus sold minus waste. On hold is set aside and is not subtracted from on hand."
    )
    if inventory.empty:
        st.info("No inventory movements match those filters.")
        return

    on_hand = float(position["on_hand"].sum()) if not position.empty else 0.0
    stock_value = float(position["stock_value"].sum()) if not position.empty else 0.0
    alerts = position.loc[position["below_reorder"]] if not position.empty else position
    movements = int(len(inventory))
    one, two, three, four = st.columns(4)
    one.metric("Units on hand", f"{on_hand:,.0f}")
    two.metric("Stock at cost", money(stock_value))
    three.metric("Below reorder", f"{len(alerts):,}")
    four.metric("Movements", f"{movements:,}")

    if not alerts.empty:
        alert_table = alerts.copy()
        alert_table["Product"] = alert_table["product_name"].map(short_product)
        alert_table["Gap"] = pd.to_numeric(alert_table["reorder_level"], errors="coerce") - alert_table["on_hand"]
        st.subheader("Needs a reorder")
        st.dataframe(
            alert_table[["Product", "supplier_company", "on_hand", "reorder_level", "target_level", "Gap"]].rename(
                columns={
                    "supplier_company": "Supplier",
                    "on_hand": "On hand",
                    "reorder_level": "Reorder at",
                    "target_level": "Target",
                }
            ),
            use_container_width=True,
            hide_index=True,
        )

    monthly = inventory.copy()
    monthly["month"] = pd.to_datetime(monthly["transaction_created_date"], errors="coerce").dt.to_period("M").dt.to_timestamp()
    monthly["quantity"] = pd.to_numeric(monthly["quantity"], errors="coerce").fillna(0.0)
    monthly = (
        monthly.dropna(subset=["month"])
        .groupby(["month", "movement"], as_index=False)["quantity"]
        .sum()
    )
    if not monthly.empty:
        st.plotly_chart(
            stacked_bar(
                monthly,
                "month",
                "quantity",
                "movement",
                "Units moved",
                labels={"month": "Month", "quantity": "Units", "movement": "Movement"},
            ),
            use_container_width=True,
        )

    if not position.empty:
        chart = position.copy()
        chart["Product"] = chart["product_name"].map(short_product)
        chart = chart.sort_values("on_hand", ascending=False).head(12).sort_values("on_hand")
        st.plotly_chart(
            bar(
                chart,
                "Product",
                "on_hand",
                "On hand, top products",
                horizontal=True,
                labels={"Product": "Product", "on_hand": "Units on hand"},
            ),
            use_container_width=True,
        )

        stock = position.copy()
        stock["Product"] = stock["product_name"].map(short_product)
        stock["Supplier"] = stock["supplier_company"].fillna("Unknown supplier")
        stock["Category"] = stock["category"].fillna("Uncategorized")
        stock = stock.sort_values("on_hand", ascending=False)
        st.dataframe(
            stock[
                [
                    "Product",
                    "Category",
                    "Supplier",
                    "purchased",
                    "sold",
                    "on_hold",
                    "waste",
                    "on_hand",
                    "available",
                    "reorder_level",
                ]
            ].rename(
                columns={
                    "purchased": "Purchased",
                    "sold": "Sold",
                    "on_hold": "On hold",
                    "waste": "Waste",
                    "on_hand": "On hand",
                    "available": "Available",
                    "reorder_level": "Reorder at",
                }
            ),
            use_container_width=True,
            hide_index=True,
        )


def _monthly_revenue(sales: pd.DataFrame) -> None:
    if sales.empty:
        st.info("No sales in this range.")
        return
    frame = sales.copy()
    frame["month"] = pd.to_datetime(frame["order_date"], errors="coerce").dt.to_period("M").dt.to_timestamp()
    monthly = frame.dropna(subset=["month"]).groupby("month", as_index=False)["net_revenue"].sum()
    if monthly.empty:
        st.info("Sales rows in this range have no order date.")
        return
    st.plotly_chart(
        line(
            monthly,
            "month",
            "net_revenue",
            "Net revenue by month",
            labels={"month": "Month", "net_revenue": "Net revenue"},
        ),
        use_container_width=True,
    )


def _top_products(sales: pd.DataFrame) -> None:
    if sales.empty:
        st.info("No products in this range.")
        return
    top = (
        sales.groupby("product_short", as_index=False)["net_revenue"]
        .sum()
        .sort_values("net_revenue", ascending=False)
        .head(8)
        .sort_values("net_revenue")
    )
    st.plotly_chart(
        bar(
            top,
            "product_short",
            "net_revenue",
            "Top products",
            horizontal=True,
            labels={"product_short": "Product", "net_revenue": "Net revenue"},
        ),
        use_container_width=True,
    )


if __name__ == "__main__":
    main()
