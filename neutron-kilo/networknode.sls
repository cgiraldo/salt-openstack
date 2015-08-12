include:
  - kilo-repo

{%- from "neutron-kilo/map.jinja" import neutron with context %}

neutron-plugin-ml2:
  pkg.installed:
    - name: neutron-plugin-ml2
    - require:
      - pkgrepo: kilo
      - sysctl: net.ipv4.ip_forward
      - sysctl: net.ipv4.conf.all.rp_filter
      - sysctl: net.ipv4.conf.default.rp_filter

{% for service, conf in [('neutron-plugin-openvswitch-agent', '/etc/neutron/neutron.conf' ),
                         ('neutron-l3-agent', '/etc/neutron/l3_agent.ini'),
                         ('neutron-dhcp-agent', '/etc/neutron/dhcp_agent.ini'),
                         ('neutron-metadata-agent','/etc/neutron/metadata_agent.ini')] %}

{{service}}:
  pkg.installed:
    - require:
       - pkgrepo: kilo
  service.running:
    - name: {{ service }}
    - enable: True
    - restart: True
    - require:
      - pkg: {{ service }}
      - file: {{ conf }}
    - watch:
      - file: {{ conf }}
{% endfor %}

net.ipv4.ip_forward:
   sysctl.present:
       - value: 1
net.ipv4.conf.all.rp_filter:
   sysctl.present:
       - value: 0

net.ipv4.conf.default.rp_filter:
   sysctl.present:
       - value: 0

ethtool:
  pkg.installed: []

br-ex:
    cmd.run:
        - name: |
                ovs-vsctl br-exists br-ex || ovs-vsctl add-br br-ex;
                ovs-vsctl add-port br-ex {{ pillar['external']['iface'] }};
                ethtool -K {{ pillar['external']['iface'] }} gro off
        - require:
             - service: neutron-plugin-openvswitch-agent
             - pkg: ethtool

/etc/neutron/neutron.conf:
  file.managed:
    - source: salt://neutron-kilo/files/neutron.conf_network
    - template: jinja

/etc/neutron/plugins/ml2/ml2_conf.ini:
  file.managed:
    - source: salt://neutron-kilo/files/ml2_conf.ini_network
    - template: jinja
    - require:
      - pkg: neutron-plugin-ml2

/etc/neutron/l3_agent.ini:
  file.managed:
    - source: salt://neutron-kilo/files/l3_agent.ini
    - require:
      - pkg: neutron-l3-agent

/etc/neutron/dhcp_agent.ini:
  file.managed:
    - source: salt://neutron-kilo/files/dhcp_agent.ini
    - require:
      - pkg: neutron-dhcp-agent
      - file: /etc/neutron/dnsmasq-neutron.conf

/etc/neutron/dnsmasq-neutron.conf:
  file.managed:
    - contents: dhcp-option-force=26,1454
    - require:
      - pkg: neutron-dhcp-agent

kill_dnsmasq:
  cmd.wait:
    - name: pkill dnsmasq
    - watch:
      - file: /etc/neutron/dnsmasq-neutron.conf

/etc/neutron/metadata_agent.ini:
  file.managed:
    - source: salt://neutron-kilo/files/metadata_agent.ini
    - template: jinja
    - require:
      - pkg: neutron-metadata-agent

