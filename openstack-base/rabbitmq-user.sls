
create_openstack_rabbitmq_user:
  rabbitmq_user.present:
    - password: {{ pillar['rabbitmq.pass'] }}
    - force: True
    - perms:
      - '/':
        - '.*'
        - '.*'
        - '.*'
    - runas: root
  require:
    - pkg: rabbitmq-server
   
