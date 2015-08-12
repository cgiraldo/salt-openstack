# This is a patch to correct a bug in openstack-dashobard-2015.1.0-0ubuntu1. 1:2015.1.0-0ubuntu1
# 
# bug info: https://bugs.launchpad.net/horizon/+bug/1451429
#
# Cannonical should update its openstack-dashboard pkg at some point in the future and this patch apply should be removed

/usr/share/openstack-dashboard/openstack_dashboard/api/glance.py:
   file.copy:
       - source: salt://horizon-kilo/files/glance.py
       - force: True
       - onchanges: 
          - pkg: openstack-dashboard
