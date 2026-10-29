-- Fail the build when inventory reporting would open onto an empty table.
select count(*) as row_count
from {{ ref('obt_product_inventory') }}
having count(*) = 0
