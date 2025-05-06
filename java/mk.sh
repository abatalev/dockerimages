#!/bin/sh

GITHUB_PUSH=0
CREATE_TAR=0

CDIR=$(pwd)

if [ ! -f "../tools/smartdockerbuilder/sdb" ]; then
    if [ ! -d "../tools" ]; then
        mkdir ../tools
    fi 
    cd ../tools || exit
    git clone https://github.com/abatalev/smart-docker-builder.git smartdockerbuilder 
    cd smartdockerbuilder || exit
    ./mk.sh
    cd "${CDIR}" || exit
fi

if [ "${GITHUB_PUSH}" = "1" ]; then
    echo "$CR_PAT" | docker login ghcr.io -u abatalev --password-stdin
fi

build_image () {
    echo "-[build ${3}]------------" 
    docker build -t "${3}" -f "${2}" .
    docker tag "${3}" "ghcr.io/${3}"
    if [ "${CREATE_TAR}" = "1" ]; then
        echo "-[save images]-----------"
        docker save -o "../${1}" "${3}" "${4}"
    fi

    if [ "$GITHUB_PUSH" = "1" ]; then
        echo "-[publish image ${1}]----"
        docker push "ghcr.io/${3}"
    fi
    echo "-[build ${3} - done ]-------"
}

test_image () {
    cat Dockerfile.fontcheck | sed "s%XXX%${1}%g" > Dockerfile.test
    docker build -t abatalev/fontcheck -f Dockerfile.test . 2> /dev/null
    rm Dockerfile.test
    docker run --rm abatalev/fontcheck 1> /dev/null 2> /dev/null
    RES="$?"
    if [ $RES != 0 ]; then
        echo " => ERROR ${RES} ${1}"
    else 
        echo " => OK    ${1}"
    fi
    docker image rm abatalev/fontcheck:latest > /dev/null
}

BUILD_OLD=0

if [ "$BUILD_OLD" = "1" ]; then

    echo "### Tests java 8"
    
    build_image openjdk8.tar Dockerfile.openjre8 abatalev/openjdk:8-jre-alpine3.9-ttf openjdk:8-jre-alpine3.9 
    build_image liberica8.tar Dockerfile.liberica8 abatalev/liberica:8-jre-alpine3.9-ttf bellsoft/liberica-openjre-alpine-musl:8u322-6
    
    test_image openjdk:8-jre-alpine3.9
    test_image bellsoft/liberica-openjre-alpine-musl:8u333-2
    test_image abatalev/openjdk:8-jre-alpine3.9-ttf
    test_image abatalev/liberica:8-jre-alpine3.9-ttf


    echo "### Tests java 11"
    build_image openjdk11.tar Dockerfile.openjre11 abatalev/openjdk:11-jre-alpine3.9-ttf adoptopenjdk/openjdk11:jre-11.0.11_9-alpine
    build_image liberica11.tar Dockerfile.liberica11 abatalev/liberica:11-jre-alpine3.9-ttf bellsoft/liberica-openjre-alpine-musl:11.0.14.1-1

    test_image adoptopenjdk/openjdk11:jre-11.0.11_9-alpine
    test_image bellsoft/liberica-openjre-alpine-musl:11.0.15.1-2
    test_image abatalev/openjdk:11-jre-alpine3.9-ttf
    test_image abatalev/liberica:11-jre-alpine3.9-ttf
fi

echo "### Tests java 17"
echo " -- Latest GA release: 17.0.13 (17.0.13+7)"

../tools/smartdockerbuilder/sdb Dockerfile.liberica17l
build_image liberica17.tar Dockerfile.liberica17 abatalev/liberica:17.0.13-12-jre-alpine3.16-ttf bellsoft/liberica-openjre-alpine-musl:17.0.13-12
#build_image lrc17.tar Dockerfile.lrc17 abatalev/lrc:17.0.13-12-jre-alpine3.16-ttf bellsoft/liberica-runtime-container:jre-17.0.13-musl

test_image openjdk:17-ea-14-alpine3.14
test_image bellsoft/liberica-openjre-alpine-musl:17.0.13-12
test_image bellsoft/liberica-runtime-container:jre-17.0.13-musl
test_image abatalev/liberica:17.0.13-12-jre-alpine3.16-ttf
#test_image abatalev/lrc:17.0.13-12-jre-alpine3.16-ttf

echo "### Tests java 21"
echo " -- Latest GA release: 21.0.5 (21.0.5+11)"

../tools/smartdockerbuilder/sdb Dockerfile.liberica21
build_image liberica21.tar Dockerfile.liberica21 abatalev/liberica:21.0.5-11-jre-alpine3.18-ttf bellsoft/liberica-openjre-alpine-musl:21.0.5-11

test_image bellsoft/liberica-openjre-alpine-musl:21.0.5-11
test_image abatalev/liberica:21.0.5-11-jre-alpine3.18-ttf
