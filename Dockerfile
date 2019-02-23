FROM node:10-alpine

ADD . /docker-slack-app-builder
RUN cd /docker-slack-app-builder && yarn
RUN rm -rf node_modules
RUN yarn
