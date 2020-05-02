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

![Alt-Text](https://config.server-core.ch/bilder/m300/Container.jpg)<br>
In diesem Bild wird simpel aufgezeigt wie die Architektur von Container aussieht. <br>
<br>
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

- Netzwerkplan
![Alt-Text](https://config.server-core.ch/bilder/m300/Netzwerk.jpg)<br>
Das Dockernetz wird an die VM weitergeleitet. Somit kommt man direkt via localhost und dem Zugwiesenen Port auf den Container. <br> 

- Dockerbefehle <br>
	docker build: Mit Docker Build wird das Docker Image gebuilded zb: docker build -t Test:1.0 . <br>
	Im folgenden Beispiel wird ein Image mit dem Namen inklusive dem Tag 1.0 gebuilded. Der Punkt steht alternativ für das Dockerfile, welches als Ressource verwendet werden sollte. <br>
	<br>
	docker run: Docker Run ist der Befehl für das ausführen von Docker Container. zb: docker run -itd Test:1.0 <br>
	In diesem Beispiel wird das Test Image ausgeführt mit dem Tag 1.0 und mit interactivem Shell und detach mode. <br>
	<br>
	docker volume: Dieser Befehl wird bei Volumen verwendet. <br>
	docker volume creat xy, wird ein Volumen erstellt. <br>
	docker volume ls werden alle Volumen aufgelistet. <br>
	<br>
	docker ps: Docker ps zeigt alle aktive laufenden Docker Container an. <br>
	<br>
	docker image: Docker image listet alle gebuildeten Image auf. <br>
	<br>
	docker rm: Mit diesem Befehl können Container entfernt werden. <br>
	<br>
	docker rmi: Hier können die Image entfernt werden. <br>
	<br>
	docker start: Container wird ausgeführt. <br>	
	<br>
	docker stop: Container wird angehalten. <br>

- Anweisungen im Dockerfile: <br>
	From: deviniert was das Gast OS ist. <br>
	Expose: Port werden für Container freigegeben <br>
	Volume: Volume wird definiert. <br>
	Maintainer: Setzt Besitzer des Image <br>
	RUN: Befehle werden umgesetzt beim erstmaligen installieren des Containers<br>	
	CMD: Befehle werden bei jedem Start umgesetzt <br>
	ENTRYPOINT: Definiert die ausführbare Datei, die beim Start des Contaiers laufen soll. <br>
	
- Testfälle: <br>
	Testen ob der Unsercontainer läuft:<br>
	docker ps <br>
	Gestarteter Docker sollten aufgeführt sein. <br>
	![Alt-Text](https://config.server-core.ch/bilder/m300/dockerps.JPG)<br>
	Funktionalität Test: <br>
	docker run -itd -p81:80 -p444:443 webservernoa:(Tag) <br>
	docker muss via Browser auf HTTPS mit dem Port 444 sowie via HTTP mit Port 81 erreichbar sein. Hextris sollte ebenfalls laufen. <br>
	![Alt-Text](https://config.server-core.ch/bilder/m300/httptest.JPG) ![Alt-Text](https://config.server-core.ch/bilder/m300/Testfunktionalitaet.JPG)<br>
	<br>
	Curl abfrage testen:<br>
	curl http://localhost:81<br>
	Website Code sollte danach ersichtlich sein. Der Test wird hier nur ausgeführt auf HTTP, da wir zuvor den Test getätigt haben auf der Website und es dort die funktionalität von HTTPS schon gewährleitet sein solte. <br>
	![Alt-Text](https://config.server-core.ch/bilder/m300/curl.JPG)<br>
	<br>
# K4 <br>
# K5 <br>
# K6 <br>