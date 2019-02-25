FROM mhart/alpine-node:base-10 as builder

RUN apk --no-cache add curl && \
    curl -sfSL -O https://yarnpkg.com/latest.tar.gz && \
    mkdir /usr/local/share/yarn && \
    tar -xf latest.tar.gz -C /usr/local/share/yarn --strip 1;

FROM mhart/alpine-node:base-10
COPY --from=builder /usr/local/share/yarn /usr/local/share/yarn
ADD src /docker-slack-app-builder


RUN \
    # install deps
    apk --no-cache add bash git openssh-client && \
    \
    # setup yarn from builder in path 
    ln -s /usr/local/share/yarn/bin/yarn /usr/local/bin/ && \
    ln -s /usr/local/share/yarn/bin/yarnpkg /usr/local/bin/ && \
    \
    # set up yarn cache dir so we can clear it out.  then yarn install
    yarn config set cache-folder /builder/yarn-cache && \
    cd /docker-slack-app-builder && \
    yarn install --production=false --ignore-optional && \
    \
    # copy node_modules to a builder directory for future builds, cleanup
    mv /docker-slack-app-builder/node_modules /builder/node_modules && \
    rm -rf /docker-slack-app-builder && \
    rm -rf /builder/yarn-cache
