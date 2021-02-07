FROM mysql:5.7.33
#FROM mariadb:10.0
LABEL maintainer=<diestel@steloj.de>

RUN  apt-get update \
  && apt-get install -y wget \
  && rm -rf /var/lib/apt/lists/* \
  && wget -nv http://www.reta-vortaro.de/alveno/revodb-`date -d "1 day ago" '+%Y%m%d'`.sql.gz \
  && mv *.sql.gz /docker-entrypoint-initdb.d/

COPY initdb.d/* /docker-entrypoint-initdb.d/

#COPY initdb.d/z0* /docker-entrypoint-initdb.d/
#COPY initdb.d/z2* /



