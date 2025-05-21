#!/bin/bash

# Iniciar servidor HTTP para manter Render ativo
python3 -m http.server 8080 &

# Criar socket de sessão tmate
tmate -S /tmp/tmate.sock new-session -d

# Esperar até que a sessão esteja pronta
tmate -S /tmp/tmate.sock wait tmate-ready

# Mostrar URL de acesso
tmate -S /tmp/tmate.sock display -p 'Web: #{tmate_web}'
tmate -S /tmp/tmate.sock display -p 'SSH: #{tmate_ssh}'

# Manter processo vivo
tail -f /dev/null
