#! \bin\bash

user=$(whoami)

if [[ $user = "root" ]]
then
	echo "Instalación nagios-core"
	echo "¿Desea continuar?(s/n)"
	read opcion
	echo

#Opcion 1

	if [[ $opcion = 's' ]]
	then
		#Primero instalamos varios paquetes necesarios antes de comenzar con la instalación de nagios
		echo "Preparando instalación..."
		apt-get update > /dev/null
		apt-get install -y wget > /dev/null 
		apt-get install -y build-essential > /dev/null
		apt-get install -y libgd2-xpm-dev > /dev/null
		apt-get install -y openssl > /dev/null
		apt-get install -y libssl-dev > /dev/null
		echo
		echo "Procedemos a crear el usuario nagios y el grupo"
		/usr/sbin/useradd -m -s /bin/bash nagios
		echo
		echo "Escriba la contraseña para el usuario nagios"
		passwd nagios
		echo
		echo "¡Todo listo para empezar a descargar e instalar nagios-plugins!"
		echo "Iniciando instalación" 
		cd /tmp
		wget http://nagios-plugins.org/download/nagios-plugins-2.2.1.tar.gz
		echo
		echo "Descarga finalizada"
 		tar xzf nagios-plugins-2.2.1.tar.gz > /dev/null
		cd nagios-plugins-2.2.1
		echo
		echo "Instalando plugin de nagios-core, por favor espere"
		./configure 
		make > /dev/null
		make install > /dev/null
		echo
		echo "Instalación de nagios-plugins finalizada"
		#Permisos
		chown nagios.nagios /usr/local/nagios
		chown ­-R nagios.nagios /usr/local/nagios/libexec/
		#
		echo "Preparando instalación nrpe (Monitorización)"
		apt-get install -y xinetd > /dev/null
		apt-get install -y libssl-dev > /dev/null
		#
		echo "Descargando nrpe"
		cd /tmp
		wget https://github.com/NagiosEnterprises/nrpe/releases/download/nrpe-3.2.1/nrpe-3.2.1.tar.gz
		tar xzf nrpe-3.2.1.tar.gz
		cd nrpe-3.2.1
		echo
		echo "Descarga finalizada"
		echo "Instalando nrpe, por favor espere"
		./config.
		make all
		make install-groups-users
		make install
		make install-config
		make install-inetd
		make install-init
		make install.plugin
		make install-daemon 
		service xinetd restart
		echo
		echo "Instalación completada"
	fi

else
	echo "Debes de ser root para poder ejecutar el script"
fi