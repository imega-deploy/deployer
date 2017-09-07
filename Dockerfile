FROM alpine:3.4

EXPOSE 80

RUN apk add --no-cache nginx-lua lua5.1-curl lua5.1-cjson && \
    mkdir -p /tmp/nginx/client-body

COPY src/ /app
COPY nginx.conf /nginx.conf

CMD ["/usr/sbin/nginx", "-g", "daemon off;", "-p", "/app", "-c", "/nginx.conf"]