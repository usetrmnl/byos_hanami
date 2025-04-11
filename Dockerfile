# syntax = docker/dockerfile:1.4

ARG RUBY_VERSION=3.4.2

FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

WORKDIR /app

RUN <<STEPS
  apt-get update -qq \
  && apt-get install --no-install-recommends -y curl libjemalloc2 postgresql-client \
  && rm -rf /var/lib/apt/lists /var/cache/apt/archives
STEPS

ENV RACK_ENV=production
ENV HANAMI_ENV=production
ENV HANAMI_SERVE_ASSETS=true
ENV BUNDLE_DEPLOYMENT=1
ENV BUNDLE_PATH=/usr/local/bundle
ENV BUNDLE_WITHOUT="development:quality:test:tools"

FROM base AS build

RUN <<STEPS
  apt-get update -qq \
  && apt-get install --no-install-recommends -y build-essential \
  git \
  libpq-dev \
  libyaml-dev \
  nodejs \
  npm \
  pkg-config \
  postgresql-client \
  && rm -rf /var/lib/apt/lists /var/cache/apt/archives
STEPS

COPY .ruby-version Gemfile Gemfile.lock .node-version package.json package-lock.json ./

RUN <<STEPS
  bundle install
  npm install
  rm -rf "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git
STEPS

COPY . .
RUN bundle exec hanami assets compile
FROM base
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /app /app

RUN <<STEPS
  mkdir -p /app/log
  mkdir -p /app/tmp
STEPS

RUN groupadd --system --gid 1000 app && \
    useradd app --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R app:app log tmp

USER 1000:1000

ENTRYPOINT ["/app/bin/docker/entrypoint"]

EXPOSE 2300

CMD ["bundle", "exec", "puma", "--config", "./config/puma.rb"]
