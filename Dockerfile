FROM golang:alpine as builder
WORKDIR /build
COPY [ ".", "." ]
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags '-extldflags "-static"' -o ./bin/gen main.go

FROM alpine:3.12 as release

LABEL maintainer="Lucca Pessoa da Silva Matos - luccapsm@gmail.com" \
      org.label-schema.cli="gen" \
      org.label-schema.language="GoLang" \
      org.label-schema.url="https://github.com/lpmatos/gen" \
      org.label-schema.repo="https://github.com/lpmatos/gen.git" \
      org.label-schema.name="Gen is a GoLang CLI that automate your project startup"

COPY --from=builder [ "/build/bin/gen", "/usr/local/bin/gen" ]
RUN chmod +x /usr/local/bin/gen
RUN apk --no-cache add ca-certificates=20191127-r4 shadow=4.8.1-r0 git=2.26.2-r0 bash=5.0.17-r0
RUN addgroup -S docker && adduser -S -G docker gen && usermod -aG root gen
USER gen
CMD ["gen"]
