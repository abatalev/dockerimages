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
    ghcr.io/abatalev/pandoc-pdf:2.17.1.1 \
    md2pdf.sh readme.md readme.pdf
```

