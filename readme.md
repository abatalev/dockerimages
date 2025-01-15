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
    ghcr.io/abatalev/pandoc-pdf:3.6.2 \
    md2pdf.sh readme.md readme.pdf
```

## TO DO

- Use axiom jdk?
- The list of installed software components and their licenses 
  can be retrieved by executing the apk list -I command in the 
  regular image, or grep -E '^[PVL]:' /var/lib/apk/db/installed in the slim image.

## Java Runtimes

- Bellsoft Libarica Alpine - ok
- Liberica-runtime-container (Alpaquita) - error (load packages permission denied)

## See also

- Java Runtimes 
  - alpaquita linux 
    - https://hub.docker.com/r/bellsoft/alpaquita-linux-base
    - https://github.com/bell-sw/Alpaquita/tree/master/docker/repos/alpaquita-linux-base

  - liberica-runtime-container 
    - https://hub.docker.com/r/bellsoft/liberica-runtime-container
    - https://github.com/bell-sw/Alpaquita/tree/master/docker/repos/liberica-runtime-container
    - https://www.baeldung.com/spring-docker-liberica

  - axiom jdk