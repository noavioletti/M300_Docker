# M300_LB03
Doku

# K1 <br>

Der unterschied zu LB02 ist hier, dass ich meine Infrastruktur in einer VM realisieren werden. Grund dazu waren kompatibiltäts Probleme mit der LB02. <br>

installierte Programme für den Beginn / und Grundkonfiguration <br>
- Visual Studio Code installieren
- Git Client / inkl verknüpfung mit Git Konto 
- SSH Key generieren und bei Git Account hinterlegen 
- Virtual Box installieren
- Vagrant installieren
- Docker Client

# K2 <br>

Mein Wissenstand: <br>

- Containerisierung: <br>
	Mein Wissenstand über dieses Thema ist nicht sehr gross. Wir hatten bis jetzt einen ÜK darüber, mehr allerdings auch nicht. <br>
- Docker: <br>
	Was Docker betrifft, ist der Wissenstand noch geringer. Ich habe bis jetzt noch nie weder im Büro noch in einem ÜK mit Docker gearbeitet. <br>
- Microservice: <br>
	Bei Microservice habe ich das gleiche Problem wie bei Docker und der Containerisierung. Ich habe auch hier einen sehr geringen Wissestand über dieses Thema. <br>
<br>
Meine Lernschritte: <br>

- Containerisierung: <br>
	 Mit der Containerisierung kann extrem viel Ressourcen und Leistung gespart werden. Der Grund ist, dass Container die selbe Ressource teilen wie das Host Betriebsystem. <br>
	 Mit Container können somit sehr viele Services und Dienste simpel gewähleistet werden. <br>
- Docker: <br>
	Mit hilfe von Docker kann die Containerlösung realisiert werden. Ein Docker verwendet zwei Haupkomponenten zum einten ist dass der Docker Deamon und zum anderen die Docker Engine. 
	Mit dem Docker Deamon wir gewährleistet dass der Service betrieben werden kann und die Docker Engine kann man sich wie ein HyperVisor in der Container Welt vorstellen. <br>
- Microservice: <br>
	Microservice besteht aus diversen kleinen unabhängigen Komponenten. Der Vorteil hier ist, dass die Rechenleistung auf mehrere Host verteilt werden kann.
<br>

# K3 <br>
	Zuerst möchte ich kurz die Containerarchitektur aufzeigen, die bei Docker verwendet wird: <br>
	<img src="C:\Users\noa.violetti\Container.png" alt="Alt-Text" title="" />
	Damit ich in das Thema Reinkomme habe ich zuerst einige Simple Docker Files erstellt und geschaut ob ich diese zum laufen Kriege. <br>
	Dies war mein erstes Dockerfile: <br>
	From opensuse/leap <br>
	#Maintainer / Verwalter <br>
	Maintainer Noa Violetti <noavioletti@hotmail.com> <br>
	<br>
	RUN zypper ref <br>
	RUN zypper up -y <br>
	CMD ["echo", "Hello World.."] <br> 
	
	Bei diesem Docker File habe ich ein ganz eifnacher Container erstellt, der mit dem Gast OS von Opensuse ein Hello World ausgiebt. <br>
	<br> 
	Ich tastete mich immer weiter an das Thema ran und begann weiter Dinge auszuprobieren schlussendlich wollte ich ein Container zum laufen Kriegen der einen Apache Server zum laufen kriegt und ein Webtemplate inbegriffen hat. <br>
	Dies gelang mir schlussendlich auch. <br>
	Das Dockerfile dazu ist Folgendes: <br>
	<br>
	#Base <br>
	FROM ubuntu <br>
	#Externe Schnittstellen <br>
	Expose 80 <br>
	Expose 443 <br>
	#Volume mounten <br>
	Volume webservernoa:/var/www/html/ <br>
	Maintainer Noa Violetti	<noavioletti@hotmail.com> <br>
	#Build <br>
	#System Update <br>
	RUN apt-get update <br>
	RUN apt-get install apt-utils tzdata -y <br>
	RUN apt-get upgrade -y <br>
	RUN echo "Europe/Zurich" > /etc/timezone <br>
	RUN dpkg-reconfigure -f noninteractive tzdata <br>
	#Apache install <br>
	RUN apt-get install apache2 apache2-utils -y <br>
	#Apache Config <br>
	RUN a2enmod ssl <br>
	RUN a2ensite default-ssl.conf <br>
	RUN service apache2 restart <br>
	#Website <br>
	RUN apt-get install git -y <br>
	RUN git clone https://github.com/Hextris/hextris.git <br>
	RUN mv /hextris/* /var/www/html/ <br>
	#RUN rmdir hextris <br>
	#Entrypoint <br>
	ENTRYPOINT ["apache2ctl"] <br>
	#Instance <br>
	CMD ["-DFOREGROUND"] <br>
	<br>
	
	Zur erklärung was ich hier eigentlich gemacht habe. Ich habe ein Container erstellt der als Webserver agiert und der Hextris auf dem Webserver laufen lässt.
	Bei diesem Dockerfile wird als Gast OS Ubuntu verwendet. Danach werden die Ports 80 und 443 dem Container freigegeben.
	Ich habe noch ein Volumen erstellt damit wenn ich mehrere Webserver mit Hextris haben will, ich dieses Volumen verwenden kann. Als nächstes werden einige Grundkonfigurationen getätigt, damit man später weniger Probleme hat. 
	Nun kommen wir zum Punkt, wo wir beginnen den Webserver zu installieren. Weil ich via HTTPS auf meinen Container zugreifen möchte muss ich dies ebenfalls noch konfigurieren.
	Jetzt habe ich einen Webserver mit der default Apache Seite. Ich habe nun noch ein Webtemplate eingebaut, wo Hextris darauf läuft. Jetzt muss das Dockerfile noch gebuilded werden und dann kann der Container getestet werden. <br>

- Dockerbefehle <br>
		
# K4 <br>
# K5 <br>
# K6 <br>