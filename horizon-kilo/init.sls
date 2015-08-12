include:
  - kilo-repo

openstack-dashboard:
  pkg.installed:
    - name: openstack-dashboard
    - require:
       - pkgrepo: kilo

  service.running:
    - name: apache2
    - enable: True
    - restart: True
    - require:
      - pkg: openstack-dashboard
      - file: /etc/openstack-dashboard/local_settings.py
    - watch:
      - file: /etc/openstack-dashboard/local_settings.py


/etc/openstack-dashboard/local_settings.py:
   file.managed:
     - source: salt://horizon-kilo/files/local_settings.py
     - template: jinja
     - require:
       - pkg: openstack-dashboard


# This is a patch to correct a bug in openstack-dashobard-2015.1.0-0ubuntu1. 1:2015.1.0-0ubuntu1
# 
# bug info: https://bugs.launchpad.net/horizon/+bug/1451429
#
# Cannonical should update its openstack-dashboard pkg at some point in the future and this patch apply should be removed

/usr/share/openstack-dashboard/openstack_dashboard/api/glance.py:
   file.managed:
       - source: salt://horizon-kilo/files/glance.py
       - onchanges: 
          - pkg: openstack-dashboard

