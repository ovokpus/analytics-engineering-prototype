with source as (

    select * from {{ source('northwind', 'purchase_order_status') }}
)
select 
    *,
    {{ dbt.current_timestamp() }} as ingestion_timestamp
from source