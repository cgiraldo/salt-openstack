include:
  - kilo-repo

keystone:
  pkg.installed:
    - pkgs:
       - keystone
       - memcached
       - python-memcache
       - apache2
       - libapache2-mod-wsgi
    - require:
       - pkgrepo: kilo

  service.running:
    - name: apache2
    - enable: True
    - restart: True
    - require:
      - pkg: keystone
      - file: /etc/apache2/sites-available/wsgi-keystone.conf
      - file: /etc/apache2/apache2.conf
      - file: /etc/keystone/keystone.conf
    - watch:
      - file: /etc/keystone/keystone.conf
      - file: /etc/apache2/sites-available/wsgi-keystone.conf


keystone_sync_db:
  cmd.run:
    - name: keystone-manage db_sync
    - require:
      - file: /etc/keystone/keystone.conf

/etc/keystone/keystone.conf:
  file.managed:
    - source: salt://keystone-kilo/files/keystone.conf
    - template: jinja
    - require:
      - pkg: keystone

/etc/apache2/apache2.conf:
  file.append:
    - text: ServerName {{ salt['grains.get']('host', 'localhost') }}
    - require: 
      - pkg: keystone

/etc/apache2/sites-available/wsgi-keystone.conf:
  file.managed:
    - source: salt://keystone-kilo/files/wsgi-keystone.conf

/etc/apache2/sites-enabled/wsgi-keystone.conf:
  file.symlink:
    - target: /etc/apache2/sites-available/wsgi-keystone.conf
    - require:
      - file: /etc/apache2/sites-available/wsgi-keystone.conf

/etc/init/keystone.override:
  file.managed:
    - contents: manual
    - require_in:
      - pkg: keystone

/var/www/cgi-bin/keystone:
  file.recurse:
    - source: salt://keystone-kilo/files/cgi-bin
    - user: keystone
    - group: keystone
    - file_mode: 755
