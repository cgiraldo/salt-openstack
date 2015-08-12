{%- set name="glance" %}

{{ name }}-db:
  mysql_database.present:
    - name: {{ name }}
  mysql_user.present:
    - name: {{ name }}
    - host: "{{ salt["pillar.get"]("mysql.host","%") }}"
    - password: {{ pillar[name + ".dbpass"] }}
  mysql_grants.present:
    - host: "{{ salt["pillar.get"]("mysql.host","%") }}"
    - grant: all privileges
    - database: "{{ name }}.*"
    - user: {{ name }}
  require:
    - service: mysql
