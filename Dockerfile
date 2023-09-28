FROM elixir:1.15.4-alpine

RUN apk add \
  ca-certificates \
  gcc \
  musl-dev \
  make

ENV RUSTUP_HOME=/usr/local/rustup \
  CARGO_HOME=/usr/local/cargo \
  PATH=/usr/local/cargo/bin:$PATH \
  RUST_VERSION=1.72.1 \
  RUSTFLAGS='--codegen target-feature=-crt-static' \
  MIX_ENV=prod

RUN set -eux; \
  apkArch="$(apk --print-arch)"; \
  case "$apkArch" in \
  x86_64) rustArch='x86_64-unknown-linux-musl'; rustupSha256='7aa9e2a380a9958fc1fc426a3323209b2c86181c6816640979580f62ff7d48d4' ;; \
  aarch64) rustArch='aarch64-unknown-linux-musl'; rustupSha256='b1962dfc18e1fd47d01341e6897cace67cddfabf547ef394e8883939bd6e002e' ;; \
  *) echo >&2 "unsupported architecture: $apkArch"; exit 1 ;; \
  esac; \
  url="https://static.rust-lang.org/rustup/archive/1.26.0/${rustArch}/rustup-init"; \
  wget "$url"; \
  echo "${rustupSha256} *rustup-init" | sha256sum -c -; \
  chmod +x rustup-init; \
  ./rustup-init -y --no-modify-path --profile minimal --default-toolchain $RUST_VERSION --default-host ${rustArch}; \
  rm rustup-init; \
  chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
  rustup --version; \
  cargo --version; \
  rustc --version;

RUN ["mix", "local.hex", "--force"]



WORKDIR /workspace
COPY mix.exs .
COPY mix.lock .

RUN ["mix", "deps.get"]
RUN ["mix", "deps.compile"]

COPY . .

RUN ["rm", "-rf", "_build"]

RUN ["mix", "compile"]
RUN ["mix", "release"]

ENTRYPOINT [ "_build/prod/rel/bakeware/rinha" ]