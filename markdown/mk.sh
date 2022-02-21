#!/bin/bash

GITHUB_PUSH=0
CREATE_TAR=0

if [ "${GITHUB_PUSH}" = "1" ]; then
    echo $CR_PAT | docker login ghcr.io -u abatalev --password-stdin
fi

function build_image () {
    echo "-[build ${3}]------------" 
    docker build -t ${3} -f ${2} .
    docker tag ${3} ghcr.io/${3}
    if [ "${CREATE_TAR}" = "1" ]; then
        echo "-[save images]-----------"
        docker save -o ../${1} ${3} ${4}
    fi

    if [ "$GITHUB_PUSH" = "1" ]; then
        echo "-[publish image ${1}]----"
        docker push ghcr.io/${3}
    fi
}

build_image pandoc.tar Dockerfile.pandoc abatalev/pandoc:2.17.1.1 alpine3.15.0
build_image texlive.tar Dockerfile.texlive abatalev/texlive:20210325-r5 alpine3.15.0
build_image pandoc-pdf.tar Dockerfile.pandoc-pdf abatalev/pandoc-pdf:2.17.1.1  abatalev/texlive:20210325-r5
