{% macro get_struct_columns(relation, struct_col) %}

{% set relation_query %}
    select
        {{ struct_col }}
    from {{ relation }}
    limit 1
{% endset %}

{% set results = run_query(relation_query) %}

{% if execute %}

    {% set results_list = results.columns[0].values() %}
    {% set results_dict = fromjson(results_list[0]) %}
    {% set output = results_dict.keys() | list %}

{% else %}

    {% set output = [] %}

{% endif %}

{{ return(output) }}

{% endmacro %}