# develop container
FROM node:20 AS develop

# build container
FROM node:20 AS build
USER node

COPY --chown=node:node . /app

WORKDIR /app

RUN yarn install --network-timeout 1000000
RUN yarn gulp release --baseHref="/terriamap/"

# deploy container
FROM httpd:alpine AS deploy

WORKDIR /usr/local/apache2/htdocs

# Without the chown when copying directories, wwwroot is owned by root:root.
COPY --from=build --chown=node:node /app/wwwroot ./

EXPOSE 80
