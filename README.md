Atividade - DevSecOps - Docker



1 - criação da virtual private cloud


acesse na barra de busca da aws e pesquise vpc, e em seguida clique em create vpc
![Captura de Tela (7)](https://github.com/user-attachments/assets/ac7a4da3-5d87-425e-b588-b03afa084192)

nas configurações escolha por vpc and more, segue da sua preferencia o nome da vpc, deixe o ipv4 CRD block padrão, selecione o numero de zonas desejado (para o projeto usaremos duas), com duas subnets publicas e duas privadas, nao foi necessario custumizar os blocos então pule para a configuração do NAT gateways e selecione uma por zona, e desabilite as VPC endpoint.

![Captura de Tela (56)](https://github.com/user-attachments/assets/93b1e831-0a51-453b-a688-7be3895c22fc)
![Captura de Tela (57)](https://github.com/user-attachments/assets/c86d6cbc-0e35-461d-9f7d-eabc652a3c3c)

uma vez terminado clique em create vpc.


2 - criação dos security grups
com os security groups controlaremos a conecção entre a Database e EFS com as EC2, e da EC2 que sera privado com o Load balancer que permetira o acesso publico ao wordpress.

pesquise por security group e clique em create security group.
![Captura de Tela (9)](https://github.com/user-attachments/assets/8dfd8eef-03ee-442d-854d-dc2cd7956127)

aqui escolha um nome da sua preferencia, uma descrição e a vpc anteriormente criada, faremos 4 Security groups seguindo esses mesmos passos. 
![Captura de Tela (59)](https://github.com/user-attachments/assets/d32607c6-6087-4826-a2ac-86cfc6e5f7ea)
e aqui colocaremos as regras de inbound e outbound. 
![Captura de Tela (58)](https://github.com/user-attachments/assets/7ec825c6-d98b-4616-8c1a-203a4bbafbd2)

  -regras do security group EC2SecurityGroup
  inbound
  ssh - 22 - myip (aparecera o seu endereço de ip, permitira so que voce conecte com a instancia via ssh)
  http - 80 - LoadBalancerSecurityGroup
  nfs - 2049 EFSSecurityGroup
  outbound
  all trafic - all - 0.0.0.0/0


   -regras do security group LoadBalancerSecurityGroup
  inbound
  http - 80 - 0.0.0.0/0
  
  outbound
  http - 80 - EC2SecurityGroup

  -regras do security group RDSSecurityGroup
  inbound
  MysqlAurora - 3006 - EC2SecurityGroup 
  
  outbound
  MysqlAurora - 3006 - EC2SecurityGroup 

  -regras do security group EFSSecurityGroup
  inbound
  NFS - 2049 - EC2SecurityGroup
  
  outbound
  NFS - 2049 - EC2SecurityGroup

-nota: voce pode ir voltando e editando as regras do security groups se achar mais facil a qualquer momento.

2 - Criação da Database

pesquise por RDS, clique em create Database e selecione as opções standart creation e mysql 
![Captura de Tela (21)](https://github.com/user-attachments/assets/3b3fd3fe-218e-4216-94b2-e3caff832b90)
![Captura de Tela (22)](https://github.com/user-attachments/assets/ee68d394-c5d2-485b-ad29-952db4de55f3)

escolha o templete free tier 
![Captura de Tela (23)](https://github.com/user-attachments/assets/ced2d52c-938a-4d22-afed-a2fac6da6f8c)
![Captura de Tela (24)](https://github.com/user-attachments/assets/e517db67-2538-45ad-aa62-9728c3463010)

configure o identificador da database e como prefere as credenciais
![Captura de Tela (25)](https://github.com/user-attachments/assets/e6540ad7-3041-4eec-a0fb-54780bd414d4)

nas configurações da instacia para esse projeto foi usado T3.micro, mas pode ser da sua preferencia
![Captura de Tela (26)](https://github.com/user-attachments/assets/41951d39-52a8-4930-b20d-6e25a17fa73e)

para o projeto as configurações de storege foram deixadas como padrão apenas abilitando o autoscaling e as configurações de connectivity habilitaremos para nao conectar com EC2, para tipo IPV4, escolheremos a subnet criada anteriormente e para criar um novo subnet DB, desabilitaremos o ip publico e escolheremos para Security group a RDSSecurityGroup (ou nome que voce escolheu)

![Captura de Tela (28)](https://github.com/user-attachments/assets/800bb940-799b-48a0-9e7e-7cc30391970d)

Para Database authentication usaremos a primeira opção (por conta do Userdata) e em monitoring escolheremos standart

![Captura de Tela (30)](https://github.com/user-attachments/assets/1acfcef6-c33b-412d-ad32-377e10c5cd40)

e por ultimo clique em aditional configuration e escolha um nome para a database a ser criada (e usada no userdata) e clique em create database.
![Captura de Tela (35)](https://github.com/user-attachments/assets/7a184c18-a5b5-4894-a5dc-5ef6c621e982)

 - Criar o EFS

   pesquise por EFS e clique em create file system

![Captura de Tela (60)](https://github.com/user-attachments/assets/03057709-64ce-4999-baf3-a642a294c4b3)


   Em seguida escolha um nome e a vpc criada anteriormente e clique em customize
![Captura de Tela (61)](https://github.com/user-attachments/assets/c4a5946f-de84-4e37-9618-51eb85ba8a92)


   na primera etapa para configuração do sistema voce pode escolher um nome, em type selecione regional e desabilite automatic backups, em life management deixe ambas trasitions como none e o resto como padrão, em performance settings selecione bursting em throughput mode, em adicional settings a peformance como general, depois clique em next para a proxima etapa.

![Captura de Tela (62)](https://github.com/user-attachments/assets/86e527ea-b321-47ea-b164-ef46c50c6721)

   ![Captura de Tela (66)](https://github.com/user-attachments/assets/b3d3ce89-19e9-4ded-9588-6deb586a6340)


em network acess escolha a vpc criada anteriormente, em mount targets escolha as zonas e as subnets privadas e o security group EC2SecurityGroup (ou o nome que voce escolheu), deixe ip como padrao e clique em next.

![Captura de Tela (64)](https://github.com/user-attachments/assets/e890fbae-73b8-4ac7-8aae-7324275f03a7)

em politicas escolha oque desejar e aperte next, foi optado por nenhuma nesse projeto. 
![Captura de Tela (65)](https://github.com/user-attachments/assets/90309f26-8157-4a29-b01f-0cf4fea795ad)

e por ultimo revise tudo que fez e selecione create, lembrese de pegar o id do file system para o userdata.

4 - criar Launch template 

pesquise por Lauch Template e clique em create lauch template. 

![Captura de Tela (67)](https://github.com/user-attachments/assets/7223f213-5942-4aae-845a-ef7ee1c0338d)

escolha um nome para o template e descrição, nas proximas configurações escolha uma AMI de preferencia, para o projeto foi escolhido ubuntu.
![Captura de Tela (68)](https://github.com/user-attachments/assets/4c84dddf-4f70-4286-8c9a-812e94378f06)
![Captura de Tela (69)](https://github.com/user-attachments/assets/7e481d78-cf61-4465-b123-056518f08780)


em instance type foi escolhido T2.micro e uma selecionado uma key pair, em networking settings foi selecionado nao criar o template com subnetes, a firewall foi escolhido a Security group ja existante EC2Securitygrup, em aditional detail role para o final e copie e cole o userdata ou escolha do seu computador (o usado neste projeto foi adicionado ao repositorio a parte) e por fim clique create lauch template.
![Captura de Tela (70)](https://github.com/user-attachments/assets/fc4ed55c-4206-4d3e-b6a6-13109dc37a93)
![Captura de Tela (71)](https://github.com/user-attachments/assets/13a8f5cd-2687-4fe0-9174-f0cdd6913db6)

5 - criar o Load Balancer 

pesquise por load balancers e em seguida clique em create load balancers e em clique em create em classical load balancer - previous generation. 

![Captura de Tela (72)](https://github.com/user-attachments/assets/db634b6b-e5e9-4161-b674-67a117559a45)
![Captura de Tela (73)](https://github.com/user-attachments/assets/6e8415b7-8287-4983-a940-f53efcf23a65)

escolha um nome para o loadbalancer, selecione internet facing em scheme e em network mapping esl=colha a vpc criada anteriormente, selecione as zonas e as subnetes publicas 
![Captura de Tela (74)](https://github.com/user-attachments/assets/54f744be-8aa1-4675-a9a0-6d77664c6a77)
![Captura de Tela (74)](https://github.com/user-attachments/assets/8baae3bc-afee-4fb9-ad21-b715593f98e2)
![Captura de Tela (75)](https://github.com/user-attachments/assets/77d4350e-693c-4f5b-b65c-98a44403d903)

em seguida selecione o security group LoadBalancerSecurity group (ou nome que escolheu), e deixe listeners e routing como padrão
![Captura de Tela (76)](https://github.com/user-attachments/assets/e4fedda6-1bbd-4d38-878a-b17a1a06aeb6)

em health checks o ping para o caminho /wp-admin/install.php, interval em 10 segundos, 5 segundos para response time out, 2 em unhealth thresh hold e por ultimo 3 em health thresh hold.
![Captura de Tela (77)](https://github.com/user-attachments/assets/0f21e5f4-a8fd-4d95-b56a-2f880f79ebbf)

e o resto deixe como padrão e clique em create load balancer
![Captura de Tela (79)](https://github.com/user-attachments/assets/cfbfaeb8-c28d-4c83-83ab-78aa8f53e982)


6 - criar auto scaling 
pesquise por auto scaling group e clique em create auto scaling group
![Captura de Tela (82)](https://github.com/user-attachments/assets/61cf81a3-f65a-4c7e-b98d-0ffb3a8aeefc)


na primeira etapa escolha um nome para o grupo e o template anteriormente criado e clique em next.
![Captura de Tela (83)](https://github.com/user-attachments/assets/e2be92c7-5321-42ff-b63b-fc9eacad11a7)

no proximo passo apenas configure a network, ecolha a vpc criada anteriormente e as zonas com as subnets privadas, selecione balanced best efffort e clique para next. 
![Captura de Tela (87)](https://github.com/user-attachments/assets/b79de4dc-782b-40e6-b982-801cab9c7e0e)

em seguida configure para conectar ao load baalcer criado anteriormente, no vpc lattic service e selecione a opção recomendada em health checks, depois clique em next.
![Captura de Tela (88)](https://github.com/user-attachments/assets/83d17417-d296-46fe-9905-8bcbc00e6f4d)
![Captura de Tela (89)](https://github.com/user-attachments/assets/f1b24806-f76a-4364-98e6-23c7f2c9431f)

em seguida configure em group size a capacidade para 2, em scaling e minimo desejado para 2 e maximo para 2, selecione no scaling policies.
![Captura de Tela (91)](https://github.com/user-attachments/assets/d322ba40-b20a-45e6-9ef5-83888841de38)

em maintainance selecione no policies, em adicional settings selecione a segunda opção e em next, pule a aetapa de notificções e em next novamente e clique em create auto scaling group.
