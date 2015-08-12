include:
  - nova-kilo.server

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
        admin_auth_url = http://{{ pillar['keystone.ip'] }}:35357/v2.0
        admin_tenant_name = service
        admin_username = neutron
        admin_password = {{ pillar['neutron.pass'] }}
        service_metadata_proxy = True
        metadata_proxy_shared_secret = {{ pillar['neutron.metadata.pass'] }}
    - require_in:
        - file: /etc/nova/nova.conf

