FROM alpine

RUN apk add --update bash tzdata && \
    rm -rf /var/cache/apk/*

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV SCHEDULE="" \
    SETUP="" \
    SCRIPT="" \
    TZ="UTC" \
    RUN="crond -f"

HEALTHCHECK CMD ps | grep "crond -f" | grep -qv grep
ENTRYPOINT ["/entrypoint.sh"]