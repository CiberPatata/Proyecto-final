#!/bin/bash

# Script para crear un nuevo usuario FTP en Ubuntu Server 22.04

# Solicita el nombre de usuario
read -p "Ingrese el nombre del nuevo usuario FTP: " username

# Solicita y confirma la contraseña del usuario
while true; do
    read -s -p "Ingrese la contraseña para $username: " password
    echo
    read -s -p "Confirme la contraseña: " password2
    echo
    [ "$password" = "$password2" ] && break
    echo "Las contraseñas no coinciden. Intente de nuevo."
done

# Crea el usuario en el sistema
sudo useradd -m -s /bin/false $username

# Establece la contraseña del usuario
echo "$username:$password" | sudo chpasswd

# Crea el directorio para el FTP y asigna los permisos necesarios
sudo mkdir -p /home/$username/ftp/upload
sudo chown nobody:nogroup /home/$username/ftp
sudo chmod a-w /home/$username/ftp
sudo chown $username:$username /home/$username/ftp/upload

# Actualiza la configuración de vsftpd para los usuarios locales, si es necesario
# sudo echo "local_enable=YES" >> /etc/vsftpd.conf
# sudo echo "write_enable=YES" >> /etc/vsftpd.conf
# sudo echo "chroot_local_user=YES" >> /etc/vsftpd.conf
# sudo echo "allow_writeable_chroot=YES" >> /etc/vsftpd.conf

# Reinicia el servicio FTP para aplicar los cambios
# sudo systemctl restart vsftpd

echo "Usuario FTP $username creado exitosamente."
