-- Fail the build when the sales desk would open onto an empty table.
select count(*) as row_count
from {{ ref('obt_sales_overview') }}
having count(*) = 0
