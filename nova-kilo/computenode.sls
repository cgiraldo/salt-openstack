nova-compute:
  pkg.installed:
    - pkgs:
      - nova-compute
      - sysfsutils
  service.running:
    - enable: True
    - restart: True
    - require:
      - file: /etc/nova/nova.conf
    - watch:
      - file: /etc/nova/nova.conf

/etc/nova/nova.conf:
  file.managed:
    - source: salt://nova-kilo/files/nova_conf_compute.conf
    - template: jinja
    - require:
      - pkg: nova-compute

# TODO: now we take the assumption the compute node supports hardware acceleration 
# with typically requires no additional configuration
# egrep -c '(vmx|svm)' /proc/cpuinfo
