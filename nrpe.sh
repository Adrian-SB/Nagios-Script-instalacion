#! \bin\bash

user=$(whoami)

if [[ $user = "root" ]]
then
	echo "Instalación plugin nrpe nagios"
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
		chown nagios.nagios /usr/local/nagios
		chown ­-R nagios.nagios /usr/local/nagios/libexec/
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