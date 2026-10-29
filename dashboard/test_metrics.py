"""Checks for the desk math. Run from the repo root: python dashboard/test_metrics.py"""

from __future__ import annotations

import sys
from pathlib import Path

import pandas as pd

sys.path.insert(0, str(Path(__file__).resolve().parent))

from metrics import customer_links, display_product, inventory_position, net_revenue, purchase_lines


def test_revenue_applies_fractional_discount() -> None:
    revenue = net_revenue(pd.Series([10]), pd.Series([5.0]), pd.Series([0.1]))
    assert abs(float(revenue.iloc[0]) - 45.0) < 1e-9


def test_missing_discount_does_not_zero_the_line() -> None:
    revenue = net_revenue(pd.Series([2]), pd.Series([8.0]), pd.Series([None]))
    assert abs(float(revenue.iloc[0]) - 16.0) < 1e-9


def test_on_hand_subtracts_sales_and_waste_but_not_hold() -> None:
    frame = pd.DataFrame(
        [
            _txn(1, 100, 1),
            _txn(2, 30, 2),
            _txn(3, 5, 4),
            _txn(4, 8, 3),
        ]
    )
    row = inventory_position(frame).iloc[0]
    assert row["on_hand"] == 65
    assert row["available"] == 57
    assert bool(row["below_reorder"]) is False


def test_stock_under_reorder_is_flagged() -> None:
    frame = pd.DataFrame([_txn(1, 4, 1)])
    row = inventory_position(frame).iloc[0]
    assert row["on_hand"] == 4
    assert bool(row["below_reorder"]) is True


def test_purchase_lines_collapse_the_customer_fanout() -> None:
    frame = pd.DataFrame(
        [
            _purchase(customer_id=1),
            _purchase(customer_id=2),
        ]
    )
    lines = purchase_lines(frame)
    assert len(lines) == 1
    assert float(lines["extended_cost"].sum()) == 20


def test_missing_product_name_keeps_the_id() -> None:
    labels = display_product(pd.Series([None, "Northwind Traders Chai"]), pd.Series([43, 1]))
    assert labels.iloc[0] == "Product 43"
    assert labels.iloc[1] == "Chai"


def test_customer_links_keep_each_customer() -> None:
    frame = pd.DataFrame(
        [
            _purchase(customer_id=1, company="Company A"),
            _purchase(customer_id=2, company="Company B"),
        ]
    )
    links = customer_links(frame)
    assert set(links["customer_company"]) == {"Company A", "Company B"}
    assert int(links["linked_units"].sum()) == 20


def _txn(inventory_id: int, quantity: int, transaction_type: int) -> dict[str, object]:
    return {
        "product_id": 1,
        "product_name": "Northwind Traders Chai",
        "category": "Beverages",
        "supplier_company": "Supplier A",
        "reorder_level": 10,
        "target_level": 40,
        "list_price": 18,
        "standard_cost": 13.5,
        "discontinued": 0,
        "inventory_id": inventory_id,
        "transaction_type": transaction_type,
        "quantity": quantity,
    }


def _purchase(customer_id: int, company: str = "Company A") -> dict[str, object]:
    return {
        "customer_id": customer_id,
        "customer_company": company,
        "customer_city": "Seattle",
        "customer_country_region": "USA",
        "purchase_order_id": 9,
        "product_id": 4,
        "inventory_id": 3,
        "supplier_id": 1,
        "creation_date": "2006-04-01",
        "quantity": 10,
        "unit_cost": 2,
    }


def main() -> None:
    test_revenue_applies_fractional_discount()
    test_missing_discount_does_not_zero_the_line()
    test_on_hand_subtracts_sales_and_waste_but_not_hold()
    test_stock_under_reorder_is_flagged()
    test_purchase_lines_collapse_the_customer_fanout()
    test_missing_product_name_keeps_the_id()
    test_customer_links_keep_each_customer()
    print("metric checks passed")


if __name__ == "__main__":
    main()
