with source as (

    select * from {{ source('northwind', 'orders') }}
)
select 
    *,
    {{ dbt.current_timestamp() }} as ingestion_timestamp
from source