FROM mcr.microsoft.com/dotnet/sdk:6.0-alpine as builder

RUN apk add --no-cache python3 py3-pip
RUN ln -s /usr/bin/python3 /usr/bin/python

COPY src ./src
COPY restler ./restler
COPY build-restler.py .


RUN python3 build-restler.py --dest_dir /build

RUN python3 -m compileall -b /build/engine

FROM mcr.microsoft.com/dotnet/aspnet:6.0-alpine as target

RUN apk add --no-cache python3 py3-pip
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN pip3 install requests applicationinsights

COPY --from=builder /build /RESTler
COPY config.json ./RESTler/restler
COPY api_specs ./RESTler/api_specs  
COPY auth ./RESTler/auth

WORKDIR /RESTler
RUN restler/Restler compile --api_spec api_specs/point-simplecis.yml

RUN restler/Restler test --grammar_file Compile/grammar.py \
--dictionary_file Compile/dict.json --token_refresh_interval 500 \
--token_refresh_command "../auth/token_fetcher/target/x86_64-unknown-linux-musl/release/token_fetcher"
