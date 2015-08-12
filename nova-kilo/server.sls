include:
  - kilo-repo

{%- from "nova-kilo/map.jinja" import nova with context %}

{% for novaservice in [ 'nova-api','nova-cert', 'nova-conductor', 'nova-consoleauth', 'nova-novncproxy', 'nova-scheduler' ] %}
{{ novaservice }}:
  pkg.installed:
    - name: {{ novaservice }}
    - require:
      - pkgrepo: kilo
  service.running:
    - enable: True
    - restart: True
    - require:
      - file: /etc/nova/nova.conf
    - watch:
      - file: /etc/nova/nova.conf
{% endfor %}

{{ nova.name }}_sync_db:
  cmd.run:
    - name: nova-manage db sync
    - require:
      - file: /etc/nova/nova.conf

/etc/nova/nova.conf:
  file.managed:
    - source: salt://nova-kilo/files/nova.conf
    - template: jinja
    - require:
      - pkg: nova-api
