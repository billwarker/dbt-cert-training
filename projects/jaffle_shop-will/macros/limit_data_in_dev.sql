{% macro limit_data_in_dev(column_name, days_of_data=3) -%}
{% if target.name == 'dev' -%}

where {{ column_name }} >= date_sub(current_date(), interval {{ days_of_data }} day)

{%- endif %}
{%- endmacro %}