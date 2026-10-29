"""Read the three one-big-table models. Nothing else is queried."""

from __future__ import annotations

import os
from urllib.parse import quote_plus

import pandas as pd
from sqlalchemy import create_engine, text
from sqlalchemy.exc import SQLAlchemyError

SALES_COLUMNS = (
    "order_id",
    "product_name",
    "category",
    "customer_company",
    "customer_city",
    "customer_country_region",
    "employee_first_name",
    "employee_last_name",
    "quantity",
    "unit_price",
    "discount",
    "order_date",
)

CUSTOMER_COLUMNS = (
    "customer_id",
    "customer_company",
    "customer_city",
    "customer_country_region",
    "product_id",
    "product_name",
    "category",
    "supplier_company",
    "purchase_order_id",
    "inventory_id",
    "supplier_id",
    "quantity",
    "unit_cost",
    "creation_date",
    "payment_amount",
    "payment_method",
    "shipping_fee",
    "taxes",
)

INVENTORY_COLUMNS = (
    "product_id",
    "product_name",
    "category",
    "supplier_company",
    "standard_cost",
    "list_price",
    "reorder_level",
    "target_level",
    "discontinued",
    "inventory_id",
    "transaction_type",
    "transaction_created_date",
    "quantity",
)


class WarehouseError(Exception):
    """The OBT tables could not be read."""


def _schema() -> str:
    schema = os.environ.get("OBT_SCHEMA", "obt_northwind")
    if not schema.replace("_", "").isalnum():
        raise WarehouseError(f"OBT_SCHEMA is not a plain identifier: {schema}")
    return schema


def _engine():
    host = os.environ.get("POSTGRES_HOST", "localhost")
    port = os.environ.get("POSTGRES_PORT", "5432")
    user = quote_plus(os.environ.get("POSTGRES_USER", "analytics"))
    password = quote_plus(os.environ.get("POSTGRES_PASSWORD", "analytics"))
    database = os.environ.get("POSTGRES_DB", "northwind")
    url = f"postgresql+psycopg2://{user}:{password}@{host}:{port}/{database}"
    return create_engine(url, connect_args={"connect_timeout": 5})


def _read(table: str, required: tuple[str, ...]) -> pd.DataFrame:
    schema = _schema()
    sql = f"select * from {schema}.{table}"
    try:
        frame = pd.read_sql(text(sql), _engine())
    except SQLAlchemyError as exc:
        raise WarehouseError(
            "Could not read "
            f"{schema}.{table}. Start the stack with `docker compose up --build` "
            "and wait until the dbt step finishes. "
            f"Database said: {exc.__class__.__name__}"
        ) from exc

    frame.columns = [str(column).lower() for column in frame.columns]
    missing = [column for column in required if column not in frame.columns]
    if missing:
        raise WarehouseError(
            f"{schema}.{table} is missing columns the desk needs: {', '.join(missing)}"
        )
    return frame


def load_tables() -> dict[str, pd.DataFrame]:
    """Return sales, customer, and inventory frames from the OBT schema."""
    return {
        "sales": _read("obt_sales_overview", SALES_COLUMNS),
        "customers": _read("obt_customer_reporting", CUSTOMER_COLUMNS),
        "inventory": _read("obt_product_inventory", INVENTORY_COLUMNS),
    }
