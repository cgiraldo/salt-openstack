include:
  - kilo-repo

{%- from "glance-kilo/map.jinja" import glance with context %}

{{ glance.name }}:
  pkg.installed:
    - refresh: False
    - name: {{ glance.pkg }}
    - require:
       - pkgrepo: kilo

  service.running:
    - name: {{ glance.service_api }}
    - enable: True
    - restart: True
    - require:
      - pkg: {{ glance.name }}
      - file: /etc/glance/glance-api.conf
    - watch:
      - file: /etc/glance/glance-api.conf

{{ glance.service_registry }}:
  pkg.installed:
    - refresh: False
    - name: {{ glance.pkg }}
    - require:
       - pkgrepo: kilo
  service.running:
    - name: {{ glance.service_registry }}
    - enable: True
    - restart: True
    - require:
      - pkg: {{ glance.name }}
      - file: /etc/glance/glance-registry.conf
    - watch:
      - file: /etc/glance/glance-registry.conf

{{ glance.name }}_sync_db:
  cmd.run:
    - name: glance-manage db_sync
    - require:
      - file: /etc/glance/glance-api.conf

/etc/glance/glance-api.conf:
  file.managed:
    - source: salt://glance-kilo/files/glance-api.conf
    - template: jinja
    - require:
      - pkg: {{ glance.name }}

/etc/glance/glance-registry.conf:
  file.managed:
    - source: salt://glance-kilo/files/glance-registry.conf
    - template: jinja
    - require:
      - pkg: {{ glance.name }}
