FROM elixir:1.11

ENV NODE_VERSION 14.x

RUN curl -sL https://deb.nodesource.com/setup_${NODE_VERSION} | bash \
  && apt-get install -y nodejs

RUN npm install npm@latest -g

RUN mix local.hex --force && \
  mix archive.install hex phx_new 1.5.7 --force && \
  mix local.rebar --force

WORKDIR /app
