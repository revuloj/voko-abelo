#!/bin/bash

# debug
# set -x

mysql=( mysql -u root -p"${MYSQL_ROOT_PASSWORD}" "${MYSQL_DATABASE}" )
#redaktantoj=${HOME}/etc/redaktantoj
redaktantoj=/run/secrets/voko.redaktantoj
tmp=/tmp/redaktantoj.sql

# tolerate bad lines in redaktantoj
set +e

# legu la liston de redaktantoj el sekreto kaj aldonu al la datumbazo
if [ -e "${redaktantoj}" ]; then

    n=0

    while read -r line
    do
        #echo "$line""
        IFS='<' read -r -a ar <<< "$line"

        let "n++"
        # problemo kun apostrofo...: nom=$(echo "${ar[0]}" | xargs)
        nom_1=${ar[0]## }
        nom_2=${nom_1%% }
        nom=${nom_2//\'/\'\'}
        echo -e "insert into redaktanto(red_id,red_nomo) values (${n},'${nom}');\n" >> ${tmp}
        r=0
        for rp in "${ar[@]:1}"
        do
            rpx=${rp%">"*}
            let "r++"
            echo -e "insert into email(ema_red_id,ema_email,ema_sort) values (${n},'${rpx}',${r}) on duplicate key update ema_email=ema_email;\n" >> ${tmp}
        done

    done < "${redaktantoj}"

    echo -e "commit;\n" >> ${tmp}

    "${mysql[@]}" < "${tmp}"; echo ;
    rm ${tmp}
fi

set -e


