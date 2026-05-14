CREATE DATABASE sonarqube_db;

CREATE USER sonar_user WITH PASSWORD 'chaimae1702';

GRANT ALL PRIVILEGES ON DATABASE sonarqube_db TO sonar_user;
