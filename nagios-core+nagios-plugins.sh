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
		apt-get install -y apache2 > /dev/null
		apt-get install -y php > /dev/null
		apt-get install -y apache2-mod-php7* > /dev/null
		apt-get install -y php-gd > /dev/null
		apt-get install -y libgd-dev > /dev/null
		apt-get install -y unzip > /dev/null
		##Captura 1
		echo
		echo "Procedemos a crear el usuario nagios y el grupo"
		/usr/sbin/useradd -m -s /bin/bash nagios
		echo "Escriba la contraseña para el usuario nagios"
		passwd nagios
		/usr/sbin/groupadd nagcmd
		/usr/sbin/usermod -a -G nagcmd nagios
		/usr/sbin/usermod -a -G nagcmd www-data
		##Captura 2
		echo "¡Todo listo para empezar a descargar e instalar nagios!"
		#Instalación nagios
		cd /tmp
		wget http://prdownloads.sourceforge.net/sourceforge/nagios/nagios-4.3.4.tar.gz 
		echo
		echo "Descarga finalizada"
		tar zxf nagios-4.3.4.tar.gz > /dev/null
		cd nagios-4.3.4
		##Captura 3
		echo "Instalando nagios 4.3.4, por favor espere"
		./configure --with-command-group=nagcmd  > /dev/null
		make all  > /dev/null
		make install  > /dev/null
		make install-init  > /dev/null
		make install-config  > /dev/null
		make install-commandmode  > /dev/null
		make install-webconf  > /dev/null
		##Captura 4
		#Ficheros necesarios
		cp -R contrib/eventhandlers/ /usr/local/nagios/libexec/
		chown -R nagios:nagios /usr/local/nagios/libexec/eventhandlers
		echo
		echo "Instalación de nagios 4.3.4 completada"
		echo "RESUMEN:"
		/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
		##Captura 5
		#Añadimos módulos
		a2ensite nagios > /dev/null
		a2enmod rewrite > /dev/null
		a2enmod cgi > /dev/null
		##Captura 6
		echo
		echo "Por motivos de seguridad,cambiaremos la contraseña al administrador de nagios"
		htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
		service apache2 restart
		##Captura 7
		echo "Constraseña cambiada"
		echo "Finalizando instalación" 
		cd /tmp
		wget http://nagios-plugins.org/download/nagios-plugins-2.2.1.tar.gz
		echo
		echo "Descarga finalizada"
 		tar xzf nagios-plugins-2.2.1.tar.gz > /dev/null
		cd nagios-plugins-2.2.1
		"Instalando plugin de nagios-core, por favor espere"
		./configure --with-nagios-user=nagios --with-nagios-group=nagios > /dev/null
		##Captura 8
		make > /dev/null
		make install > /dev/null
		echo
		echo "Instalación de plugin finalizada"
		a2ensite nagios > /dev/null
		a2enmod rewrite > /dev/null
		a2enmod cgi > /dev/null
		ln -s /etc/init.d/nagios /etc/rcS.d/S99nagios 
		update-rc.d nagios defaults 
		service nagios start
		service apache2 start
		##Captura 9
		cd
		echo
		echo "Instalación de nagios-core finalizada"
		##Captura 10
		
	fi

else
	echo "Debes de ser root para poder ejecutar el script"
fi
