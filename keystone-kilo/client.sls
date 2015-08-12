{%- from "keystone-kilo/map.jinja" import keystone with context %}

keystone-client:
  pkg.installed:
    - refresh: False
    - name: {{ keystone.client_pkg }}
