https://linux-man.fr/index.php/2020/12/28/docker-compose-ocs-glpi-mysql/


Skip to content
Linux-Man-Logo-Transparent-1.png	

    Linux
    Python
    Devops
    Services
    Nous contacter

Rechercher
Déployer GLPI et OCS en HTTPS avec Docker-compose en 2 minutes
docker-compose docker ocs glpi mysql
Introduction

Aujourd’hui, je veux te parler d’un projet que j’ai créé récemment avec Docker-compose.

Si tu es comme moi et que tu gères plusieurs serveurs et applications, tu sais à quel point ça peut être fastidieux de tout installer et configurer manuellement.

C’est pourquoi j’ai créé ce projet pour te faciliter la vie en déployant automatiquement GLPI et OCS avec HTTPS.

GLPI et OCS, ce sont deux logiciels open-source très utiles pour gérer les actifs informatiques et les inventaires de ton réseau. Avec ce projet tu peux les installer en un rien de temps et bénéficier du chiffrement HTTPS pour une sécurité accrue. Et l’avantage c’est que tout est automatisé grâce à un script que j’ai écrit pour toi !

Dans cet article, je vais te montrer comment j’ai mis à jour ce projet en y ajoutant le support HTTPS pour GLPI et OCS.

Si tu veux juste le script c’est dispo sur mon Gitlab.

Si tu es prêt à simplifier ta vie de sysadmin, reste avec moi et découvrons ensemble comment déployer GLPI et OCS en HTTPS avec Docker-compose.
Présentation du projet

On le sait tous, GLPI et OCS sont deux outils incontournables pour gérer notre parc informatique et suivre l’inventaire de notre matériel.

Mais leur installation et configuration peuvent parfois être un peu longues et fastidieuses, n’est-ce pas ? 😅

Eh bien, j’ai une excellente nouvelle pour toi : avec ce projet Docker-compose, fini les prises de tête ! Tu vas pouvoir déployer GLPI et OCS en un rien de temps, le tout sécurisé grâce au protocole HTTPS.
Déployer ton projet docker GLPI/OCS en 1 instant

Simple :

git clone https://gitlab.com/babidi34/docker-compose-ocs-glpi-mysql
cd docker-compose-ocs-glpi-mysql

    Si tu as un certificat et une clé ssl :
        place les dans le dossier ssl et renomme-les respectivement ssl.crt et ssl.key.
    Si tu n’as pas de certificat et clé SSL :
        tu n’as rien à faire le script va générer un certificat auto-signé pour toi

Lance le script :

./setup.sh

En une ou 2 minutes le script aura déployer tes services OCS et GLPI en HTTPS (ainsi qu’une base de données MySQL)
Utiliser ses propres certificats SSL

Si tu veux utiliser tes propres certificats SSL, voici comment faire :

    Assure-toi d’avoir tes fichiers ssl.crt et ssl.key prêts. Ce sont les certificats SSL que tu souhaites utiliser pour sécuriser tes conteneurs GLPI et OCS.
    Dans le dossier du projet, tu trouveras un sous-dossier nommé ssl/. Place tes fichiers ssl.crt et ssl.key dans ce dossier.
    Lance le script :

./setup.sh

Utilisation des services GLPI et OCS avec HTTPS

Une fois les conteneurs créent (généralement 2-3 minutes), les services GLPI et OCS sont disponibles

    GLPI: https://localhost/glpi
    OCS Inventory: https://localhost:8443/ocsreports

Les identifiants par défaut
GLPI :

    Username : glpi
    Password : glpi

OCS Inventory :

    Username : admin
    Password : admin

Comprendre comment fonctionne le projet
Le docker-compose :


version: '3.3'

services:
  mysql :
    image : mysql:8-debian
    container_name : mysql
    hostname: mysql
    restart: always
    expose :
      - "3306"
    environment:
      MYSQL_RANDOM_ROOT_PASSWORD: "true"
    volumes :
      - ./sql/:/docker-entrypoint-initdb.d/
      - sqldata:/var/lib/mysql
    networks:
      glpi_project:
  glpi:
    image: debian:11
    container_name: glpi
    hostname: glpi
    restart: always
    ports:
      - 443:443
    env_file:
      - secrets.env
    volumes:
      - ./ssl/ssl.key:/etc/ssl/glpi.key
      - ./ssl/ssl.crt:/etc/ssl/glpi.crt
      - ./front/vhost_glpi.conf:/etc/nginx/sites-available/glpi.conf
      - ./scripts/glpi-setup.sh:/usr/local/bin/glpi-setup.sh
      - glpidata:/var/www/html/glpi/
    networks:
      glpi_project:
    depends_on:
      - mysql
    command: /usr/local/bin/glpi-setup.sh
  ocs:
    image: ocsinventory/ocsinventory-docker-image:2.10
    container_name: ocs
    hostname: ocs
    restart: always
    ports:
      - 8443:443
    env_file:
      - secrets.env
    volumes:
      - ./ssl/ssl.key:/etc/ssl/private/ocs.key
      - ./ssl/ssl.crt:/etc/ssl/certs/ocs.crt
      - ./front/vhost_ocs.conf:/etc/nginx/sites-available/ocs.conf
      - ./scripts/ocs-setup.sh:/usr/local/bin/ocs-setup.sh
      - ./front/ocs_nginx.conf:/root/nginx.conf
      - perlcomdata:/etc/ocsinventory-server
      - extensionsdata:/usr/share/ocsinventory-reports/ocsreports/extensions
      - varlibdata:/var/lib/ocsinventory-reports
      - httpdconfdata:/etc/httpd/conf.d
    networks:
      glpi_project:
    depends_on:
      - mysql
    command: /usr/local/bin/ocs-setup.sh

 
