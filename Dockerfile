
# build bl4st
FROM scratch AS bl4st
ARG HTMLPUBLIC
COPY submodules/bl4st/index.html $HTMLPUBLIC/bl4st/
COPY submodules/bl4st/bundle* $HTMLPUBLIC/bl4st/

#build hydra
FROM node:current AS hydra
ARG HTMLPUBLIC
COPY submodules/hydra /hydra
WORKDIR /hydra
RUN rm -rf dist
RUN npm install
# HACK: append the /hydra route to index.js so the pantheon-full image works
RUN echo "app.route('/hydra', mainView)" >> index.js
RUN npm run build

# build the pantheon-hydra image
FROM lscr.io/linuxserver/nginx AS pantheon-hydra
ARG HTMLPUBLIC
COPY --from=hydra /hydra/dist $HTMLPUBLIC

# build the pantheon-bl4st image
FROM lscr.io/linuxserver/nginx AS pantheon-bl4st
ARG HTMLPUBLIC
COPY --from=bl4st $HTMLPUBLIC/bl4st $HTMLPUBLIC

# build the pantheon image
FROM lscr.io/linuxserver/nginx AS pantheon-full
ARG HTMLPUBLIC
COPY --from=bl4st $HTMLPUBLIC/bl4st $HTMLPUBLIC/bl4st
COPY --from=hydra hydra/dist $HTMLPUBLIC/hydra

