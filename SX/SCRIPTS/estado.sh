#!/bin/bash

# Lista de servicios para monitorizar
services=("vsftpd" "openvpn@server" "nextcloud")

# Información para enviar SMS con Twilio
TWILIO_ACCOUNT_SID="AC2fbdf43300e1db9cce3b0ff561e98021"
TWILIO_AUTH_TOKEN="2a223caeed2e7c2d671be5ed58c5a380"
TWILIO_PHONE_NUMBER="+15099564861"
DESTINATION_PHONE_NUMBER="+34633908473"

# Información para enviar correo electrónico con SendGrid
SENDGRID_API_KEY="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"
EMAIL_TO="voxespana962@gmail.com"
EMAIL_FROM="mohagptxu@gmail.com"
SUBJECT="Alerta de Servicio Detenido"

# Función para verificar el estado de un servicio
check_service() {
    service=$1
    if ! systemctl is-active --quiet $service; then
        echo "$service no está activo. Enviando SMS y correo electrónico..."
        send_sms "$service"
        send_email "$service"
    else
        echo "$service está activo."
    fi
}

# Función para enviar SMS con Twilio
send_sms() {
    service=$1
    message="Alerta: El servicio $service ha dejado de funcionar en $(hostname)"

    curl -X POST "https://api.twilio.com/2010-04-01/Accounts/$TWILIO_ACCOUNT_SID/Messages.json" \
    --data-urlencode "To=$DESTINATION_PHONE_NUMBER" \
    --data-urlencode "From=$TWILIO_PHONE_NUMBER" \
    --data-urlencode "Body=$message" \
    -u "$TWILIO_ACCOUNT_SID:$TWILIO_AUTH_TOKEN"
}

# Función para enviar correo electrónico con SendGrid
send_email() {
    service=$1
    body="El servicio ${service} ha dejado de funcionar en $(hostname)"

    echo "$body" | sendgrid-cli mail send \
        --from "$EMAIL_FROM" \
        --to "$EMAIL_TO" \
        --subject "$SUBJECT" \
        --api-key "$SENDGRID_API_KEY"
}

# Bucle principal para verificar cada servicio
for service in "${services[@]}"; do
    check_service $service
done