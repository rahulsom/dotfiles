#!/usr/bin/env bash

# Top level commands
dcleanup() {
	docker rm -v $(docker ps --filter status=exited -q 2>/dev/null) 2>/dev/null
	docker rmi $(docker images --filter dangling=true -q 2>/dev/null) 2>/dev/null
}

del_stopped() {
	local name=$1
    if [ "$name" = "" ]; then
        docker ps -a | grep Exited | cut -f1 -d " " | xargs docker rm
    else
    	local state=$(docker inspect --format "{{.State.Running}}" $name 2>/dev/null)
    	if [[ "$state" == "false" ]]; then
    		docker rm $name
    	fi
    fi
}

# Useful containers
cadvisor() {
	docker run -d \
		--restart always \
		-v /:/rootfs:ro \
		-v /var/run:/var/run:rw \
		-v /sys:/sys:ro  \
		-v /var/lib/docker/:/var/lib/docker:ro \
		-p 1234:8080 \
		--name cadvisor \
		google/cadvisor

	open http://localhost:1234/
}
alias watchtower='docker run -d --restart always --name watchtower -v /var/run/docker.sock:/var/run/docker.sock centurylink/watchtower'

# Machine Learning
alias parsey='docker run --rm -i brianlow/syntaxnet 2>/dev/null'
alias pserve='docker run -it --rm -p 7777:80 andersrye/parsey-mcparseface-server'
alias rasa='docker run -p 5000:5000 -v $(pwd):/app rasa/rasa_nlu:latest-full start --path /app'
alias tflow='docker run --rm -v $(pwd):/local -it -w /local -e TF_CPP_MIN_LOG_LEVEL=2 gcr.io/tensorflow/tensorflow:latest-devel python'
# alias anaconda='docker run -i -t continuumio/anaconda /bin/bash'

# Parsing documents
alias tika='docker run --rm -v $(pwd):/local -it rahulsom/tika'

# Eclipse Che
alias che='docker run --rm -t -v /var/run/docker.sock:/var/run/docker.sock eclipse/che start'

## Databases
alias postgres='docker run --name postgres -e POSTGRES_PASSWORD=mysecretpassword -d -p 5432:5432 postgres:alpine'
alias pgsql='docker run --rm -it -e PGPASSWORD=mysecretpassword --link postgres:postgres postgres:alpine psql -h postgres -U postgres'

alias mysqld='docker run --name mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql'
function mysql() {
    docker run --rm -it --link mysql:mysql mysql sh -c \
        'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD"'
}

alias redis='docker run --name redis -d -p 6379:6379 redis:alpine'
alias redis-cli='docker run -it --link redis:redis --rm redis:alpine redis-cli -h redis -p 6379'

alias cassandra='docker run --name cassandra -d -p 9042:9042 cassandra'
function cqlsh() {
    docker run -it --link cassandra:cassandra --rm cassandra sh -c 'exec cqlsh "$CASSANDRA_PORT_9042_TCP_ADDR"'
}

alias mongod='docker run --name mongo --rm -p 27017:27017 mongo'
function mongo() {
    docker run -it --link mongo:mongo --rm mongo sh -c \
            'exec mongo "$MONGO_PORT_27017_TCP_ADDR:$MONGO_PORT_27017_TCP_PORT/test"'
}

alias mssql="docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=P@55w0rd' -p 1433:1433 --name mssql microsoft/mssql-server-linux"
alias sql-cli='docker run -it --rm --link mssql:mssql --entrypoint /usr/local/bin/mssql shellmaster/sql-cli -s mssql -u SA -p P@55w0rd'

## Other Utils
# xq launches xquartz in a way you can tunnel docker applications into it for X11 usage
alias xq='socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"'

