# Actualizar el sistema
sudo apt update && sudo apt upgrade -y

# Obtener la salida de la actualización y escapar los caracteres especiales
output=$(sudo apt list --upgradable | sed 's/"/\\"/g')

# Mensaje a enviar al webhook de Discord
message=$(echo -e "Actualización del sistema completada. Paquetes actualizados:\n$output")

# Guardar el mensaje en un archivo temporal
echo "$message" > /tmp/message.txt

# Webhook URL de Discord 
webhook_url="https://discord.com/api/webhooks/1196147664417476701/iRNxIdTwHF9hsY_igFlLStgE-8vKBWvhMbVXLGX2A4RT1FbXtsTKFYkFUnexAXz8j0ng"

# Función para enviar el mensaje al webhook de Discord
send_discord_notification() {
    python3 - <<END
import json
import requests

url = "$webhook_url"
with open('/tmp/message.txt', 'r') as file:
    message = file.read()
data = json.dumps({"content": message})
requests.post(url, data=data, headers={"Content-Type": "application/json"})
END
}

# Envía la notificación a Discord utilizando Python 3
send_discord_notification

//! Script de cron para actualizar el sistema
//! Versión: 1.0
//! Autor: Borja
//! Fecha: 2023-03-01
//! Prueba
//! Script de cron para actualizar el sistema