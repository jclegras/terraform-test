FROM golang:alpine AS builder
RUN apk update && apk add --no-cache git
WORKDIR $GOPATH/src/github.com/jclegras/hello-world/
COPY . .
RUN go get -d -v
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /go/bin/hello-world .


FROM alpine:latest  
EXPOSE 8080
WORKDIR /root/
COPY --from=builder /go/bin/hello-world ./app
CMD ["./app"]  
