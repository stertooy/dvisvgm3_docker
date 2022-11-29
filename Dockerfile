# syntax=docker/dockerfile:1.3-labs
FROM ubuntu:kinetic as build

ENV DVISVGM="dvisvgm-3.0"

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

# Install dvisvgm
ADD ./${DVISVGM}.tar.gz /opt

RUN <<EOF
    cd /opt/${DVISVGM}
    ./configure --with-ttfautohint=/usr/include
    make
EOF

# Install textosvg
COPY ./textosvg.sh /opt/textosvg.sh

# Make convert directory
RUN mkdir /convert

# Squash image
FROM scratch
COPY --from=build / /

WORKDIR /convert

ENTRYPOINT ["/bin/sh", "-c", "/opt/textosvg.sh"]
CMD ["*.tex"]
