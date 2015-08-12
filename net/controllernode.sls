system:
  network.system:
    - enabled: True
    - hostname: {{ salt['grains.get']('host','controller') }}
    - gateway: {{ salt['pillar.get']('public:gw') }}
    - gatewaydev: {{ salt['pillar.get']('public:iface') }}
    - nozeroconf: True
    - require_reboot: True

{{ salt['pillar.get']('public:iface') }}:
  network.managed:
    - enabled: True
    - type: eth
    - proto: none
    - ipaddr: {{ salt['pillar.get']('public:ip') }}
    - gateway: {{ salt['pillar.get']('public:gw') }}
    - netmask: {{ salt['pillar.get']('public:netmask') }}
    - dns:
      - {{ salt['pillar.get']('public:dns1') }}
      - {{ salt['pillar.get']('public:dns2') }}

{{ salt['pillar.get']('mgmt:iface') }}:
  network.managed:
    - enabled: True
    - type: eth
    - proto: none
    - ipaddr: {{ salt['pillar.get']('mgmt:ip') }}
    - netmask: {{ salt['pillar.get']('mgmt:netmask') }} 
