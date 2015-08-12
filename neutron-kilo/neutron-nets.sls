create_external_net:
    cmd.run:
      - name: | 
          neutron --os-password {{ pillar['neutron.pass'] }} --os-username neutron \
          --os-auth-url http://{{ pillar['keystone.ip'] }}:35357/v3 --os-project-name service \
          --os-project-domain-id default --os-user-domain-id default \
          net-create ext-net --router:external --provider:physical_network external --provider:network_type flat

create_external_subnet:
    cmd.run:
      - name: |
          neutron --os-password {{ pillar['neutron.pass'] }} --os-username neutron \
          --os-auth-url http://{{ pillar['keystone.ip'] }}:35357/v3 --os-project-name service \
          --os-project-domain-id default --os-user-domain-id default \
          subnet-create ext-net {{ pillar['neutron.ext-subnet']['cidr']}} --name ext-subnet \
           --allocation-pool start={{ pillar['neutron.ext-subnet']['start']}},end={{ pillar['neutron.ext-subnet']['end']-}} \
           --disable-dhcp --gateway {{ pillar['neutron.ext-subnet']['gw']}}
