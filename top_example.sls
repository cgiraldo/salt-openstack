 'controller':
      - net.controllernode
      - mariadb.server
      - rabbitmq.server
      - keystone-kilo
      - glance-kilo
      - nova-kilo
      - neutron-kilo
      - neutron-kilo.novacontrollernode

   'compute1,compute2,compute3':
      - match: list
      - net.computenode
      - nova-kilo.computenode
      - neutron-kilo.computenode

   'networknode':
      - net.networknode
      - neutron-kilo.networknode

