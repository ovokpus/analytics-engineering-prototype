with source as (

    select * from {{ source('northwind', 'purchase_orders') }}
)
select 
    *,
    {{ dbt.current_timestamp() }} as ingestion_timestamp
from source