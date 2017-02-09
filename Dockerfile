FROM node:7.4-alpine

#ENV HOUND_GIT=https://github.com/houndci/hound.git
ENV NODE_ENV=production \
    RACK_ENV=production \
    RAILS_ENV=production \
    REDIS_URL=redis://redis:6379 \
    CHANGED_FILES_THRESHOLD=300 \
    DB_POOL=5 \
    DB_REAPING_FREQUENCY=10 \
    ENABLE_HTTPS=mp \
    MAX_COMMENTS=10 \
    MAX_THREADS=5 \
    RACK_TIMEOUT=20 \
    RESQUE_JOB_TIMEOUT=120 \
    STRIPE_API_KEY=false \
    STRIPE_PUBLISHABLE_KEY=false \
    SENTRY_DSN=false \
    SEGMENT_KEY=false \
    INTERCOM_API_SECRET=false \
    DATABASE_URL='postgres://username:password@host/dn_name' \
    GITHUB_CLIENT_ID=changeme \
    GITHUB_CLIENT_SECRET=changeme \
    ADMIN_GITHUB_USERNAMES=changeme \
    HOUND_GITHUB_URL=https://github.my_domain.com \
    HOUND_GITHUB_TOKEN=changeme \
    HOUND_GITHUB_USERNAME=changeme \
    HOST=https://hound.my_domain.com \
    RESQUE_ADMIN_PASSWORD=changeme \
    SECRET_KEY_BASE=changeme_to_something_long_and_secret \
    SPLIT_ADMIN_PASSWORD=changeme

COPY . /hound

RUN apk add --update --virtual build-deps \
           build-base \
           ruby-dev \
      && apk add \
           ca-certificates \
           ruby \
           git \
           postgresql-dev \
           ruby-irb \
           su-exec \
           #      && git clone --depth 1 ${HOUND_GIT} hound \
      && cd hound \
      && echo 'gem: --no-document' >> ~/.gemrc \
      && echo "gem 'bigdecimal'" >> Gemfile \
      && echo "gem 'tzinfo-data'" >> Gemfile \
      && gem install --no-document \
           bundler \
           io-console \
      && bundle install --no-cache --without test \
      && npm install --production \
      && npm run build \
      && apk del build-deps \
      && rm .env \
      && rm -rf /var/cache/apk/* \
      && adduser -S -D -H hound

WORKDIR /hound

ENTRYPOINT ["su-exec", "hound"]
CMD ["foreman", "start"]
