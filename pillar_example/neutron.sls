neutron.pass: 1eeff4ae131122316433b # Change this password for security reasons
neutron.dbpass: 533674e89d3366785ecc # Change this password for security reasons
neutron.email: admin@example.org
neutron.metadata.pass: fb24563650b8677652a0 # Change this password for security reasons
neutron:
  public_ip: 10.0.0.11
  internal_ip: 10.0.0.11
  admin_ip: 10.0.0.11

neutron.ext-subnet:   # Modify with your external network ip addressing
  cidr: 203.0.113.0/24
  start: 203.0.113.100
  end: 203.0.113.201
  gw: 203.0.113.1
