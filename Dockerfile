# ============================================
# Stage 1: Build
# ============================================
FROM hexpm/elixir:1.18.2-erlang-27.3.1-alpine-3.21.3 AS build

# Install build dependencies
RUN apk add --no-cache build-base git

WORKDIR /app

# Install hex and rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Copy dependency manifests
COPY mix.exs mix.lock* ./

# Install dependencies
RUN mix deps.get --only prod
RUN mix deps.compile

# Copy all application files
COPY . .

# Compile the application
RUN MIX_ENV=prod mix compile

# Build the release
RUN MIX_ENV=prod mix release

# ============================================
# Stage 2: Runtime
# ============================================
FROM alpine:3.21 AS app

# Install runtime dependencies (Erlang runtime, SQLite)
RUN apk add --no-cache ncurses-libs openssl libstdc++ sqlite

# Create a non-root user
RUN adduser -D appuser

WORKDIR /app

# Copy the release from the build stage
COPY --from=build /app/_build/prod/rel/prestamos ./

# Set ownership
RUN chown -R appuser:appuser /app
USER appuser

ENV HOME=/app
ENV DATABASE_PATH=/app/data/prestamos.db

# Create data directory for SQLite
RUN mkdir -p /app/data

EXPOSE 4000

# Start the application
CMD ["/app/bin/server"]