networks:
  glpi_project:

volumes:
  sqldata:
  glpidata:
  perlcomdata:
  extensionsdata:
  varlibdata:
  httpdconfdata:

Version :

La version de Docker Compose utilisée est ‘3.3’.
Services :

Le fichier décrit trois services : mysql, glpi et ocs.
mysql :

Ce service utilise l’image mysql:8-debian pour déployer un conteneur MySQL. Il expose le port 3306 et stocke les données dans un volume nommé sqldata. Le conteneur utilise le réseau glpi_project.
GLPI :

Ce service utilise l’image debian:11 pour déployer un conteneur GLPI. Il redirige le port 443 vers le port 443 du conteneur. Le conteneur utilise le réseau glpi_project et dépend du service mysql. Les certificats SSL, les configurations et les scripts nécessaires sont montés dans les volumes appropriés. Les données GLPI sont stockées dans le volume glpidata.
OCS :

Ce service utilise l’image ocsinventory/ocsinventory-docker-image:2.10 pour déployer un conteneur OCS Inventory. Il redirige le port 8443 vers le port 443 du conteneur. Le conteneur utilise le réseau glpi_project et dépend du service mysql. Les certificats SSL, les configurations et les scripts nécessaires sont montés dans les volumes appropriés. Les données OCS sont stockées dans les volumes perlcomdata, extensionsdata, varlibdata et httpdconfdata.
Réseau :

Un seul réseau est défini : glpi_project. Tous les services (mysql, glpi et ocs) sont connectés à ce réseau.
Volumes :

Plusieurs volumes sont définis pour stocker les données et les configurations :
sqldata :

Stocke les données de la base de données MySQL.
glpidata :

Stocke les données de GLPI.
perlcomdata, extensionsdata, varlibdata et httpdconfdata :

Stockent les données et les configurations d’OCS Inventory.
Dossier front :

Le dossier front contient les fichiers de configurations des serveurs web utilisé dans les conteneurs docker ocs et glpi.
Dossier sql :

Contient les fichiers SQL pour initialiser les bases de données de GLPI et OCS dans le conteneur docker mysql.
Dossier scripts :

Ce dossier contient les scripts glpi-setup.sh et ocs-setup.sh utilisé lors de la création de OCS et GLPI pour les configurer.
glpi-setup.sh :

Voici une explication rapide des différentes étapes du script :

    Le script vérifie si le fichier de configuration de la base de données GLPI (/var/www/html/glpi/config/config_db.php) existe déjà. Si ce n’est pas le cas, cela signifie que GLPI n’est pas encore installé et configuré et le script continue à exécuter les étapes suivantes.
    Le script met à jour les paquets et installe les paquets nécessaires pour le serveur web Nginx et PHP.
    Il télécharge la version 9.5.7 de GLPI depuis GitHub, l’extrait dans /var/www/html/ et change le propriétaire des fichiers GLPI pour l’utilisateur www-data (utilisé par nginx).
    Le script crée un lien symbolique pour activer la configuration Nginx de GLPI et supprime la configuration par défaut de Nginx. Il ajoute également la directive daemon off; à la configuration de Nginx pour empêcher le processus Nginx de devenir un démon.
    Le script installe GLPI en utilisant l’outil de console. Il spécifie les informations de connexion à la base de données (hôte, utilisateur, mot de passe et nom de la base de données) et la langue par défaut. L’option --no-interaction permet d’installer GLPI sans interaction utilisateur.
    Enfin, le script démarre le service PHP-FPM et lance le serveur Nginx.

En résumé, ce script installe et configure GLPI sur un serveur Debian avec Nginx si ce n’est pas déjà fait, et démarre ensuite les services PHP-FPM et Nginx pour servir l’application GLPI.

On l’utilise pour notre conteneur GLPI mais il peut aussi être utilisé sur un serveur Debian 11.
ocs-setup.sh :

Il est utilisé pour configurer OCS Inventory avec Nginx comme proxy inverse.

