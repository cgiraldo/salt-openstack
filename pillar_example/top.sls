base:
  '*':
    - openstack-services

  'controller':
    - net.controller
    - rabbitmq
    - mysql
    - keystone
    - nova
    - glance
    - neutron

  'compute1,compute2,compute3':
    - match: list
    - rabbitmq
    - nova
    - neutron

  'compute1':
    - net.compute1

  'compute2':
    - net.compute2

  'compute3':
    - net.compute3

  'networknode':
    - net.networknode
    - rabbitmq
    - nova
    - neutron
