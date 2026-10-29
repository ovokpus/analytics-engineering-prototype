with source as (

    select * from {{ source('northwind', 'inventory_transactions') }}
)
select 
    *,
    {{ dbt.current_timestamp() }} as ingestion_timestamp
from source