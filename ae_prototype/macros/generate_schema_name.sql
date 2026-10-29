{% macro generate_schema_name(custom_schema_name, node) -%}
    {#-
      Local docker runs use the schema name from dbt_project.yml as-is
      (stg_northwind, dwh_northwind, obt_northwind) so the dashboard can
      query stable names.

      Every other target keeps dbt's default: <target schema>_<custom schema>.
      On the BigQuery dev target that is curated_zone_stg_northwind and so on.
    -#}
    {%- set default_schema = target.schema -%}
    {%- if custom_schema_name is none -%}
        {{ default_schema }}
    {%- elif target.name == 'local' -%}
        {{ custom_schema_name | trim }}
    {%- else -%}
        {{ default_schema }}_{{ custom_schema_name | trim }}
    {%- endif -%}
{%- endmacro %}
