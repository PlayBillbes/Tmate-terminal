FROM ubuntu:22.04

# Instalar dependências
RUN apt update && \
    apt install -y curl wget gnupg2 ca-certificates software-properties-common python3 tmate && \
    apt clean

# Criar conteúdo web dummy
WORKDIR /app
RUN apt-get update &&\
    apt install --only-upgrade linux-libc-dev &&\
    apt-get install -y iproute2 vim netcat-openbsd &&\
    addgroup --gid 10008 choreo &&\
    adduser --disabled-password  --no-create-home --uid 10008 --ingroup choreo choreouser &&\
    usermod -aG sudo choreouser &&\
    
RUN echo "Terminal ativo via tmate..." > index.html

# Expor a porta que o Render exige
EXPOSE 8080

# Copiar script de inicialização
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Iniciar script
CMD ["/start.sh"]

USER 10008
