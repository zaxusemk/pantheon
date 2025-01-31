FROM nginx:latest
WORKDIR /usr/share/nginx/html

COPY bl4st/index.html .
COPY bl4st/bundle* .
