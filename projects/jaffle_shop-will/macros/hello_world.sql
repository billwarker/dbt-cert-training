{% macro hello_world(name, subject = 'World') %}

{{ log("My name is " ~ name ~ " and I say hello to the " ~ subject ~ " !!!", info=True) }}

{% endmacro %}