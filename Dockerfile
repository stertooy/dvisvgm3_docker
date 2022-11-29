# syntax=docker/dockerfile:1.3-labs
FROM ubuntu:kinetic
# Run with DOCKER_BUILDKIT=1

ENV DVISVGM="dvisvgm-3.0"

COPY ./${DVISVGM}.tar.gz /opt/${DVISVGM}.tar.gz
COPY ./textosvg /usr/local/bin/textosvg

CMD ["bash"]

RUN <<EOF
    apt-get update
    apt-get upgrade --yes
    apt-get install --yes --no-install-recommends \
        build-essential \
        libbrotli-dev \
        libfreetype-dev \
        libgs-dev \
        libkpathsea-dev \
        libpotrace-dev \
        libssl-dev \
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
    rm -rf /var/lib/apt/lists/*
EOF
# libttfautohint-dev - removed because results are worse

RUN <<EOF
    cd /opt
    tar -xzf ${DVISVGM}.tar.gz
    rm ${DVISVGM}.tar.gz
    cd ${DVISVGM}
    ./configure
    make
    make install
EOF
# --with-ttfautohint=/usr/include - removed because results are worse

RUN <<EOF
    cd /usr/local/bin
    chmod +x textosvg
EOF
