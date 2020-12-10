FROM alpine:latest as builder
LABEL stage=intermediate

ARG parigp_version="2.13.0"
ARG gp2c_version="0.0.12"
ARG parigp_packages="elldata galdata galpol nftables seadata"
ENV PARIGP_PREFIX=http://pari.math.u-bordeaux.fr/pub/pari/

RUN apk update &&\
    apk --no-cache add --virtual .helpers bash curl gnupg build-base perl diffutils

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
COPY ./dockerfile-commons/curl_and_gpgverify.sh ./dockerfile-commons/reduce_alpine.sh /tmp/
RUN cd /tmp &&\
    \
    # Download & verify the queried pari/gp with the packages and gp2c distributives.
    eval "echo unix/pari-$parigp_version.tar.gz\
               packages/{${parigp_packages// /,}}.tgz\
               GP2C/gp2c-$gp2c_version.tar.gz" | tr ' ' '\n' |\
    xargs -I@ sh /tmp/curl_and_gpgverify.sh -v $PARIGP_PREFIX/@.asc $PARIGP_PREFIX/@ || true &&\
    \
    # Unpack & install.
    ls *.*gz | xargs gunzip &&\
    ls *.tar | xargs -I@ tar xf @ &&\
    \
    ## PARI/GP.
    cd pari-$parigp_version/ && ./Configure && make -j gp && make dobench install &&\
    (mv /tmp/data /usr/local/share/pari/ || true) &&\
    \
    ## GP2C
    cd /tmp/gp2c-$gp2c_version/ && ./configure && make -j && make install &&\
    \
    # Reduce to the minimal size distribution.
    sh /tmp/reduce_alpine.sh -v /target gp gp2c /usr/local/lib/libpari.so\
                                        /usr/local/include/pari\
                                        /usr/local/share/{pari,gp2c} &&\
    \
    # Clean out.
    rm -rf /usr/local/share/pari/doc &&\
    cd /tmp && rm -rf /tmp/* &&\
    apk del .helpers


FROM scratch

ARG vcsref
LABEL \
    stage=production \
    org.label-schema.name="tiny-parigp" \
    org.label-schema.description="Minify your PARI/GP + GP2C." \
    org.label-schema.url="https://hub.docker.com/r/semenovp/tiny-parigp/" \
    org.label-schema.vcs-ref="$vcsref" \
    org.label-schema.vcs-url="https://github.com/piotr-semenov/parigp-docker.git" \
    maintainer='Piotr Semenov <piotr.k.semenov@gmail.com>'

COPY --from=builder /target /
