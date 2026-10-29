with source as (

    select * from {{ source('northwind', 'strings') }}
)
select 
    *,
    {{ dbt.current_timestamp() }} as ingestion_timestamp
from source