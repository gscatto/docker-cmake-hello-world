FROM alpine AS build
RUN apk update && \
    apk add --no-cache \
        build-base \
        cmake
COPY cmake-hello-world-example source
RUN cmake -S source -G Ninja && \
    cmake --build

FROM alpine
RUN apk update && \
    apk add --no-cache \
    libstdc++
RUN addgroup -S hello && adduser -S hello -G hello
USER hello
COPY --chown=shs:shs --from=build \
    build/clsqrt \
    app/clsqrt
ENTRYPOINT ["app/clsqrt"]