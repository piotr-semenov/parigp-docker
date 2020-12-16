[![PARI/GP:2.13.0](https://img.shields.io/badge/PariGP-2.13.0-green.svg)](https://pari.math.u-bordeaux.fr/)
[![](https://img.shields.io/docker/image-size/semenovp/tiny-parigp/latest)](https://hub.docker.com/r/semenovp/tiny-parigp/)
[![](https://img.shields.io/microbadger/layers/semenovp/tiny-parigp/latest)](https://microbadger.com/images/semenovp/tiny-parigp/)
[![Docker Pull](https://img.shields.io/docker/pulls/semenovp/tiny-parigp.svg)](https://hub.docker.com/r/semenovp/tiny-parigp/)

# How to use PARI/GP and GP2C from this Docker image?
Just use the following aliases to modify your .bashrc (or .bash_profile if OSX):
```bash
DOCKER_RUN='docker run --rm -v `pwd`:/workdir -w /workdir'

alias gp="$DOCKER_RUN -it semenovp/tiny-parigp:latest gp"
alias gp2c="$DOCKER_RUN semenovp/tiny-parigp:gp2c-latest gp2c"
alias gp2c_run="$DOCKER_RUN --entrypoint '' -it semenovp/tiny-parigp:gp2c-latest gp2c-run"
```

# List of competing Docker images
Review the sizes of competitor images retrieved from [DockerHub](https://hub.docker.com) against current one built on PARI/GP v2.13.0.

| REPOSITORY | YYYY-MM-DD | COMPRESSED / UNCOMPRESSED SIZE |
|:-----------|:----------:|:------------------------------:|
| **[semenovp/tiny-parigp:latest](https://hub.docker.com/r/semenovp/tiny-parigp/)** | 2020-12-16 | **7.82MB / 19.3MB** |
| [pascalmolin/parigp-small:latest](https://hub.docker.com/r/pascalmolin/parigp-small) | 2020-07-08 | 78.11MB / 231MB |
| **[semenovp/tiny-parigp:latest-alldata](https://hub.docker.com/r/semenovp/tiny-parigp/)** | 2020-12-16 | **96.13MB / 288MB** |
| [pascalmolin/parigp-full:latest](https://hub.docker.com/r/pascalmolin/parigp-full) | 2020-07-08 | 158.53MB / 464MB |
| **[semenovp/tiny-parigp:gp2c-latest](https://hub.docker.com/r/semenovp/tiny-parigp/)** | 2020-12-16 | **28.13MB / 79.9MB** |
