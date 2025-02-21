
# build bl4st
FROM scratch AS bl4st
ARG HTMLPUBLIC
COPY submodules/bl4st/index.html $HTMLPUBLIC/bl4st/
COPY submodules/bl4st/bundle* $HTMLPUBLIC/bl4st/

#build hydra
FROM node:current AS hydra
COPY submodules/hydra /hydra
WORKDIR /hydra
RUN rm -rf dist
RUN npm install
# HACK: append the /hydra route to index.js so the pantheon-full image works
RUN echo "app.route('/hydra', mainView)" >> index.js
RUN npm run build

# build A Dark Room
FROM scratch AS adarkroom
ARG HTMLPUBLIC
COPY submodules/adarkroom/audio $HTMLPUBLIC/adarkroom/audio
COPY submodules/adarkroom/css $HTMLPUBLIC/adarkroom/css
COPY submodules/adarkroom/img $HTMLPUBLIC/adarkroom/img
COPY submodules/adarkroom/lang $HTMLPUBLIC/adarkroom/lang
COPY submodules/adarkroom/lib $HTMLPUBLIC/adarkroom/lib
COPY submodules/adarkroom/script $HTMLPUBLIC/adarkroom/script
COPY submodules/adarkroom/*.html $HTMLPUBLIC/adarkroom/
COPY submodules/adarkroom/*.ico $HTMLPUBLIC/adarkroom/

# build openscope
FROM node:current AS openscope
COPY submodules/openscope/ /openscope
WORKDIR /openscope
RUN npm install
RUN npm run build

#build it-tools standalone
FROM node:current AS it-tools
ENV NPM_CONFIG_LOGLEVEL=warn
ENV CI=true
ENV BASE_URL="/"
WORKDIR /app
COPY submodules/it-tools/package.json submodules/it-tools/pnpm-lock.yaml ./
RUN npm install -g pnpm && pnpm i --frozen-lockfile
COPY submodules/it-tools .
RUN pnpm build

#build it-tools for pantheon-full (needs base-url set)
FROM node:current AS it-tools-full
ENV NPM_CONFIG_LOGLEVEL=warn
ENV CI=true
ENV BASE_URL="/it-tools/"
WORKDIR /app
COPY submodules/it-tools/package.json submodules/it-tools/pnpm-lock.yaml ./
RUN npm install -g pnpm && pnpm i --frozen-lockfile
COPY submodules/it-tools .
RUN pnpm build

# build the pantheon-adarkroom image
FROM lscr.io/linuxserver/nginx AS pantheon-adarkroom
ARG HTMLPUBLIC
COPY --from=adarkroom $HTMLPUBLIC/adarkroom $HTMLPUBLIC

# build the pantheon-it-tools image
FROM lscr.io/linuxserver/nginx AS pantheon-it-tools
ARG HTMLPUBLIC
COPY --from=it-tools /app/dist $HTMLPUBLIC

# build the pantheon-hydra image
FROM lscr.io/linuxserver/nginx AS pantheon-openscope
ARG HTMLPUBLIC
COPY --from=openscope /openscope/public $HTMLPUBLIC

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
COPY src/index.html $HTMLPUBLIC/index.html
COPY --from=bl4st $HTMLPUBLIC/bl4st $HTMLPUBLIC/bl4st
COPY --from=hydra hydra/dist $HTMLPUBLIC/hydra
COPY --from=openscope /openscope/public $HTMLPUBLIC/openscope
COPY --from=it-tools-full /app/dist $HTMLPUBLIC/it-tools
COPY --from=adarkroom $HTMLPUBLIC/adarkroom $HTMLPUBLIC/adarkroom

