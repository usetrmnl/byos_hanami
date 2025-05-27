# syntax = docker/dockerfile:1.4

ARG RUBY_VERSION=3.4.4

FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

ENV BUNDLE_PATH=/usr/local/bundle
WORKDIR /app

# Combined repository setup and package installation
RUN <<STEPS
  apt-get update -qq
  apt-get install -y --no-install-recommends curl ca-certificates gnupg2 lsb-release
  # Setup PostgreSQL repository
  curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /usr/share/keyrings/postgresql-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/postgresql-keyring.gpg] https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list
  # Setup Node.js repository and install runtime dependencies
  curl -fsSL https://deb.nodesource.com/setup_23.x | bash -
  apt-get update -qq
  apt-get install -y --no-install-recommends \
      chromium \
      imagemagick \
      libjemalloc2 \
      tmux \
      postgresql-client-17 \
      nodejs
  rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*
STEPS

# Build stage for installing dependencies
FROM base AS build

# Install build dependencies
RUN <<STEPS
  apt-get update -qq
  apt-get install -y --no-install-recommends \
      build-essential \
      libpq-dev \
      libyaml-dev \
      pkg-config
  rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*
STEPS

# Copy dependency files
COPY .ruby-version Gemfile Gemfile.lock .node-version package.json package-lock.json ./

# Install all dependencies
RUN <<STEPS
  bundle install
  npm install
  rm -rf "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git
STEPS

# Development stage
FROM base AS development

ENV RACK_ENV=development
ENV HANAMI_ENV=development
ENV HANAMI_SERVE_ASSETS=true

# Copy installed dependencies from build stage
COPY --from=build ${BUNDLE_PATH} ${BUNDLE_PATH}

# Create necessary directories
RUN <<STEPS
  mkdir -p /app/log
  mkdir -p /app/tmp
STEPS

# Production stage
FROM base AS production

ENV RACK_ENV=production
ENV HANAMI_ENV=production
ENV HANAMI_SERVE_ASSETS=true
ENV BUNDLE_DEPLOYMENT=1
ENV BUNDLE_WITHOUT="development:quality:test:tools"

# Copy installed dependencies and application files
COPY --from=build ${BUNDLE_PATH} ${BUNDLE_PATH}
COPY --from=build /app/node_modules /app/node_modules
COPY . .

# Create directories and setup permissions
RUN <<STEPS
  mkdir -p /app/log
  mkdir -p /app/tmp
  groupadd --system --gid 1000 app
  useradd app --uid 1000 --gid 1000 --create-home --shell /bin/bash
  chown -R app:app . public log tmp
STEPS

USER 1000:1000

ENTRYPOINT ["/app/bin/docker/entrypoint"]
EXPOSE 2300
CMD ["bundle", "exec", "overmind", "start", "--port-step", "10", "--can-die", "migrate,assets"]