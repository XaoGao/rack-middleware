FROM ruby:3.1.2-alpine

RUN apk update && apk add --virtual build-dependencies build-base libpq-dev

RUN mkdir -p /home/app
WORKDIR /home/app

COPY Gemfile /home/app/
COPY Gemfile.lock /home/app/

RUN gem install bundler -v 2.4.7

RUN bundle install

COPY . /home/app/

EXPOSE 9292

CMD ["rackup", "-p", "9292"]
