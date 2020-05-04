docker run -itd -p81:80 -p444:443 -p2000:19999 -v ~/webservernoa:/var/www/html -c 1024 -m 512000000 webservernoa:5.9
docker exec (Container Name) bash -c 'while true; do echo "i.O"; sleep 1; done;'
