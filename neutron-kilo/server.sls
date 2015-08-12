include:
  - kilo-repo

{%- from "neutron-kilo/map.jinja" import neutron with context %}

neutron-server:
  pkg.installed:
    - pkgs:
      - neutron-server
      - neutron-plugin-ml2
    - require:
      - pkgrepo: kilo
  service.running:
    - enable: True
    - restart: True
    - require:
      - file: /etc/neutron/neutron.conf
    - watch:
      - file: /etc/neutron/neutron.conf

neutron-server_sync_db:
  cmd.run:
    - name: neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head
    - require:
      - file: /etc/neutron/neutron.conf
      - file: /etc/neutron/plugins/ml2/ml2_conf.ini

/etc/neutron/neutron.conf:
  file.managed:
    - source: salt://neutron-kilo/files/neutron.conf
    - template: jinja
    - require:
      - pkg: neutron-server

/etc/neutron/plugins/ml2/ml2_conf.ini:
  file.managed:
    - source: salt://neutron-kilo/files/ml2_conf.ini
    - template: jinja
    - require:
      - pkg: neutron-server
