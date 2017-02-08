FROM node:7.4-alpine

#ENV HOUND_GIT=https://github.com/houndci/hound.git
ENV NODE_ENV=production
ENV RACK_ENV=production
ENV RAILS_ENV=production

ENV REDIS_URL=redis://redis:6379
ENV CHANGED_FILES_THRESHOLD=300
ENV DB_POOL=5
ENV DB_REAPING_FREQUENCY=10
ENV ENABLE_HTTPS=mp
ENV MAX_COMMENTS=10
ENV MAX_THREADS=5
ENV RACK_TIMEOUT=20
ENV RESQUE_JOB_TIMEOUT=120
ENV STRIPE_API_KEY=false
ENV STRIPE_PUBLISHABLE_KEY=false
ENV SENTRY_DSN=false
ENV SEGMENT_KEY=false
ENV INTERCOM_API_SECRET=false

ENV DATABASE_URL='postgres://username:password@host/dn_name'
ENV GITHUB_CLIENT_ID=changeme
ENV GITHUB_CLIENT_SECRET=changeme
ENV ADMIN_GITHUB_USERNAMES=changeme
ENV HOUND_GITHUB_URL=https://github.my_domain.com
ENV HOUND_GITHUB_TOKEN=changeme
ENV HOUND_GITHUB_USERNAME=changeme
ENV HOST=https://hound.my_domain.com
ENV RESQUE_ADMIN_PASSWORD=changeme
ENV SECRET_KEY_BASE=changeme_to_something_long_and_secret
ENV SPLIT_ADMIN_PASSWORD=changeme

COPY . /hound

RUN apk add --update --virtual build-deps \
        ca-certificates \
        build-base \
        ruby-dev \
      && apk add \
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
      && rm -rf /var/cache/apk/*

WORKDIR /hound
