FROM alpine AS build
RUN apk update && \
    apk add --no-cache \
        build-base \
        cmake \
        libstdc++
COPY cmake-hello-world-example source
RUN cmake -S source -B build && \
    cmake --build build && \
    cmake --install build
RUN addgroup -S hello && adduser -S clsqrt -G clsqrt
USER clsqrt
ENTRYPOINT ["clsqrt"]