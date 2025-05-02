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

### 3️⃣ Criação da Instância EC2  
- Configurei uma instância EC2 na AWS com as seguintes configurações:
  - **Tags:**  
    ![Tags da Instância](https://github.com/user-attachments/assets/8efe5b90-2694-4bb4-900f-bb3373605f55)
  - **Escolha da AMI:**  
    - Utilizei a AMI **Ubuntu**.  
    ![AMI Ubuntu](https://github.com/user-attachments/assets/fe2b718f-2ed1-4003-b833-2bd31e19bb81)
  - **Configuração da VPC e IP Público:**  
    - Selecionei a VPC e habilitei o IP público.  
    ![Configuração da VPC e IP Público](https://github.com/user-attachments/assets/2a910dff-8626-4625-82be-1a4c2291ebb8)
  - **Criação da Chave SSH:**  
    - Gerei uma chave para acessar a instância via SSH pelo **WSL Ubuntu**.
  - **Associação do Security Group:**  
    - Vinculei o Security Group à instância criado anteriormente.  
    ![WhatsApp Image 2025-03-26 at 17 06 43](https://github.com/user-attachments/assets/1a3c649e-bddd-4ca7-9529-7042570c8649)
