-- Basic Macro

{% macro hello_world(name, subject = 'World') %}

My name is {{ name }} and I say hello to the {{ subject }} !!!

{% endmacro %}