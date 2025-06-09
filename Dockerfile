FROM ubuntu:22.04

# Instalar dependências
RUN apt update && \
    apt install -y curl wget gnupg2 ca-certificates software-properties-common python3 tmate && \
    apt clean

# Criar conteúdo web dummy
WORKDIR /app
    
RUN echo "Terminal ativo via tmate..." > index.html
RUN groupadd -r myuser && useradd -r -g myuser myuser
RUN apt-get update && apt-get install -y sudo
RUN echo 'myuser ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

RUN chown -R myuser:myuser /app

# Expor a porta que o Render exige
EXPOSE 8080

# Copiar script de inicialização
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Iniciar script
CMD ["/start.sh"]

USER myuser
