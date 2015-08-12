
ubuntu-cloud-keyring:
  pkg.installed

ntp:
  pkg.installed : []
  service.running:
    - require:
      - pkg: ntp

kilo:
  pkgrepo.managed:
   - name: deb http://ubuntu-cloud.archive.canonical.com/ubuntu trusty-updates/kilo main
   - require:
     - pkg: ubuntu-cloud-keyring
