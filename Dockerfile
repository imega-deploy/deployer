FROM openresty/openresty:alpine

EXPOSE 80

RUN echo "@community http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
	apk add --no-cache git make curl docker@community && mkdir -p /app/logs

COPY src/ /app
COPY nginx.conf /nginx.conf

CMD ["openresty", "-g", "daemon off;", "-p", "/app", "-c", "/nginx.conf"]
