{%- from "glance-kilo/map.jinja" import glance with context %}

glance-client:
  pkg.installed:
    - refresh: False
    - name: {{ glance.client_pkg }}
