FROM node:18.15.0-alpine3.16 AS prodinstall
WORKDIR /usr/src/app
COPY . /usr/src/app

RUN npm install --production

FROM node:18.15.0-alpine3.16@sha256:bd24b8ec63135d7e27be32bbd621f425b04bacccca2344858a257d2c9ce87813
RUN apk add dumb-init
ENV NODE_ENV production
USER node
WORKDIR /usr/src/app
COPY --chown=node:node --from=prodinstall /usr/src/app/node_modules /usr/src/app/node_modules
COPY --chown=node:node --from=prodinstall /usr/src/app/package*.json /usr/src/app/
COPY --chown=node:node --from=prodinstall /usr/src/app/src /usr/src/app/src
CMD ["dumb-init", "node", "/usr/src/app/src/app.js"]