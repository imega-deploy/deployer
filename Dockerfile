FROM openresty/openresty:alpine

EXPOSE 80

RUN apk add --no-cache make curl docker && mkdir -p /app/logs

COPY src/ /app
COPY nginx.conf /nginx.conf

CMD ["openresty", "-g", "daemon off;", "-p", "/app", "-c", "/nginx.conf"]
