FROM ubuntu:24.04

RUN apt-get update -qq && \
    apt-get install -y -qq --no-install-recommends \
    bash curl git jq ca-certificates postgresql-client shellcheck && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt/agent-stack

COPY install.sh agent-stack ./
RUN chmod +x install.sh agent-stack

ENV AGENT_STACK_DIR=/opt/agent-stack
ENV PATH="/opt/agent-stack:${PATH}"

RUN bash install.sh || true

ENTRYPOINT ["agent-stack"]
CMD ["doctor"]
