FROM alpine/git AS downloader
RUN git clone --depth 1 https://github.com/CMHJ/cmake-hello-world-example.git /source

FROM alpine
RUN apk update && \
    apk add --no-cache \
        build-base \
        cmake \
        libstdc++
COPY --from=downloader /source source
RUN cmake -S source -B build && \
    cmake --build build && \
    cmake --install build
RUN addgroup -S clsqrt && adduser -S clsqrt -G clsqrt
USER clsqrt
ENTRYPOINT ["clsqrt"]