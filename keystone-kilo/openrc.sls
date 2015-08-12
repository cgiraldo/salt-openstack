/root/admin-openrc.sh:
  file.managed:
    - contents: |
        export OS_PROJECT_DOMAIN_ID=default
        export OS_USER_DOMAIN_ID=default
        export OS_PROJECT_NAME=admin
        export OS_TENANT_NAME=admin
        export OS_USERNAME=admin
        export OS_PASSWORD={{ pillar['keystone.admin']['password'] }}
        export OS_AUTH_URL=http://{{ salt['pillar.get']('keystone.ip',localhost) }}:35357/v3

{% if pillar['keystone.demo'] is defined %}
/root/demo-openrc.sh:
  file.managed:
    - contents: |
        export OS_PROJECT_DOMAIN_ID=default
        export OS_USER_DOMAIN_ID=default
        export OS_PROJECT_NAME=demo
        export OS_TENANT_NAME=demo
        export OS_USERNAME=demo
        export OS_PASSWORD={{ pillar['keystone.demo']['password'] }}
        export OS_AUTH_URL=http://{{ salt['pillar.get']('keystone.ip',localhost) }}:5000/v3
{% endif %}
