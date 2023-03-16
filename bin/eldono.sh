#!/bin/bash

# kreas/eldonas la procezujon kun la mysql-datumbazo por la retpaĝo de Revo:
#
# Tio estas la eldono de voko-grundo kontraŭ kiu ni kompilas ĉion
# ĝi devas ekzisti jam kiel git-tag (kaj sekve kiel kodarĥivo kaj procezujo) en Github
# en celo "preparo" ni metas tiun eldonon ankaŭ por dosiernomoj kc. de voko-araneo
# Ni ankaŭ supozas, ke nova eldono okazas en git-branĉo kun la sama nomo
# Ĉe publikigo marku la kodstaton per etikedo (git-tag) v${eldono}.
# Dum la realigo vi povas ŝovi la etikedon ĉiam per celo "etikedo".
#eldono=2g

# ni komprenas preparo | kreo | docker | servilo | etikedo
# kaj supozas "docker", se nenio donita argumente
target="${1}"
procezujo="voko-abelo"

case $target in
servilo)
    ;;
preparo)
    # kontrolu ĉu la branĉo kongruas kun la agordita versio
    branch=$(git symbolic-ref --short HEAD)
    if [ "${branch}" != "${eldono}" ]; then
        echo "Ne kongruas la branĉo (${branch}) kun la eldono (${eldono})"
        echo "Agordu la variablon 'eldono' en tiu ĉi skripto por prepari novan eldonon."
        exit 1
    fi
    ;;
etikedo)
    echo "Provizante la aktualan staton per etikedo (git tag) v${eldono}"
    echo "kaj puŝante tiun staton al la centra deponejo"
    git tag -f v${eldono} && git push && git push --tags -f
    ;;
kreo)
    echo "Kreante lokan procezujon (por docker) voko-araneo por eldono ${eldono}..."
    docker pull ghcr.io/revuloj/${procezujo}/${procezujo}:${eldono}
    docker build --build-arg VERSION=${eldono} --build-arg VG_TAG=v${eldono} \
        -t ${procezujo} .
    ;;
esac