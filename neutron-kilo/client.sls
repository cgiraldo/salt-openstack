{%- from "neutron-kilo/map.jinja" import neutron with context %}

neutron-client:
  pkg.installed:
    - refresh: False
    - name: {{ neutron.client_pkg }}
