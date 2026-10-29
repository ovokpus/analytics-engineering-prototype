-- Calendar dimension from 2014-01-01 through 2050-01-01.
-- BigQuery and Postgres date functions differ, so each warehouse has its
-- own branch. The column names stay the same. This dimension is not yet
-- joined into the facts; the dashboard filters on fact dates directly.
{% if target.type == 'bigquery' %}

select
  format_date('%F', d)  as id,
  d                     as full_date,
  extract(YEAR from d)  as year,
  extract(WEEK from d)  as year_week,
  extract(DAY from d)   as year_day,
  extract(YEAR from d)  as fiscal_year,
  format_date('%Q', d)  as fiscal_qtr,
  extract(MONTH from d) as month,
  format_date('%B', d)  as month_name,
  format_date('%w', d)  as week_day,
  format_date('%A', d)  as day_name,
  (case when format_date('%A', d) in ('Sunday', 'Saturday') then 0 else 1 end) as day_is_weekday
from (
  select
    *
  from
    unnest(generate_date_array('2014-01-01', '2050-01-01', interval 1 day)) as d )

{% elif target.type == 'postgres' %}

select
    to_char(d::date, 'YYYY-MM-DD') as id,
    d::date as full_date,
    cast(extract(year from d) as integer) as year,
    cast(extract(week from d) as integer) as year_week,
    cast(extract(doy from d) as integer) as year_day,
    cast(extract(year from d) as integer) as fiscal_year,
    to_char(d, 'Q') as fiscal_qtr,
    cast(extract(month from d) as integer) as month,
    to_char(d, 'FMMonth') as month_name,
    cast(extract(dow from d) as integer) as week_day,
    to_char(d, 'FMDay') as day_name,
    case when extract(dow from d) in (0, 6) then 0 else 1 end as day_is_weekday
from generate_series(
    '2014-01-01'::timestamp,
    '2050-01-01'::timestamp,
    interval '1 day'
) as series(d)

{% else %}

{{ exceptions.raise_compiler_error("dim_date supports bigquery and postgres, not " ~ target.type) }}

{% endif %}
