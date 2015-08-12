system:
    network.system:
      - enabled: True
      - hostname: {{ salt['grains.get']('host') }}
      - gateway: {{ salt['pillar.get']('mgmt:gw') }}
      - gatewaydev: {{ salt['pillar.get']('mgmt:iface') }}
      - nozeroconf: True
      - require_reboot: True

{{ salt['pillar.get']('mgmt:iface') }}:
  network.managed:
    - enabled: True
    - type: eth
    - proto: none
    - ipaddr: {{ salt['pillar.get']('mgmt:ip') }}
    - gateway: {{ salt['pillar.get']('mgmt:gw') }}
    - netmask: {{ salt['pillar.get']('mgmt:netmask') }} 
    - dns:
      - 8.8.8.8
      - 8.8.4.4

{{ salt['pillar.get']('tun:iface') }}:
  network.managed:
    - enabled: True
    - type: eth
    - proto: none
    - ipaddr: {{ salt['pillar.get']('tun:ip') }}
    - netmask: {{ salt['pillar.get']('tun:netmask') }} 

{% if pillar['storage'] is defined %}
{{ salt['pillar.get']('storage:iface') }}:
  network.managed:
    - enabled: True
    - type: eth
    - proto: none
    - ipaddr: {{ salt['pillar.get']('storage:ip') }}
    - netmask: {{ salt['pillar.get']('storage:netmask') }} 
    - dns:
      - 8.8.8.8
      - 8.8.4.4
{% endif %}
