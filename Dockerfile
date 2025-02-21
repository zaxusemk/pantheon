# set up some useful args
# ARG HTMLPUBLIC="/usr/share/nginx/html"

# build bl4st
FROM scratch AS bl4st
ARG HTMLPUBLIC
#RUN mkdir -p $HTMLPUBLIC/bl4st
#WORKDIR $HTMLPUBLIC/bl4st
COPY bl4st/index.html $HTMLPUBLIC/bl4st/
COPY bl4st/bundle* $HTMLPUBLIC/bl4st/

# build the pantheon-bl4st image
FROM lscr.io/linuxserver/nginx AS pantheon-bl4st
ARG HTMLPUBLIC
COPY --from=bl4st $HTMLPUBLIC/bl4st $HTMLPUBLIC

# build the pantheon image
FROM lscr.io/linuxserver/nginx AS pantheon-full
ARG HTMLPUBLIC
COPY --from=bl4st $HTMLPUBLIC/bl4st $HTMLPUBLIC/bl4st


