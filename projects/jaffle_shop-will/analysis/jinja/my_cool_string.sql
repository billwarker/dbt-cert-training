-- setting and accessing variables

{% set my_cool_string = "wow, cool" %}
{% set my_cool_number = 100 %}


{{ my_cool_string }}

{{ my_cool_number }}

{% set my_animals = ['hamster', 'pika', 'squirrel'] %}

{{ my_animals[0] }}

-- iteration

{% for animal in my_animals %}

Hello to {{ animal }}

{% endfor %}

-- flow control

{% set temperature = 45 %}

{% if temperature < 45 %}
Too cold

{% else %}
Too hot

{% endif %}

-- Nesting operations

{%- for animal in my_animals -%}

    {%- if temperature < 75 and animal == 'pika' -%}

        {%- set feeling = 'cold' -%}

    {%- else -%}

        {%- set feeling = 'just right' -%}

    {% endif %}

    my {{ animal }} is feeling {{ feeling }}

{%- endfor -%}

-- Dictionaries

{% set my_dict ={'word': 'yeet', 'definition': 'to express joy'} %}

The word {{ my_dict['word'] }} means {{ my_dict['definition'] }}