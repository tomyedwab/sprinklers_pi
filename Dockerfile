FROM raspbian/stretch AS build

RUN apt-get update
RUN apt-get install -y \
  make g++ build-essential libsqlite3-dev wiringpi

ADD . /src/
WORKDIR /src
RUN make all

RUN ls -l /src/

FROM raspbian/stretch

COPY --from=build /usr/lib/libwiringPi* /usr/lib/
COPY --from=build /src/sprinklers_pi /bin/sprinklers_pi
COPY --from=build /src/web /web

RUN mkdir -p /usr/local/etc/sprinklers_pi
WORKDIR /usr/local/etc/sprinklers_pi

ENTRYPOINT ["/bin/sprinklers_pi"]
