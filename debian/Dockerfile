FROM debian

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV SCHEDULE="" \
    SETUP="" \
    SCRIPT="" \
    TZ="UTC" \
    RUN="cron -f" \
    DEBIAN_FRONTEND=noninteractive
    
RUN apt -y update && \
    apt -y install procps cron && \
    rm -rf /var/lib/apt/lists/*

HEALTHCHECK CMD ps -ef | grep "cron -f" | grep -qv grep
ENTRYPOINT ["/entrypoint.sh"]