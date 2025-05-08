#!/bin/bash

# Atualizações do sistema
apt-get update -y
apt-get upgrade -y

# Instalação de pacotes necessários
apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    nfs-common

# Instalação do Docker
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Inicia e habilita o Docker
systemctl start docker
systemctl enable docker

# Adiciona o usuário ubuntu ao grupo docker
usermod -aG docker ubuntu

# Montagem do EFS
mkdir -p /mnt/efs

# Substitua fs-XXXX e região pela sua configuração
EFS_ID=fs-XXXXXXXX
REGIAO=sa-east-1
mount -t nfs4 -o nfsvers=4.1 ${EFS_ID}.efs.${REGIAO}.amazonaws.com:/ /mnt/efs

# Entrada no fstab para montagem automática
echo "${EFS_ID}.efs.${REGIAO}.amazonaws.com:/ /mnt/efs nfs4 defaults,_netdev 0 0" >> /etc/fstab

# Criação do arquivo docker-compose.yml com volume no EFS
cat <<EOF > /home/ubuntu/compose.yml
services:
  wordpress:
    image: wordpress
    restart: always
    ports:
      - 8080:80
    environment:
      WORDPRESS_DB_HOST: database-1.ci160cos42vm.us-east-1.rds.amazonaws.com
      WORDPRESS_DB_USER: admin
      WORDPRESS_DB_PASSWORD: 8BhOGK0C5Q42vb1wiYdb
      WORDPRESS_DB_NAME: MyDBWP
    volumes:
      - type: bind
        source: /mnt/efs
        target: /var/www/html

  db:
    image: mysql:8.0
    restart: always
    environment:
      MYSQL_DATABASE: MyDBWP
      MYSQL_USER: admin
      MYSQL_PASSWORD: 8BhOGK0C5Q42vb1wiYdb
      MYSQL_ROOT_PASSWORD: 8BhOGK0C5Q42vb1wiYdb
    volumes:
      - db:/var/lib/mysql

volumes:
  db:
EOF

# Executa o docker compose
docker compose -f /home/ubuntu/compose.yml up -d
