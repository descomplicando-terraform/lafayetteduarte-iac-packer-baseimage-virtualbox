# lafayetteduarte_groundwork
repo de groundwork para projeto final - descomplicando terraform - turma 2024

# Requisitos
- Virtualbox + virtualbox aditions instalado na máquina.

# Executando o build da imagem

Defina o caminho base onde as imagens devem ser salvas.
preencha a variavel de ambiente e execute o build.
ex:

```BASH
BASE_IMAGE_PATH=~/image-path/images packer build .
```

# Ansible roles.

## packages
Role que instala repositorios e pacotes.

ex completo:

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

# Referencias:
repo com exemplos de packer para libvirt e virtualbox
[Exemplos](https://github.dev/alvistack/vagrant-ubuntu/blob/master/packer/ubuntu-22.04-virtualbox/packer.json)

# Pegadinhas
- user-data precisa estar OK para o funcionamento correto.
  veja https://canonical-subiquity.readthedocs-hosted.com/en/latest/reference/autoinstall-reference.html para mais info.
  OBS importante: Auto install do ubuntu != cloudinit.. não faça como yours trully e morra de raiva..



# Variaveis de Ambiente
 IMAGE_PATH - path to save the built images
 SSH_DEFAULT_KEY (TODO) - default ssh key
 IMAGE_VERSION - version of the image - if not provided, current UTC time will be used as a default value


# TODOS
- redner user-data with a template
