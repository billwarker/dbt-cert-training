{% test assert_str_column_has_no_blanks(model, column_name) %}

select
    {{ column_name }}
from {{ model }}
where
    {{ column_name }} = ''

{% endtest %}