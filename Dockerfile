FROM elixir:1.15.4

RUN apt-get update && apt-get install -y \
  ca-certificates \
  gcc \
  musl-dev

ENV RUSTUP_HOME=/usr/local/rustup \
  CARGO_HOME=/usr/local/cargo \
  PATH=/usr/local/cargo/bin:$PATH \
  RUST_VERSION=1.72.1 \
  RUSTFLAGS='--codegen target-feature=-crt-static'

RUN set -eux; \
  dpkgArch="$(dpkg --print-architecture)"; \
  case "${dpkgArch##*-}" in \
  amd64) rustArch='x86_64-unknown-linux-gnu'; rustupSha256='0b2f6c8f85a3d02fde2efc0ced4657869d73fccfce59defb4e8d29233116e6db' ;; \
  armhf) rustArch='armv7-unknown-linux-gnueabihf'; rustupSha256='f21c44b01678c645d8fbba1e55e4180a01ac5af2d38bcbd14aa665e0d96ed69a' ;; \
  arm64) rustArch='aarch64-unknown-linux-gnu'; rustupSha256='673e336c81c65e6b16dcdede33f4cc9ed0f08bde1dbe7a935f113605292dc800' ;; \
  i386) rustArch='i686-unknown-linux-gnu'; rustupSha256='e7b0f47557c1afcd86939b118cbcf7fb95a5d1d917bdd355157b63ca00fc4333' ;; \
  *) echo >&2 "unsupported architecture: ${dpkgArch}"; exit 1 ;; \
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

RUN ["mix", "compile"]

CMD ["mix", "run", "-e", "\"RinhaCompiler.eval(\\\"files/fib.rinha\\\")\""]