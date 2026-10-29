with source as (

    select * from {{ source('northwind', 'suppliers') }}
)
select 
    *,
    {{ dbt.current_timestamp() }} as ingestion_timestamp
from source