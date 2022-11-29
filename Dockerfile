# syntax=docker/dockerfile:1.3-labs
FROM ubuntu:kinetic as build

ENV DVISVGM="dvisvgm-3.0"

COPY ./${DVISVGM}.tar.gz /opt/${DVISVGM}.tar.gz
COPY ./textosvg /usr/local/bin/textosvg

CMD ["bash"]

# Install dependencies
RUN <<EOF
    apt-get update
    apt-get upgrade --yes
    apt-get install --yes --no-install-recommends \
        build-essential                           \
        libbrotli-dev                             \
        libfreetype-dev                           \
        libgs-dev                                 \
        libkpathsea-dev                           \
        libpotrace-dev                            \
        libssl-dev                                \
        libttfautohint-dev                        \
        libwoff-dev                               \
        libxxhash-dev                             \
        pkg-config                                \
        texlive                                   \
        texlive-fonts-extra                       \
        texlive-lang-european                     \
        texlive-latex-extra                       \
        texlive-luatex                            \
        texlive-pstricks                          \
        texlive-science                           \
        zlib1g-dev
    rm -rf /var/lib/apt/lists/*
EOF

# Install dvisvgm and textosvg script
RUN <<EOF
    mkdir /convert
    cd /opt
    tar -xzf ${DVISVGM}.tar.gz
    rm ${DVISVGM}.tar.gz
    cd ${DVISVGM}
    ./configure --with-ttfautohint=/usr/include
    make
    make install
    cd /usr/local/bin
    chmod +x textosvg
EOF

# Squash image
FROM scratch
COPY --from=build / /

WORKDIR /convert

CMD ["bash"]
