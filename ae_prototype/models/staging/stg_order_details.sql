with source as (

    select * from {{ source('northwind', 'order_details') }}
)
select 
    *,
    {{ dbt.current_timestamp() }} as ingestion_timestamp
from source