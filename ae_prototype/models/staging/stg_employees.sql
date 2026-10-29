with source as (

    select * from {{ source('northwind', 'employees') }}
)
select 
    *,
    {{ dbt.current_timestamp() }} as ingestion_timestamp
from source