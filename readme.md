---
title: Docker Images
author: Andrey Batalev
---

# Docker Images

- for launch java applications
  - openjdk (ghcr.io/abatalev/openjdk)
  - liberica (ghcr.io/abatalev/liberica)

- for transforming markdown
  - pandoc (ghcr.io/abatalev/pandoc)
  - pandoc-pdf (ghcr.io/abatalev/pandoc-pdf)

## Example of Pandoc-pdf 

```sh
docker run --rm -v "$(pwd):/work" \
    -w /work \
    ghcr.io/abatalev/pandoc-pdf:3.5 \
    md2pdf.sh readme.md readme.pdf
```

## TO DO

- upgrade alpine to 3.21.2 
- upgrade texlive to 20240210.69778-r8
- upgrade pandoc to 3.6.2
- use https://hub.docker.com/r/bellsoft/liberica-runtime-container

## See also

- alpaquita linux 
  - https://hub.docker.com/r/bellsoft/alpaquita-linux-base
  - https://github.com/bell-sw/Alpaquita/tree/master/docker/repos/alpaquita-linux-base

- liberica-runtime-container 
  - https://hub.docker.com/r/bellsoft/liberica-runtime-container
  - https://github.com/bell-sw/Alpaquita/tree/master/docker/repos/liberica-runtime-container
  - https://www.baeldung.com/spring-docker-liberica

- axiom jdk