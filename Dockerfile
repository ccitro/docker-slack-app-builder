FROM node:10-alpine

RUN apk --no-cache add python g++ make bash git openssh-client

# install skeleton app to build node_modules and yarn cache
ADD src /docker-slack-app-builder
RUN yarn config set cache-folder /builder/yarn-cache && \
    cd /docker-slack-app-builder && \
    yarn install --production=false

# copy node_modules to a builder directory for future builds, remove skeleton app
RUN mv /docker-slack-app-builder/node_modules /builder/node_modules && \
    rm -rf /docker-slack-app-builder
