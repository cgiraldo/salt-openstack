include:
  - kilo-repo
  - nova-kilo.computenode

neutron-plugin-ml2:
  pkg.installed:
    - name: neutron-plugin-ml2
    - require:
      - pkgrepo: kilo
      - sysctl: net.bridge.bridge-nf-call-iptables
      - sysctl: net.bridge.bridge-nf-call-ip6tables
      - sysctl: net.ipv4.conf.all.rp_filter
      - sysctl: net.ipv4.conf.default.rp_filter

neutron-plugin-openvswitch-agent:
  pkg.installed:
    - require:
       - pkgrepo: kilo
  service.running:
    - name: neutron-plugin-openvswitch-agent
    - enable: True
    - restart: True
    - require:
      - pkg: neutron-plugin-openvswitch-agent
      - file: /etc/neutron/plugins/ml2/ml2_conf.ini
      - file: /etc/neutron/neutron.conf
    - watch:
      - file: /etc/neutron/plugins/ml2/ml2_conf.ini
      - file: /etc/neutron/neutron.conf

net.ipv4.conf.all.rp_filter:
   sysctl.present:
       - value: 0

net.ipv4.conf.default.rp_filter:
   sysctl.present:
       - value: 0

net.bridge.bridge-nf-call-iptables:
   sysctl.present:
       - value: 1

net.bridge.bridge-nf-call-ip6tables:
   sysctl.present:
       - value: 1

/etc/neutron/neutron.conf:
  file.managed:
    - source: salt://neutron-kilo/files/neutron.conf_compute
    - template: jinja

/etc/neutron/plugins/ml2/ml2_conf.ini:
  file.managed:
    - source: salt://neutron-kilo/files/ml2_conf.ini_compute
    - template: jinja
    - require:
      - pkg: neutron-plugin-ml2

add_default_settings:
  file.accumulated:
    - name: extra-nova-settings-DEFAULT
    - filename: /etc/nova/nova.conf
    - text: |
        network_api_class = nova.network.neutronv2.api.API
        security_group_api = neutron
        linuxnet_interface_driver = nova.network.linux_net.LinuxOVSInterfaceDriver
        firewall_driver = nova.virt.firewall.NoopFirewallDriver
    - require_in:
      - file: /etc/nova/nova.conf

add_neutron_settings:
  file.accumulated:
    - name: extra-nova-settings-end
    - filename: /etc/nova/nova.conf
    - text: |
        [neutron]
        url = http://{{ pillar['neutron.ip'] }}:9696
        auth_strategy = keystone
        admin_auth_url = http://{{ salt['pillar.get']('keystone.ip','localhost') }}:35357/v2.0
        admin_tenant_name = service
        admin_username = neutron
        admin_password = {{ pillar['neutron.pass'] }}
    - require_in:
        - file: /etc/nova/nova.conf