## Text tools
alias pcat='docker run --rm -v $(pwd):/local rahulsom/pcat'
alias irssi='docker run -it --rm -e TERM -u $(id -u):$(id -g) --log-driver=none -v $HOME/.irssi:/home/user/.irssi:ro irssi:alpine'
alias careercup='docker run --rm -v $(pwd):/local rahulsom/careercup'
alias asciidoctor='docker run -it -v $(pwd):/documents/ asciidoctor/docker-asciidoctor asciidoctor -r asciidoctor-diagram'
# This is not very helpful for hitting localhost
# alias http='docker run -ti --rm alpine/httpie'
alias telnet='docker run -it mikesplain/telnet'
alias dot='docker run -v $(pwd):/graphviz markfletcher/graphviz dot'
alias ack='docker run -it -v $(pwd):/data rahulsom/ack'
httpstat() {
  docker run -it --rm ondrejmo/httpstat "$@"
}
hostess() { docker run -it --rm -v /private/etc/hosts:/etc/hosts ondrejmo/hostess "$@" }
how2() { docker run -it --rm ondrejmo/how2 "$@" }
udict() { docker run -it --rm ondrejmo/udict "$@" }

## Browsers
alias dfirefox='docker run --rm -e DISPLAY=${IP}:0 jess/firefox'
alias torbrowser='docker run --rm -e DISPLAY=${IP}:0 paulczar/torbrowser'
alias dchrome='docker run --rm -it -e DISPLAY=${IP}:0 jess/chrome --user-data-dir=/data --no-sandbox'
alias lynx='docker run --rm -it jess/lynx'

## Other apps
alias jenkins='docker run --rm -p 8080:8080 -p 50000:50000 -v $(pwd):/var/jenkins_home jenkins/jenkins:alpine'
alias nexus='docker run --rm -p 8081:8081 -v $(pwd):/nexus-data sonatype/docker-nexus3'
alias artifactoryoss='docker run --rm -v $(pwd)/data:/var/opt/jfrog/artifactory/data -v $(pwd)/logs:/var/opt/jfrog/artifactory/logs -v $(pwd)/etc:/var/opt/jfrog/artifactory/etc -p 8081:8081 docker.bintray.io/jfrog/artifactory-oss:latest'
alias artifactoryregistry='docker run --rm -v $(pwd)/data:/var/opt/jfrog/artifactory/data -v $(pwd)/logs:/var/opt/jfrog/artifactory/logs -v $(pwd)/etc:/var/opt/jfrog/artifactory/etc -p 80:80 -p 8081:8081 docker.bintray.io/jfrog/artifactory-registry:latest'
alias elasticsearch='docker run --rm --name elasticsearch -p 9200:9200 -p 9300:9300 elasticsearch:alpine'
alias zookeeper='docker run --name some-zookeeper --restart always -d -p 2181:2181 -p 2888:2888 -p 3888:3888 zookeeper'
alias ihaskell='docker run --rm -v $(pwd):/notebooks -p 8888:8888 gibiansky/ihaskell'
alias igroovy='docker run --rm -v $(pwd):/home/jovyan/work -p 8888:8888 rahulsom/igroovy'
alias ijulia='docker run --rm -p 8888:8888 -v $PWD:/data auchida/ijulia'
alias sonarqube='docker run --rm -p 9000:9000 -p 9092:9092 sonarqube:alpine'
alias smtpstart='docker run --rm -p 25:25 --name smtpserver -d namshi/smtp'
alias smtpstop='docker kill smtpserver'

## Compilers
alias elm='docker run -it --rm -v "$(pwd):/code" -v /tmp:/tmp -w "/code" -e "HOME=/tmp" -u $UID:$GID -p 8000:8000 codesimple/elm:0.19'

function letsencrypt() {
    docker run -it --rm \
        -v $(pwd):/etc/letsencrypt \
        -p 80:80 -p 443:443 \
        xataz/letsencrypt $@
}

## OSes
alias ubuntu='docker run --rm -it --hostname ubuntu -v $(pwd):/local -w /local ubuntu bash'
alias centos='docker run --rm -it --hostname centos -v $(pwd):/local -w /local centos bash'
alias openjdk='docker run --rm -it --hostname openjdk -v $(pwd):/local -w /local openjdk:8-alpine sh'
alias alpine='docker run --rm -it --hostname alpine -v $(pwd):/local -w /local alpine sh'

alias t4re='docker run --rm -it -v $(pwd):/home/work tesseractshadow/tesseract4re tesseract'
