# Server-Monitoramento-Web

Este é um projeto prático para Linux e Docker.

---

## 📌 Índice
1. [Configuração do Ambiente](#etapa-1-configuração-do-ambiente)
2. [Configuração do Servidor Web](#etapa-2-configuração-do-servidor-web)
3. [Script de Monitoramento + Webhook](#etapa-3-script-de-monitoramento--webhook)
4. [Testes e Documentação](#etapa-4-testes-e-documentação)
5. [Conclusão](#conclusão)

---

## 🔧 Etapa 1: Configuração do Ambiente

### 1️⃣ Criação da VPC  
- Criei uma **VPC** com duas sub-redes públicas para acesso externo e duas sub-redes privadas para futuras expansões.  
  ![VPC](https://github.com/user-attachments/assets/aa0728eb-19d5-47b4-875b-24cad890cf3f)

### 2️⃣ Configuração do Security Group  
- Defini regras no **Security Group** para permitir acesso via **SSH** (porta 22) e tráfego **HTTP** (porta 80).  
  ![Configuração do Security Group](https://github.com/user-attachments/assets/4c3c3a66-3ecd-4c27-ab93-d4fe84a7f5de)

### 3 Criação da Database com RDS
- Para criação da database optei pelo stardart creation e escolhi o mysql.  
![Captura de Tela (21)](https://github.com/user-attachments/assets/6cdc2799-d97a-495d-8e77-92afb63cdd95)
![Captura de Tela (22)](https://github.com/user-attachments/assets/ff6f7d1a-f7c5-4fe4-a556-3556e981f738)

- Entre os templetes escolhi a opção free tier, consequentemente escolhendo a opção de criar uma unica instancia.  
![Captura de Tela (23)](https://github.com/user-attachments/assets/89a37f83-b96a-4093-bb56-c69322f8583c)
![Captura de Tela (24)](https://github.com/user-attachments/assets/4cbd5018-a04d-4382-99a7-762dc62b5745)

- Entre os templetes escolhi a opção free tier, consequentemente escolhendo a opção de criar uma unica instancia.  
![Captura de Tela (25)](https://github.com/user-attachments/assets/15876681-66ab-499f-aef1-554bcb0e82c7)
![Captura de Tela (26)](https://github.com/user-attachments/assets/4dcb59c7-6e0b-4305-8e71-202101f6ea29)

- Entre os templetes escolhi a opção free tier, consequentemente escolhendo a opção de criar uma unica instancia.  
![Captura de Tela (28)](https://github.com/user-attachments/assets/a2f50162-d83d-4c2f-b693-e20ec3b79d3b)
![Captura de Tela (29)](https://github.com/user-attachments/assets/1339b55b-df7a-4ddf-995e-b37108a94b92)

- Entre os templetes escolhi a opção free tier, consequentemente escolhendo a opção de criar uma unica instancia.  
![Captura de Tela (35)](https://github.com/user-attachments/assets/d9506b2c-848d-4dae-a183-e8309a7e0cb4)


### 4 Criação da Instância EC2  
- Configurei uma instância EC2 na AWS com as seguintes configurações:
  - **Tags:**  
    ![Tags da Instância](https://github.com/user-attachments/assets/8efe5b90-2694-4bb4-900f-bb3373605f55)
  - **Escolha da AMI:**  
    - Utilizei a AMI **Ubuntu**.  
    ![AMI Ubuntu](https://github.com/user-attachments/assets/fe2b718f-2ed1-4003-b833-2bd31e19bb81)
  - **Configuração da VPC e IP Público:**  
    - Selecionei a VPC.  
    ![Configuração da VPC e IP Público](https://github.com/user-attachments/assets/2a910dff-8626-4625-82be-1a4c2291ebb8)
  - **Criação da Chave SSH:**  
    - Gerei uma chave para acessar a instância via SSH pelo **WSL Ubuntu**.
  - **Associação do Security Group:**  
    - Vinculei o Security Group à instância criado anteriormente.  
    ![WhatsApp Image 2025-03-26 at 17 06 43](https://github.com/user-attachments/assets/1a3c649e-bddd-4ca7-9529-7042570c8649)
  - **upload do userdata:**  
    - fiz upload do userdata programado com docker compose executando os serviços de Wordpress e mysql.  
    ![WhatsApp Image 2025-03-26 at 17 06 43](https://github.com/user-attachments/assets/1a3c649e-bddd-4ca7-9529-7042570c8649)