Voici une explication rapide des différentes étapes du script :

    Le script vérifie si le fichier de configuration d’OCS Inventory pour Nginx (/etc/nginx/sites-enabled/ocs.conf) existe déjà. Si ce n’est pas le cas alors ça signifie qu’OCS Inventory n’est pas encore configuré et le script continue à exécuter les étapes suivantes.
    Le script installe le paquet iproute2 (j’ai oublié de le retirer, à la base c’était pour faire du debug 😅) et télécharge le paquet Nginx pour Ubuntu.
    Il télécharge et installe le paquet Nginx.
    Le script copie un fichier de configuration Nginx spécifique pour OCS Inventory (/root/nginx.conf) dans le répertoire de configuration de Nginx (/etc/nginx/nginx.conf). Il supprime également le fichier de configuration par défaut de Nginx.
    Il crée les répertoires /etc/nginx/auth et /etc/nginx/sites-enabled, puis crée un lien symbolique pour activer la configuration Nginx d’OCS Inventory.
    Le script crée un fichier de mot de passe pour l’authentification HTTP basique avec les informations d’identification ocsapi et un mot de passe chiffré.
    Enfin, le script démarre le serveur Apache (apachectl start) et lance le serveur Nginx.

Le script configure OCS Inventory avec Nginx comme proxy inverse, si ce n’est pas déjà fait et démarre ensuite les services Apache et Nginx pour servir l’application OCS Inventory.
Le fichier secrets.env :

Le fichier contient les user et mot de passe des base de données des services, tu peux les modifier si besoin.
Le fichier setup.sh

C’est le fichier qui lances pour toi le docker-compose avec tous ce qu’il faut.

#!/bin/bash


source secrets.env

sql_final_file="sql/initdb.sql"

# Lisez le fichier SQL d'origine et remplacez les variables par les valeurs définies
sed -e "s|\${glpi_database_name}|${glpi_database_name}|g" \
    -e "s|\${glpi_database_user}|${glpi_database_user}|g" \
    -e "s|\${glpi_database_password}|${glpi_database_password}|g" \
    -e "s|\${OCS_DB_NAME}|${OCS_DB_NAME}|g" \
    -e "s|\${OCS_DB_USER}|${OCS_DB_USER}|g" \
    -e "s|\${OCS_DB_PASS}|${OCS_DB_PASS}|g" \
    sql/initdb.sql.template > "$sql_final_file"

if [ ! -f ssl/ssl.crt ] || [ ! -f ssl/ssl.key ]; then
    echo "Les fichiers ssl.crt et ssl.key sont manquants dans le dossier ssl/. Génération d'un certificat auto-signé..."
    mkdir -p ssl
    openssl req -x509 -nodes -days 3650 -newkey rsa:4096 -keyout ssl/ssl.key -out ssl/ssl.crt -subj "/C=FR/ST=France/L=Paris/O=entreprise/CN=localhost" 
fi

docker-compose build && docker-compose up -d

    Le script commence par charger les variables d’environnement depuis le fichier secrets.env.
    Ensuite, le script lit le fichier SQL modèle (sql/initdb.sql.template) et remplace les variables par les valeurs définies dans secrets.env. Le fichier final est enregistré sous sql/initdb.sql.
    Le script vérifie si les fichiers de certificat SSL (ssl/ssl.crt) et de clé SSL (ssl/ssl.key) existent dans le dossier ssl/. Si ces fichiers n’existent pas, le script génère un certificat SSL auto-signé avec la commande openssl.
    Enfin, le script construit et démarre les services définis dans le fichier docker-compose.yml en utilisant la commande docker-compose build && docker-compose up -d.

En gros ce script prépare les fichiers de configuration nécessaires, génère un certificat SSL auto-signé si nécessaire et déploie les services GLPI et OCS Inventory à l’aide de Docker Compose.
Conclusion

Dans cet article, nous avons vu comment déployer GLPI et OCS en HTTPS avec Docker-compose.

Nous avons ajouté le support HTTPS pour sécuriser les communications entre les clients et les serveurs GLPI et OCS et avons automatisé le processus de déploiement avec un script.

Ce projet facilite grandement l’installation et la configuration de ces deux outils indispensables pour gérer ton parc informatique et suivre l’inventaire de ton matériel.

Je t’encourage vivement à essayer ce projet mis à jour et à partager tes commentaires et tes suggestions pour l’améliorer encore davantage.
Besoin d’aide ?

Si jamais tu te retrouves coincé(e) en sauvegardant ou en restaurant ton site WordPress, n’hésite pas à me joindre pour un coup de main ==> page de contact.

Je suis là pour toi si tu as des questions ou des soucis avec ton serveur ou tes scripts en général.

Je mets à profit mon savoir-faire pour t’épauler dans la prise en charge de ton site et de ton infrastructure.

Le bouche-à-oreille est notre meilleur ami, merci de partager autour de toi 🫀
Partager :

    TwitterFacebookLinkedInPinterest1

Tags: automatisation, docker, docker-compose, infra as code
Read more articles
Article précédentDocker – La base
Article suivantLogstash, installation, input et output
Vous devriez également aimer
Déployer un projet Django sur un serveur Centos7/8 Apache	
Déployer un projet Django sur un serveur Centos7/8 Apache
24 janvier 2021
Gitlab vers Github – Importer ses projets Gitlab dans Github	
Gitlab vers Github – Importer ses projets Gitlab dans Github
2 octobre 2022
Plex Docker	
Plex Docker
21 février 2023
Laisser un commentaire
Comment
Enter your name or username to comment
Enter your email address to comment
Enter your website URL (optional)

