/tmp/wait-port.sh:
  file.managed:
    - source: salt://keystone-kilo/files/wait-port.sh
    - template: jinja

wait-keystone-port:
  cmd.run:
    - name: /bin/bash /tmp/wait-port.sh 30 {{ salt["pillar.get"]("keystone.ip","localhost") }} 35357
    - stateful: True
    - require:
      - file: /tmp/wait-port.sh
    - require_in:
      - keystone: keystone_default_tenants
      - keystone: keystone_default_roles
      - keystone: keystone_keystone_endpoint
      - keystone: keystone_keystone_endpoint

keystone_default_tenants:
  keystone.tenant_present:
    - names:
      - admin
      - service
      - demo
    - connection_token: {{ pillar['keystone.token'] }}

keystone_default_roles:
  keystone.role_present:
    - names:
      - admin
      - user
    - connection_token: {{ pillar['keystone.token'] }}

keystone_admin_user:
  keystone.user_present:
    - name: admin
    - password: {{ pillar['keystone.admin']['password'] }}
    - email: {{ pillar['keystone.admin']['email'] }}
    - tenant: admin
    - enable: True
    - roles:
        admin:
          - admin
    - connection_token: {{ pillar['keystone.token'] }}

{% if pillar['keystone.demo'] is defined %}
keystone_demo_user:
  keystone.user_present:
    - name: demo
    - password: {{ pillar['keystone.demo']['password'] }}
    - email: {{ pillar['keystone.demo']['email'] }}
    - tenant: demo
    - enable: True
    - roles:
        demo:
          - user
    - connection_token: {{ pillar['keystone.token'] }}
{% endif %}

keystone_keystone_service:
  keystone.service_present:
    - name: keystone
    - service_type: identity
    - description: Openstack Identity Service
    - connection_token: {{ pillar['keystone.token'] }}

keystone_keystone_endpoint:
  keystone.endpoint_present:
    - name: keystone
    - publicurl: http://{{ salt["pillar.get"]("keystone.ip","localhost") }}:5000/v2.0
    - internalurl: http://{{ salt["pillar.get"]("keystone.ip","locahost") }}:5000/v2.0
    - adminurl: http://{{ salt["pillar.get"]("keystone.ip","localhost") }}:35357/v2.0
    - connection_token: {{ pillar['keystone.token'] }}

# TODO: Disable temporary authentication token mechanism 
# NOTE: IT should work with pillar keystone.token and keystone.endpoint without connection_token
#      and connection_endpoint, but it doesn't ...
