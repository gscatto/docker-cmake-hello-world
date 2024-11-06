FROM alpine AS build
RUN apk update && \
    apk add --no-cache \
        build-base=0.5-r3 \
        cmake=3.24.3-r0
COPY cmake-hello-world-example source
RUN cmake -S source -G Ninja && \
    cmake --build

FROM alpine
RUN apk update && \
    apk add --no-cache \
    libstdc++=12.2.1_git20220924-r4
RUN addgroup -S hello && adduser -S hello -G hello
USER hello
COPY --chown=shs:shs --from=build \
    build/clsqrt \
    app/clsqrt
ENTRYPOINT ["app/clsqrt"]