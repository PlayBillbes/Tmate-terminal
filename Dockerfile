FROM ubuntu:22.04

# Instalar dependências
RUN apt update && \
    apt install -y curl wget gnupg2 ca-certificates software-properties-common python3 tmate && \
    apt clean

# Criar conteúdo web dummy
WORKDIR /app
    
RUN echo "Terminal ativo via tmate..." > index.html

# Expor a porta que o Render exige
EXPOSE 8080

# Copiar script de inicialização
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Iniciar script
CMD ["/start.sh"]

USER 10008
