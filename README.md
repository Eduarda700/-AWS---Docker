# Atividade - DevSecOps - Docker

projeto com a seguinte topologia em mente

![Captura de Tela (2)](https://github.com/user-attachments/assets/843bb495-9ef0-4588-9669-3bd3a42f68e3)


## 1 - Criação da Virtual Private Cloud (VPC)

Acesse na barra de busca da AWS e pesquise **VPC**, em seguida clique em **Create VPC**.

![VPC - Criação](https://github.com/user-attachments/assets/ac7a4da3-5d87-425e-b588-b03afa084192)

Nas configurações, escolha a opção **VPC and more**, defina um nome para a VPC, mantenha o IPv4 CIDR block padrão, selecione o número de zonas desejado (para o projeto usaremos **duas**), com **duas subnets públicas** e **duas privadas**. Não foi necessário customizar os blocos, então pule para a configuração do NAT Gateway e selecione um por zona. Desabilite os VPC Endpoints.

![VPC Configuração](https://github.com/user-attachments/assets/93b1e831-0a51-453b-a688-7be3895c22fc)  
![VPC Configuração](https://github.com/user-attachments/assets/c86d6cbc-0e35-461d-9f7d-eabc652a3c3c)

Clique em **Create VPC**.

---

## 2 - Criação dos Security Groups

Com os security groups controlaremos a conexão entre a Database, EFS, EC2 e Load Balancer que permitirá o acesso público ao WordPress.

Pesquise por **Security Group** e clique em **Create Security Group**.

![Security Group Criação](https://github.com/user-attachments/assets/8dfd8eef-03ee-442d-854d-dc2cd7956127)

Escolha um nome, descrição e selecione a VPC criada anteriormente. Criaremos **quatro Security Groups**.

![Lista de Security Groups](https://github.com/user-attachments/assets/d32607c6-6087-4826-a2ac-86cfc6e5f7ea)  
![Regras dos Security Groups](https://github.com/user-attachments/assets/7ec825c6-d98b-4616-8c1a-203a4bbafbd2)

### Regras dos Security Groups

#### EC2SecurityGroup
**Inbound:**
- SSH - 22 - My IP  
- HTTP - 80 - LoadBalancerSecurityGroup  
- NFS - 2049 - EFSSecurityGroup

**Outbound:**
- All traffic - All - 0.0.0.0/0

#### LoadBalancerSecurityGroup
**Inbound:**
- HTTP - 80 - 0.0.0.0/0

**Outbound:**
- HTTP - 80 - EC2SecurityGroup

#### RDSSecurityGroup
**Inbound:**
- MySQL/Aurora - 3306 - EC2SecurityGroup

**Outbound:**
- MySQL/Aurora - 3306 - EC2SecurityGroup

#### EFSSecurityGroup
**Inbound:**
- NFS - 2049 - EC2SecurityGroup

**Outbound:**
- NFS - 2049 - EC2SecurityGroup

> **Nota:** Você pode editar as regras dos security groups a qualquer momento.

---

## 3 - Criação da Database (RDS)

Pesquise por **RDS**, clique em **Create Database** e selecione as opções **Standard Create** e **MySQL**.

![Create Database](https://github.com/user-attachments/assets/3b3fd3fe-218e-4216-94b2-e3caff832b90)  
![Opções RDS](https://github.com/user-attachments/assets/ee68d394-c5d2-485b-ad29-952db4de55f3)

Escolha o template **Free Tier**.

![Free Tier](https://github.com/user-attachments/assets/ced2d52c-938a-4d22-afed-a2fac6da6f8c)  
![Free Tier Continuação](https://github.com/user-attachments/assets/e517db67-2538-45ad-aa62-9728c3463010)

Configure o identificador da database e as credenciais.

![Identificador](https://github.com/user-attachments/assets/e6540ad7-3041-4eec-a0fb-54780bd414d4)

Para este projeto foi usada a instância **t3.micro**.

![Instância](https://github.com/user-attachments/assets/41951d39-52a8-4930-b20d-6e25a17fa73e)

Armazenamento padrão com auto scaling ativado.  
Em **Connectivity**, habilite para **não** permitir acesso público, selecione a VPC e subnets privadas, e o Security Group **RDSSecurityGroup**.

![Conectividade](https://github.com/user-attachments/assets/800bb940-799b-48a0-9e7e-7cc30391970d)

Na autenticação, escolha **Password authentication**. Em **Monitoring**, selecione **Standard**.

![Monitoring](https://github.com/user-attachments/assets/1acfcef6-c33b-412d-ad32-377e10c5cd40)

Em **Additional Configuration**, defina o nome da database e clique em **Create Database**.

![Nome da DB](https://github.com/user-attachments/assets/7a184c18-a5b5-4894-a5dc-5ef6c621e982)

---

## 4 - Criar o EFS

Pesquise por **EFS** e clique em **Create File System**.

![EFS Criação](https://github.com/user-attachments/assets/03057709-64ce-4999-baf3-a642a294c4b3)

Escolha um nome e selecione a VPC criada anteriormente. Clique em **Customize**.

![EFS Customize](https://github.com/user-attachments/assets/c4a5946f-de84-4e37-9618-51eb85ba8a92)

### Configurações:
- **Type:** Regional  
- **Backups:** Desativados  
- **Life Cycle Management:** None  
- **Throughput Mode:** Bursting  
- **Performance:** General

![EFS Configurações](https://github.com/user-attachments/assets/86e527ea-b321-47ea-b164-ef46c50c6721)  
![EFS Performance](https://github.com/user-attachments/assets/b3d3ce89-19e9-4ded-9588-6deb586a6340)

Em **Network access**, selecione a VPC, subnets privadas e o Security Group **EC2SecurityGroup**.

![EFS Network](https://github.com/user-attachments/assets/e890fbae-73b8-4ac7-8aae-7324275f03a7)

Em **Policy**, escolha **None**.

![EFS Policy](https://github.com/user-attachments/assets/90309f26-8157-4a29-b01f-0cf4fea795ad)

Clique em **Create** e **anote o ID do File System**.

---

## 5 - Criar o Launch Template

Pesquise por **Launch Template** e clique em **Create Launch Template**.

![Launch Template](https://github.com/user-attachments/assets/7223f213-5942-4aae-845a-ef7ee1c0338d)

Escolha um nome e descrição, selecione uma AMI (neste projeto foi usado **Ubuntu**).

![AMI](https://github.com/user-attachments/assets/4c84dddf-4f70-4286-8c9a-812e94378f06)  
![Tipo de Instância](https://github.com/user-attachments/assets/7e481d78-cf61-4465-b123-056518f08780)

- **Instance Type:** t2.micro  
- **Key Pair:** Selecionada  
- **Security Group:** EC2SecurityGroup  
- **User Data:** Cole o script ou envie o arquivo

![User Data](https://github.com/user-attachments/assets/fc4ed55c-4206-4d3e-b6a6-13109dc37a93)  
![Finalizar Template](https://github.com/user-attachments/assets/13a8f5cd-2687-4fe0-9174-f0cdd6913db6)

---

## 6 - Criar o Load Balancer

Pesquise por **Load Balancers** e clique em **Create Load Balancer** (clássico).

![Load Balancer](https://github.com/user-attachments/assets/db634b6b-e5e9-4161-b674-67a117559a45)  
![Escolher Tipo](https://github.com/user-attachments/assets/6e8415b7-8287-4983-a940-f53efcf23a65)

Escolha um nome, selecione **Internet-facing**, escolha a VPC e as subnets públicas.

![Zonas](https://github.com/user-attachments/assets/54f744be-8aa1-4675-a9a0-6d77664c6a77)  
![Zonas 2](https://github.com/user-attachments/assets/8baae3bc-afee-4fb9-ad21-b715593f98e2)  
![Security Group](https://github.com/user-attachments/assets/77d4350e-693c-4f5b-b65c-98a44403d903)

Selecione o Security Group **LoadBalancerSecurityGroup** e deixe listeners e routing como padrão.

![Listeners](https://github.com/user-attachments/assets/e4fedda6-1bbd-4d38-878a-b17a1a06aeb6)

Configure o **Health Check**:
- Ping: `/wp-admin/install.php`  
- Interval: 10s  
- Timeout: 5s  
- Unhealthy Threshold: 2  
- Healthy Threshold: 3

![Health Check](https://github.com/user-attachments/assets/0f21e5f4-a8fd-4d95-b56a-2f880f79ebbf)

Finalize com **Create Load Balancer**.

![Finalizar LB](https://github.com/user-attachments/assets/cfbfaeb8-c28d-4c83-83ab-78aa8f53e982)

---

## 7 - Criar Auto Scaling Group

Pesquise por **Auto Scaling Group** e clique em **Create Auto Scaling Group**.

![Auto Scaling Group](https://github.com/user-attachments/assets/61cf81a3-f65a-4c7e-b98d-0ffb3a8aeefc)

Escolha um nome e selecione o **Launch Template** criado.

![Selecionar Template](https://github.com/user-attachments/assets/e2be92c7-5321-42ff-b63b-fc9eacad11a7)

Configure a rede com VPC e subnets privadas. Selecione **Balanced - Best Effort**.

![Rede ASG](https://github.com/user-attachments/assets/b79de4dc-782b-40e6-b982-801cab9c7e0e)

Conecte ao Load Balancer e selecione **recomendado** em health check.

![Conectar LB](https://github.com/user-attachments/assets/83d17417-d296-46fe-9905-8bcbc00e6f4d)  
![Health Check](https://github.com/user-attachments/assets/f1b24806-f76a-4364-98e6-23c7f2c9431f)

Configure o tamanho:
- Desejado: 2  
- Mínimo: 2  
- Máximo: 2  
- Scaling Policy: None


![Tamanho do Grupo](https://github.com/user-attachments/assets/d322ba40-b20a-45e6-9ef5-83888841de38)
![Captura de Tela (92)](https://github.com/user-attachments/assets/3cb6b0b7-645b-4cfc-922b-3491778ba88b)

Finalize a criação ignorando notificações e clicando em **Create Auto Scaling Group**.
