{%- from "nova-kilo/map.jinja" import nova with context %}

nova-client:
  pkg.installed:
    - refresh: False
    - name: {{ nova.client_pkg }}
