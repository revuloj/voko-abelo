#!/bin/bash

# debug
# set -x

redaktantoj=${HOME}/etc/redaktantoj

# toleru malbonajn liniojn en redaktantoj
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
        # traktu ĉion antaŭ la apartigilo IFS='<' kiel nomo de redaktanto
        nom_1=${ar[0]## } # forigu spacon komence
        nom_2=${nom_1%% } # forigu spacon fine
        nom=${nom_2//\'/\'\'} # apostrofon anstatataŭigu per du
        echo -e "insert into redaktanto(red_id,red_nomo) values (${n},'${nom}');\n"

        # registru la retadreso(j)n
        r=0
        for rp in "${ar[@]:1}"
        do
            rpx=${rp%">"*} # forigu '>' kaj io ajn post ĝi
            let "r++"
            echo -e "insert into email(ema_red_id,ema_email,ema_sort) values (${n},'${rpx}',${r}) on duplicate key update ema_email=ema_email;\n"
        done

    done < "${redaktantoj}"

    echo -e "commit;\n"

fi

set -e


