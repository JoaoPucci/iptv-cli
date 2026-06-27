# AGENTS.md

Guidance for AI agents (and humans) working in this repository.

## What this is

`iptv-cli` is a small terminal launcher for [iptv-org](https://github.com/iptv-org/iptv)
playlists: an `fzf` drill-down selector (country / category / language → channel) that
plays the chosen stream in `mpv`. Playlists are fetched live from iptv-org, so there is
no bundled channel data.

**Scope guardrails (important):**
- This is a **player**, not a content provider. Do **not** bundle, host, scrape, or ship
  stream URLs, channel IDs, or playlists. It only points a player at the public playlists
  iptv-org already publishes.
- Keep it tiny and dependency-light. The whole program is intentionally one Bash script.

## Layout

```
src/iptv-cli               # the entire program (one Bash script)
packaging/control          # Debian control file (Depends + metadata); has @VERSION@ placeholder
packaging/iptv-cli.desktop # app-menu launcher
Makefile                   # build / install / uninstall / clean
VERSION                    # single source of truth for the version string
README.md  LICENSE
docs/                      # local notes — git-ignored, not shipped
```

## Build & test

- Syntax check:     `bash -n src/iptv-cli`
- Lint (if present): `shellcheck src/iptv-cli`
- Run from source:  `./src/iptv-cli --help`  (reports version `dev` when unbuilt)
- Build the .deb:   `make deb`  → `dist/iptv-cli_<VERSION>_all.deb`
- Install locally:  `make install`  (wraps `sudo apt install ./dist/...`)
- Clean:            `make clean`

There is no automated/network test harness — verify interactively by running
`./src/iptv-cli`, plus `bash -n` (and `shellcheck` when available).

## Conventions

- **Language:** Bash (`#!/usr/bin/env bash`; uses `[[ ]]`, `local`, `set -o pipefail`).
- **Runtime deps:** `curl fzf mpv jq` — declared in `packaging/control`. Adding a new
  runtime dependency means updating that `Depends:` line as well.
- **Versioning:** bump the single line in `VERSION`. The build substitutes `@VERSION@`
  into both the installed script (so `--version` is right) and the control file. Do not
  hardcode a version anywhere else.
- **Packaging:** `Architecture: all`; the deb is built with `dpkg-deb --root-owner-group`
  (no `fakeroot` needed).
- Keep `--help` output and `README.md` in sync when flags or behavior change.

## Release checklist

1. Edit `src/iptv-cli`; run `bash -n` (+ `shellcheck`).
2. Update `VERSION`; describe changes in the commit message.
3. `make deb`; smoke-test the built binary's `--version`.
4. Commit **source only**.

## Never commit

`build/`, `dist/`, `*.deb` (build artifacts) and local notes (`*.local.md`) are git-ignored
on purpose. Don't add them back.
