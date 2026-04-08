FROM golang:1.24-alpine AS builder
WORKDIR /workspace

COPY . .
RUN go get
RUN go build -ldflags "-s -w -X main.version=v1.0.7-warp" -o /workspace/sniproxy


FROM alpine:3.18 AS release

WORKDIR /sniproxy

RUN mkdir -p /sniproxy/conf

# Copy from builder
COPY --from=builder /workspace/sniproxy ./sniproxy

RUN chmod +x sniproxy
COPY config.yaml ./conf

EXPOSE 443

CMD ["./sniproxy","-c","./conf/config.yaml"]