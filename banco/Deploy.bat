@echo off

set docker_path_name=Docker Desktop.exe
tasklist /FI "IMAGENAME eq %docker_path_name%" 2>NUL | find /I /N "%docker_path_name%">NUL
rem if not "%ERRORLEVEL%"=="0" start "C:\Program Files\Docker\Docker\Docker Desktop.exe"

echo Verificando e parando outras instancias...
docker stop pgadmin
docker stop postgres

echo Removendo o container anterior...
docker rm pgadmin
docker rm postgres

echo Criando e executando o container...

docker volume rm pg-vol
docker volume create pg-vol
docker run --name postgres -p 5432:5432 -v pg-vol:/var/lib/postgresql/data -e PGDATA=/var/lib/postgresql/data/pgdata -e POSTGRES_USER=admin -e POSTGRES_PASSWORD=admin -e POSTGRES_DB=database -d postgres

docker volume create pgadmin-vol
docker run --name pgadmin -p 8080:80 -v pgadmin-vol:/var/lib/pgadmin -e PGADMIN_DEFAULT_EMAIL=admin@admin -e PGADMIN_DEFAULT_PASSWORD=admin -d dpage/pgadmin4

timeout 10
