# syntax=docker/dockerfile:1.3-labs
FROM ubuntu:kinetic
# Run with DOCKER_BUILDKIT=1

ENV DVISVGM="dvisvgm-3.0"

COPY ./${DVISVGM}.tar.gz /opt/${DVISVGM}.tar.gz

CMD ["bash"]

RUN <<EOF
    apt-get update
    apt-get upgrade --yes
    apt-get install --yes --no-install-recommends \
        build-essential \
        libboost-dev \
        libbrotli-dev \
        libclipper-dev \
        libfreetype-dev \
        libgs-dev \
        libkpathsea-dev \
        libpotrace-dev \
        libssl-dev \
        libttfautohint-dev \
        libwoff-dev \
        libxxhash-dev \
        pkg-config \
        texlive \
        texlive-fonts-extra \
        texlive-lang-european \
        texlive-latex-extra \
        texlive-luatex \
        texlive-pstricks \
        texlive-science \
        zlib1g-dev
EOF

RUN <<EOF
    cd /
    ls
    cd /opt
    ls
    tar -xzf ${DVISVGM}.tar.gz
    rm ${DVISVGM}.tar.gz
    cd ${DVISVGM}
    ./configure --with-ttfautohint=/usr/include
    make
    make install
EOF
