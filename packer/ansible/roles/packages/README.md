Role Name
=========

Correria, doc ta zoada.

Role ansible que abstrai o processo de instalação de repositorios apt, chaves de criptografia, pacotes apt ( com opção de pinar uma versão de pacote), pacotes debian fora de um repositorio ( de uma URL por ex.).

ex de estrutura completa:

```YAML
 packages:
   apt_repos:
     - name: Hashicorp
       apt_key_url: https://apt.releases.hashicorp.com/gpg
       repo: "deb [arch=amd64] https://apt.releases.hashicorp.com {{ ansible_facts['lsb']['codename']  }} main"
   apt_packages:
   - python-netaddr
   - python3-pip
   - "vault=1.12.1-1"
   pinned_apt_packages:
   - vault
   pip_packages:
   - netaddr
   deb_packages:
     - "http://archive.ubuntu.com/ubuntu/pool/universe/c/cowsay/cowsay_3.03+dfsg2-8_all.deb"
     - "/tmp/av/pacote.deb"
```