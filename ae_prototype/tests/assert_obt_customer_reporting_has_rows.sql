-- Fail the build when customer reporting would open onto an empty table.
select count(*) as row_count
from {{ ref('obt_customer_reporting') }}
having count(*) = 0
