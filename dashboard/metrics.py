"""Turn OBT rows into the numbers the desk shows.

Inventory quantities in this warehouse are positive counts. Direction is
transaction_type, which matches inventory_transaction_types in the landing
zone: 1 purchased, 2 sold, 3 on hold, 4 waste.

Customer reporting fans each purchase line out across customers who bought
that product. Header amounts (payment, shipping, tax) repeat on every copy.
Cost totals use one copy of each purchase line.
"""

from __future__ import annotations

import pandas as pd

TRANSACTION_LABELS = {
    1: "Purchased",
    2: "Sold",
    3: "On Hold",
    4: "Waste",
}

PURCHASE_LINE_KEY = (
    "purchase_order_id",
    "product_id",
    "inventory_id",
    "supplier_id",
    "creation_date",
)


def money(value: float) -> str:
    return f"${value:,.0f}"


def net_revenue(quantity: pd.Series, unit_price: pd.Series, discount: pd.Series) -> pd.Series:
    """Line revenue after the line discount. Discount is a fraction, usually 0."""
    qty = pd.to_numeric(quantity, errors="coerce").fillna(0.0)
    price = pd.to_numeric(unit_price, errors="coerce").fillna(0.0)
    cut = pd.to_numeric(discount, errors="coerce").fillna(0.0)
    return qty * price * (1 - cut)


def person_name(frame: pd.DataFrame, first: str, last: str) -> pd.Series:
    given = frame[first].fillna("").astype(str).str.strip()
    family = frame[last].fillna("").astype(str).str.strip()
    names = (given + " " + family).str.strip()
    return names.replace("", "Unassigned")


def display_product(names: pd.Series, ids: pd.Series) -> pd.Series:
    """Short catalog name, or the product id when the dimension did not match.

    Multi-supplier products are left out of dim_product, so a sales line can
    have an id and no name.
    """
    short = names.map(short_product)
    missing = names.isna() | names.astype(str).str.strip().isin(["", "None", "nan", "Unknown product"])
    fallback = "Product " + pd.to_numeric(ids, errors="coerce").astype("Int64").astype(str)
    return short.mask(missing, fallback)


def short_product(name: object) -> str:
    text = "Unknown product" if name is None or (isinstance(name, float) and pd.isna(name)) else str(name)
    prefix = "Northwind Traders "
    if text.startswith(prefix):
        return text[len(prefix):]
    return text


def purchase_lines(customer_obt: pd.DataFrame) -> pd.DataFrame:
    """One row per purchase line, dropping the customer fan-out."""
    if customer_obt.empty:
        return customer_obt.copy()
    frame = customer_obt.copy()
    frame["extended_cost"] = (
        pd.to_numeric(frame["quantity"], errors="coerce").fillna(0.0)
        * pd.to_numeric(frame["unit_cost"], errors="coerce").fillna(0.0)
    )
    return frame.drop_duplicates(list(PURCHASE_LINE_KEY), keep="first")


def purchase_header(lines: pd.DataFrame) -> pd.DataFrame:
    """One row per purchase order so header amounts are counted once."""
    if lines.empty:
        return lines.copy()
    return lines.drop_duplicates(["purchase_order_id"], keep="first")


def customer_links(customer_obt: pd.DataFrame) -> pd.DataFrame:
    """How many distinct purchase lines and products sit behind each customer."""
    if customer_obt.empty:
        return pd.DataFrame(
            columns=[
                "customer_id",
                "customer_company",
                "customer_city",
                "customer_country_region",
                "linked_orders",
                "linked_products",
                "linked_units",
            ]
        )
    frame = customer_obt.copy()
    frame["quantity"] = pd.to_numeric(frame["quantity"], errors="coerce").fillna(0.0)
    per_line = frame.drop_duplicates(
        ["customer_id", "purchase_order_id", "product_id", "inventory_id"],
        keep="first",
    )
    grouped = (
        per_line.groupby(
            ["customer_id", "customer_company", "customer_city", "customer_country_region"],
            dropna=False,
        )
        .agg(
            linked_orders=("purchase_order_id", "nunique"),
            linked_products=("product_id", "nunique"),
            linked_units=("quantity", "sum"),
        )
        .reset_index()
        .sort_values(["linked_orders", "linked_units"], ascending=False)
    )
    return grouped


def label_transaction(value: object) -> str:
    try:
        key = int(value)
    except (TypeError, ValueError):
        return "Unknown"
    return TRANSACTION_LABELS.get(key, f"Type {key}")


def inventory_position(transactions: pd.DataFrame) -> pd.DataFrame:
    """On-hand stock by product.

    on_hand = purchased - sold - waste
    available = on_hand - on hold
    """
    empty_columns = [
        "product_id",
        "product_name",
        "category",
        "supplier_company",
        "reorder_level",
        "target_level",
        "list_price",
        "standard_cost",
        "discontinued",
        "purchased",
        "sold",
        "on_hold",
        "waste",
        "on_hand",
        "available",
        "stock_value",
        "below_reorder",
    ]
    if transactions.empty:
        return pd.DataFrame(columns=empty_columns)

    frame = transactions.copy()
    frame["type_id"] = pd.to_numeric(frame["transaction_type"], errors="coerce")
    frame = frame.dropna(subset=["type_id"]).copy()
    # Pivot columns must be ints. Pandas turns SQL numerics into floats.
    frame["type_id"] = frame["type_id"].astype(int)
    frame["quantity"] = pd.to_numeric(frame["quantity"], errors="coerce").fillna(0.0)
    if frame.empty:
        return pd.DataFrame(columns=empty_columns)

    attrs = (
        frame.sort_values("inventory_id")
        .groupby("product_id", dropna=False, as_index=False)
        .first()[
            [
                "product_id",
                "product_name",
                "category",
                "supplier_company",
                "reorder_level",
                "target_level",
                "list_price",
                "standard_cost",
                "discontinued",
            ]
        ]
    )
    qty = frame.pivot_table(
        index="product_id",
        columns="type_id",
        values="quantity",
        aggfunc="sum",
        fill_value=0,
    )
    qty = qty.rename(columns={1: "purchased", 2: "sold", 3: "on_hold", 4: "waste"})
    for column in ("purchased", "sold", "on_hold", "waste"):
        if column not in qty.columns:
            qty[column] = 0
    qty = qty[["purchased", "sold", "on_hold", "waste"]].reset_index()

    position = attrs.merge(qty, on="product_id", how="left")
    for column in ("purchased", "sold", "on_hold", "waste"):
        position[column] = pd.to_numeric(position[column], errors="coerce").fillna(0.0)
    position["on_hand"] = position["purchased"] - position["sold"] - position["waste"]
    position["available"] = position["on_hand"] - position["on_hold"]
    position["stock_value"] = position["on_hand"] * pd.to_numeric(
        position["standard_cost"], errors="coerce"
    ).fillna(0.0)
    reorder = pd.to_numeric(position["reorder_level"], errors="coerce")
    discontinued = pd.to_numeric(position["discontinued"], errors="coerce").fillna(0)
    position["below_reorder"] = reorder.notna() & (position["on_hand"] < reorder) & (discontinued == 0)
    return position.sort_values("on_hand")
