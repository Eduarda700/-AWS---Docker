#!/bin/bash

# Atualizações do sistema
apt-get update -y
apt-get upgrade -y

# Instalação de pacotes
apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    aws-cli \
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


systemctl start docker
systemctl enable docker


usermod -aG docker ubuntu

# Montagem do EFS
mkdir -p /mnt/efs


EFS_ID=fs-XXXXXXXX
REGIAO= XX-XXXX-XX
mount -t nfs4 -o nfsvers=4.1 ${EFS_ID}.efs.${REGIAO}.amazonaws.com:/ /mnt/efs

# Entrada no fstab para montagem automática
echo "${EFS_ID}.efs.${REGIAO}.amazonaws.com:/ /mnt/efs nfs4 defaults,_netdev 0 0" >> /etc/fstab

chown -R 33:33 /mnt/efs

# Criação do arquivo docker-compose.yml com volume no EFS
cat <<EOF > /home/ubuntu/compose.yml
services:
  wordpress:
    image: wordpress
    restart: always
    ports:
      - 80:80
    environment:
      WORDPRESS_DB_HOST: 
      WORDPRESS_DB_USER: 
      WORDPRESS_DB_PASSWORD: 
      WORDPRESS_DB_NAME: 
    volumes:
      - /mnt/efs: /var/www/html

  db:
    image: mysql:8.0
    restart: always
    environment:
      MYSQL_DATABASE: 
      MYSQL_USER: 
      MYSQL_PASSWORD:
      MYSQL_ROOT_PASSWORD: 
    volumes:
      - db:/var/lib/mysql
      

volumes:
  worldpress_data:
  db:
EOF

# Executa o docker compose
docker compose -f /home/ubuntu/compose.yml up -d
