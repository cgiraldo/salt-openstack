{% set os = salt['grains.get']('os', None) %}
{% set os_family = salt['grains.get']('os_family', None) %}

mariadb-server:
  pkg:
    - installed
    - pkgs:
      - mariadb-server
      - python-mysqldb
  service:
    - running
    - name: mysql
    - enable: True
    - require:
      - pkg: mariadb-server
  mysql_user:
    - present
    - name: root
    - password: {{ pillar['mysql.pass'] }}
    - connection_user: root
    - connection_pass: 
    - connection_charset: utf8
    - require:
      - service: mysql
    - require_in:
      - remove_test_db
      - remove_test_db_all
      - remove_anonymous_user

remove_test_db:
  mysql_database:
    - absent
    - name: test
    - connection_user: root
    - connection_pass: {{ pillar['mysql.pass'] }}
    - connection_charset: utf8

remove_test_db_all:
  mysql_database:
    - absent
    - name: test_%
    - connection_user: root
    - connection_pass: {{ pillar['mysql.pass'] }}
    - connection_charset: utf8

remove_anonymous_user:
  mysql_user:
    - absent
    - name: ''
    - connection_user: root
    - connection_pass: {{ pillar['mysql.pass'] }}
    - connection_charset: utf8

{% if os == 'Ubuntu' %}
get-mariadb-repo:
  pkgrepo.managed:
    - humanname: MariaDB Repo
    - name: deb http://sfo1.mirrors.digitalocean.com/mariadb/repo/10.0/ubuntu {{ salt['grains.get']('oscodename', 'trusty') }} main
    - keyserver: keyserver.ubuntu.com
    - keyid: 1BB943DB
    - refresh_db: True
    - require_in:
      - pkg: mariadb-server

{% elif os_family == 'Debian' %}

  pkgrepo.managed:
    - humanname: MariaDB Repo
    - name: deb http://sfo1.mirrors.digitalocean.com/mariadb/repo/10.0/debian {{ salt['grains.get']('oscodename', 'wheezy') }} main
    - keyserver: keyserver.ubuntu.com
    - keyid: 1BB943DB
    - refresh_db: True
    - require_in:
      - pkg: mariadb-server

{% endif %}
