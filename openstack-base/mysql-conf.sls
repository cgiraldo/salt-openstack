/etc/mysql/conf.d/mysqld_openstack.cnf:
  file.managed:
    - source: salt://openstack-base/files/mysql.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
  require:
    - service: mysql
