FROM node:lts-alpine

RUN apk add --update --no-cache \
  dumb-init \
  git \
  jq
WORKDIR "/home/node"
ARG WIKI_PACKAGE=wiki@0.28.0
RUN su node -c "npm install -g --prefix . $WIKI_PACKAGE"
RUN su node -c "cd lib/node_modules/wiki/node_modules && rm -r wiki-security-passportjs && git clone https://github.com/3-w-c/wiki-security-passportjs"
RUN su node -c "cd lib/node_modules/wiki/node_modules/wiki-security-passportjs && npm install && node_modules/grunt/bin/grunt"
RUN su node -c "mkdir -p .wiki"
VOLUME "/home/node/.wiki"
EXPOSE 3000
USER node
ENV PATH="${PATH}:/home/node/bin"
ENV NPM_CONFIG_PREFIX="${HOME}"
ENTRYPOINT ["dumb-init"]
CMD ["wiki", "--farm"]
