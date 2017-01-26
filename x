---
- name: generate pf.conf file from variable content
  copy: content="{{ pf_file_content }}" dest=/etc/pf.conf mode=0600 owner=root group=wheel
  when: pf_file_content != ''
  register: result

- name: copy pf.conf from ansible host
  copy cocp 
  when: 
    - pf_file_content == ''
    - pf_file_file != ''

- name: load ruleset
  command: sh -c "/sbin/pfctl -n -f /etc/pf.conf && /sbin/pfctl -ef /etc/pf.conf"
  when: result.changed

- name: ensure pf started at boot (FreeBSD)
  service: name={{ pf_service_name }} state=started  enabled=yes
  when: ansible_os_family == 'FreeBSD'

- name: ensure pf started at boot (OpenBSD)
  command: rcctl enable pf
  when: ansible_os_family == 'OpenBSD'

- name: start ftpproxy service
  service: name=ftpproxy state=started enabled=yes
  when: pf_ftpproxy_enable

- name: enable ip forwarding
  sysctl:
    name: "{{ pf_ip_forward_sysctl_value }}"
    value: 1
    sysctl_set: yes
  when: pf_ip_forward_enable

