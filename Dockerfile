FROM litestream/litestream:pr-349 AS litestream

# Use the Go image to build our application.
FROM debian:stable-slim

# Some utils for local dev
RUN apt update && apt install -y procps sqlite3 

# Copy the present working directory to our source directory in Docker.
# Change the current directory in Docker to our source directory.
COPY litestream /litestream
WORKDIR /litestream
# Download the static build of Litestream directly into the path & make it executable.
# This is done in the builder and copied as the chmod doubles the size.
# ADD https://github.com/benbjohnson/litestream/releases/download/v0.3.8/litestream-v0.3.8-linux-amd64-static.tar.gz /tmp/litestream.tar.gz
# RUN mkdir -p /litestream/bin && tar -C /litestream/bin -xzf /tmp/litestream.tar.gz

COPY --from=litestream /usr/local/bin/litestream /litestream/bin/litestream

# Create data directory (although this will likely be mounted too)
RUN mkdir -p /data

ENV DATABASE_URL=file:/data/sqlite.db

EXPOSE 9090
CMD [ "/litestream/start.sh" ]

