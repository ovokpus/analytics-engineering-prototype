-- Deduplicated sales order lines.
-- BigQuery date-partitions this table. The output columns are listed
-- explicitly because Postgres has no SELECT * EXCEPT.
{% if target.type == 'bigquery' %}
{{ config(
    partition_by={
      "field": "order_date",
      "data_type": "date"
    }
) }}
{% endif %}

with source as (
    select
        od.order_id,
        od.product_id,
        o.customer_id,
        o.employee_id,
        o.shipper_id,
        od.quantity,
        od.unit_price,
        od.discount,
        od.status_id,
        od.date_allocated,
        od.purchase_order_id,
        od.inventory_id,
        date(o.order_date) as order_date,
        o.shipped_date,
        o.paid_date,
        {{ dbt.current_timestamp() }} as insertion_timestamp
    from {{ ref('stg_orders') }} o
    left join {{ ref('stg_order_details') }} od
        on od.order_id = o.id
    where od.order_id is not null
),

unique_source as (
    select
        *,
        row_number() over (
            partition by
                customer_id,
                employee_id,
                order_id,
                product_id,
                shipper_id,
                purchase_order_id,
                shipper_id,
                order_date
        ) as row_number
    from source
)

select
    order_id,
    product_id,
    customer_id,
    employee_id,
    shipper_id,
    quantity,
    unit_price,
    discount,
    status_id,
    date_allocated,
    purchase_order_id,
    inventory_id,
    order_date,
    shipped_date,
    paid_date,
    insertion_timestamp
from unique_source
where row_number = 1
