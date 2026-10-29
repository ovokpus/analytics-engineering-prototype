with source as (

    select * from {{ source('northwind', 'employee_privileges') }}
)
select 
    *,
    {{ dbt.current_timestamp() }} as ingestion_timestamp
from source