FROM ubuntu:22.10
LABEL org.opencontainers.image.source https://github.com/drsnowdude/silver-waffle

USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    git-lfs \
    unzip \
    wget \
    zip \
    && rm -rf /var/lib/apt/lists/*

ARG GODOT_VERSION="4.0"
ARG RELEASE_NAME="beta10"

RUN wget https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/${RELEASE_NAME}/Godot_v${GODOT_VERSION}-${RELEASE_NAME}_linux.x86_64.zip \
    && wget https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/${RELEASE_NAME}/Godot_v${GODOT_VERSION}-${RELEASE_NAME}_export_templates.tpz \
    && mkdir ~/.cache \
    && mkdir -p ~/.config/godot \
    && mkdir -p ~/.local/share/godot/templates/${GODOT_VERSION}.${RELEASE_NAME} \
    && unzip Godot_v${GODOT_VERSION}-${RELEASE_NAME}_linux.x86_64.zip \
    && mv Godot_v${GODOT_VERSION}-${RELEASE_NAME}_linux.x86_64 /usr/local/bin/godot \
    && unzip Godot_v${GODOT_VERSION}-${RELEASE_NAME}_export_templates.tpz \
    && mv templates/* ~/.local/share/godot/templates/${GODOT_VERSION}.${RELEASE_NAME} \
    && rm -f Godot_v${GODOT_VERSION}-${RELEASE_NAME}_export_templates.tpz Godot_v${GODOT_VERSION}-${RELEASE_NAME}_linux.x86_64.zip

RUN mkdir -p /opt/butler/bin \
    && cd /opt/butler/bin \
    && wget -O butler.zip https://broth.itch.ovh/butler/linux-amd64/LATEST/archive/default \
    && unzip butler.zip \
    && chmod +x butler \
    && export PATH=/opt/butler/bin/:$PATH

ENV PATH="/opt/butler/bin:${PATH}"

#Editor config settings
RUN godot -e -q --headless --display-driver headless --version