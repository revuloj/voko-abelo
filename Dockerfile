FROM mysql:5.5.62
MAINTAINER <diestel@steloj.de>

RUN  apt-get update \
  && apt-get install -y wget \
  && rm -rf /var/lib/apt/lists/* \
  && wget -nv http://www.reta-vortaro.de/alveno/revodb-`date -d "1 day ago" '+%Y%m%d'`.sql.gz \
  && mv *.sql.gz /docker-entrypoint-initdb.d/

COPY *.sql /docker-entrypoint-initdb.d/


