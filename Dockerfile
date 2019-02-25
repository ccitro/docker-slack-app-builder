FROM mhart/alpine-node:base-10 as builder

RUN apk --no-cache add curl && \
    curl -sfSL -O https://yarnpkg.com/latest.tar.gz && \
    mkdir /usr/local/share/yarn && \
    tar -xf latest.tar.gz -C /usr/local/share/yarn --strip 1;

FROM mhart/alpine-node:base-10
COPY --from=builder /usr/local/share/yarn /usr/local/share/yarn
ADD src /docker-slack-app-builder

# setup yarn from builder in path 
RUN ln -s /usr/local/share/yarn/bin/yarn /usr/local/bin/ && \
    ln -s /usr/local/share/yarn/bin/yarnpkg /usr/local/bin/
