#!/bin/sh

GITHUB_PUSH=0
CREATE_TAR=0

if [ $GITHUB_PUSH == 1 ]; then
    echo $CR_PAT | docker login ghcr.io -u abatalev --password-stdin
fi

function build_image() {
    echo "-[build ${3}]------------" 
    docker build -t ${3} -f ${2} .
    docker tag ${3} ghcr.io/${3}
    if [ ${CREATE_TAR} == 1 ]; then
        echo "-[save images]-----------"
        docker save -o ../${1} ${3} ${4}
    fi

    if [ $GITHUB_PUSH == 1 ]; then
        echo "-[publish image ${1}]----"
        docker push ghcr.io/${3}
    fi
}

function test_image() {
    cat Dockerfile.fontcheck | sed s%XXX%${1}%g > Dockerfile.test
    docker build -t abatalev/fontcheck -f Dockerfile.test . 2> /dev/null
    rm Dockerfile.test
    docker run --rm abatalev/fontcheck 1> /dev/null 2> /dev/null
    RES="$?"
    if [ $RES != 0 ]; then
        echo "ERROR ${RES} ${1}"
    else 
        echo "OK    ${1}"
    fi
}

build_image openjdk8.tar Dockerfile.openjre8 abatalev/openjdk:8-jre-alpine3.9-ttf openjdk:8-jre-alpine3.9 
build_image openjdk11.tar Dockerfile.openjre11 abatalev/openjdk:11-jre-alpine3.9-ttf adoptopenjdk/openjdk11:jre-11.0.11_9-alpine
build_image liberica8.tar Dockerfile.liberica8 abatalev/liberica:8-jre-alpine3.9-ttf bellsoft/liberica-openjre-alpine-musl:8u302-8
build_image liberica8.tar Dockerfile.liberica11 abatalev/liberica:11-jre-alpine3.9-ttf bellsoft/liberica-openjre-alpine-musl:11.0.12-7

echo "Tests"
test_image openjdk:8-jre-alpine3.9
test_image adoptopenjdk/openjdk11:jre-11.0.11_9-alpine
test_image bellsoft/liberica-openjre-alpine-musl:8u302-8
test_image bellsoft/liberica-openjre-alpine-musl:11.0.12-7
test_image abatalev/openjdk:8-jre-alpine3.9-ttf
test_image abatalev/openjdk:11-jre-alpine3.9-ttf
test_image abatalev/liberica:8-jre-alpine3.9-ttf
test_image abatalev/liberica:11-jre-alpine3.9-ttf
