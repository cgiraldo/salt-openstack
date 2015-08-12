{% set name = "neutron" %}
{% set type = "network" %}
{% set port = "9696" %}


keystone_{{ name }}_user:
  keystone.user_present:
    - name: {{ name }}
    - password: {{ pillar[ name +'.pass'] }}
    - email: {{ pillar[ name +'.email'] }}
    - tenant: service
    - enable: True
    - roles:
        service:
          - admin
    - connection_token: {{ pillar['keystone.token'] }}

keystone_{{ name }}_service:
  keystone.service_present:
    - name: {{ name }}
    - service_type: {{ type }}
    - description: Openstack {{ type }} Service
    - connection_token: {{ pillar['keystone.token'] }}

keystone_{{ name }}_endpoint:
  keystone.endpoint_present:
    - name: {{ name }}
    - publicurl: http://{{ pillar[ name + '.ip'] }}:{{ port }}
    - internalurl: http://{{ pillar[ name + '.ip'] }}:{{ port }}
    - adminurl: http://{{ pillar[ name + '.ip'] }}:{{ port }}
    - region: RegionOne
    - connection_token: {{ pillar['keystone.token'] }}
