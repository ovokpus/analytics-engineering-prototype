with source as (
    select * from {{ source('northwind', 'customer')}}
)
select
 *,
 {{ dbt.current_timestamp() }} as ingestion_timestamp
 from source