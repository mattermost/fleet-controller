
FROM golang:1.15.7-alpine AS builder

RUN apk add --update --no-cache ca-certificates bash make gcc musl-dev git openssh wget curl

WORKDIR /go/src/fleet-controller

COPY go.mod .
COPY go.sum .
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 make build

#####

FROM alpine

COPY --from=builder /go/src/fleet-controller/fleet-controller /fleet-controller

ENTRYPOINT [ "/fleet-controller" ]
