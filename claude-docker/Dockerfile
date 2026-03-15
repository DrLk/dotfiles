FROM archlinux:latest

RUN pacman -Syu --noconfirm \
    git \
    ca-certificates \
    curl \
    nodejs \
    npm \
    docker \
 && pacman -Scc --noconfirm

RUN npm install -g @anthropic-ai/claude-code

RUN git config --system --add safe.directory /workspace

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /workspace

ENTRYPOINT ["/entrypoint.sh"]
CMD ["claude"]
