#!/bin/bash

# Número de teléfono de destino para el SMS
numero_destino="+34633908473"

# Función para enviar un SMS utilizando Twilio
enviar_sms() {
    local mensaje="$1"
    local account_sid="AC2fbdf43300e1db9cce3b0ff561e98021"
    local auth_token="2a223caeed2e7c2d671be5ed58c5a380"
    local tu_numero_de_telefono="+15099564861"

    curl -X POST "https://api.twilio.com/2010-04-01/Accounts/$account_sid/Messages.json" \
    --data-urlencode "To=+$numero_destino" \
    --data-urlencode "From=+$tu_numero_de_telefono" \
    --data-urlencode "Body=$mensaje" \
    -u "$account_sid:$auth_token"
}

# Actualizar el sistema y registrar la salida en un archivo de registro
log_file="/var/log/actualizacion.log"
echo "Iniciando actualización del sistema..." > "$log_file"
sudo apt-get update >> "$log_file" 2>&1
sudo apt-get upgrade -y >> "$log_file" 2>&1
echo "Actualización del sistema finalizada." >> "$log_file"

# Enviar el registro por SMS
log_contents=$(tail -n 10 "$log_file")  # Cambia el número según tus necesidades
enviar_sms "Registro de actualización del sistema: $log_contents"
