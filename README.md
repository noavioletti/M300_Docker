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
	#Expose 19999 <br>
	RUN apt-get install bash -y
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
	#Netdata Monitoring <br>
	#RUN apt-get install netdata -y <br>
	#RUN sed 's/127.0.0.1/0.0.0.0/' /etc/netdata/netdata.conf <br>
	#RUN service netdata start <br>
	#User Group ADD <br>
	RUN groupadd -r usergruppe && useradd -r -g usergruppe defaultuser <br>
	USER defaultuser <br>
	#Entrypoint <br>
	ENTRYPOINT ["apache2ctl"] <br>
	#Instance <br>
	CMD ["-DFOREGROUND"] <br>
	<br>
	
Zur erklärung was ich hier eigentlich gemacht habe. Ich habe ein Container erstellt der als Webserver agiert und der Hextris auf dem Webserver laufen lässt.
Bei diesem Dockerfile wird als Gast OS Ubuntu verwendet. Danach werden die Ports 80 und 443 dem Container freigegeben.
Ich habe noch ein Volumen erstellt damit wenn ich mehrere Webserver mit Hextris haben will, ich dieses Volumen verwenden kann. Als nächstes werden einige Grundkonfigurationen getätigt, damit man später weniger Probleme hat. 
Nun kommen wir zum Punkt, wo wir beginnen den Webserver zu installieren. Weil ich via HTTPS auf meinen Container zugreifen möchte muss ich dies ebenfalls noch konfigurieren.
Jetzt habe ich einen Webserver mit der default Apache Seite. Ich habe nun noch ein Webtemplate eingebaut, wo Hextris darauf läuft. Den Rest werde ich bei K4 erklären. Jetzt muss das Dockerfile noch gebuilded werden und dann kann der Container getestet werden. <br>

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
	Website Code sollte danach ersichtlich sein. Der Test wird hier nur ausgeführt auf HTTP, da wir zuvor den Test getätigt haben auf der Website und es dort die funktionalität von HTTPS schon gewährleitet sein solte.
	Ansonsten müsste bei HTTPS das kleiche erscheinen, der Befehl wäre einfach curl -k https://localhost:444. <br>
	![Alt-Text](https://config.server-core.ch/bilder/m300/curl.JPG)<br>
	<br>
# K4 <br>
	
In diesem Bereich geht es darum was ich zum Schutz von meiner Container Umgebung getätigt habe. <br>
- Logging <br>
 	Mit folgendem Befehl in der Commandline des Docker kann geprüft werden ob der Docker i.O läuft. <br>
	docker exec (Container Name) bash -c 'while true; do echo "i.O"; sleep 1; done;' <br>
	Zur erklärung: Mit diesem Befehl verbindet man sich im ersten Teil mit der Bash des Containers. Im Zweiten Abschnitt wird solange der Request True ergibt eine ausgabe generiert mit i.O in Seckunden tackt. <br>
- Monitoring <br>
	Ich habe mich mit 4 Produkten auseinander gesetzt. Zum ersten war dies Cadvisor, dann Netdata und Prometheus mit Grafana. <br>
	Ich wollte zuerst Cadvisor laufen lassen. Ich arbeitete leider auf einer Windows Umgebung und merkte, dass ich diese nicht installieren resp aktivieren konnte. <br>
	Bei Netdata war ich sehr lange am Werk. Ich versuchte dies mithilfe meines Docker Containers direkt zu installieren. Weil ich dies nach mehreren Stunden nicht zum laufen gebracht habe, sind diese Infos auskomentiert in dem Dockerfile. <br>
	Ich habe weiterrechechiert und bin dan auf Prometheus und Grafana gestossen. Diese zwei Systeme habe ich als Docker Container laufen lassen.<br>
- Sicherheitsaspekte <br>
	Ich habe als erstes einen default user erstellt, der dazu da ist um mit möglichst wenig Recht zu arbeiten. Der User wurde auch gleich in eine erstellte Benutzergruppe gefügt und wird als standard shell benutzer aus geführt. <br>
	Ich habe zusätzlich meine Rechen leistung von meinem Container begrenzt. Ich habe dies bei zwei Komponenten angewendet zum einen war dies die CPU leistung und zum anderen die Memory leistung. <br>
	docker run -itd -p81:80 -p444:443 -p2000:19999 -v ~/webservernoa:/var/www/html -c 1024 -m 512000000 webservernoa:5.9 <br>
	Dies ist mein Standard befehl um den Container zu starten. Als erstes setzte ich den Parameter interactive terminal detached, dann mappe ich meine Ports und binde mein Volumen ein. Nun komme ich zum Punkt der ich vorhin erklärt habe mit der Ressourcen zuweisung. <br>
	Dieser Befehl könnte ich theoretisch via ein Docker Compose File automatisieren somit müsste ich nicht jedes mal ein so langer Befehl ausführen. Leider reichte mir dies Zeitlich nicht diese Variante zu realisieren. <br>
# K5 <br>
	
- Reflexion
	
# K6 <br>