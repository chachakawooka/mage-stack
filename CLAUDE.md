# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A Docker-based Magento 2 development stack used as the foundation for Alpaca-theme projects. The repo builds two images:

1. **Base image** (`chachakawooka/mage_stack:<tag>`) — built from `docker/stack/Dockerfile`, contains PHP 8.1 + Nginx + a fully composer-installed Magento. Published to Docker Hub.
2. **Dev image** — built from `Dockerfile-dev`, which extends the base image, adds Alpaca/frontools, and mounts local `app/code` and `app/design/frontend` for live editing.

## Branch-per-version convention (important)

**Each git branch represents one Magento minor version line**, e.g. `2.4.5`, `2.4.6`, `2.4.7`. `master` is not the integration branch for code changes — version-specific work stays on its version branch. When the user asks to "patch Magento" or "bump versions", changes are applied to one or more version branches directly, then tagged and pushed. The canonical procedure is the `patch-magento` skill at `.claude/skills/patch-magento/SKILL.md` — follow it exactly, including the Adobe Commerce Release Notes lookup and the per-branch iteration loop.

Tag convention: Magento's `-pN` patch suffix is rewritten as `.N` for git tags and Docker image tags. `2.4.5-p16` → tag `2.4.5.16` → image `chachakawooka/mage_stack:2.4.5.16`.

## Three files that move together on a version bump

A patch bump touches exactly these three files on the target branch — keep them in sync:

| File | What to change |
|---|---|
| `docker/stack/Dockerfile` | `magento/project-community-edition:<version>` in the `composer create-project` line (uses `-pN` form) |
| `docker-compose-build.yml` | `app` service `image:` tag (uses `.N` form) |
| `Dockerfile-dev` | `FROM chachakawooka/mage_stack:<tag>` (uses `.N` form) |

Commit message format: `Update Magento version to <X.Y.Z-pN> and tags to <X.Y.Z.N>`. Then `git tag <X.Y.Z.N>` and push both branch and tag.

## Common commands

```bash
# Bring up the dev stack
# (Note: README mentions docker-compose-dev.yml — that file doesn't exist; use docker-compose.yml)
docker-compose up

# Build-only (no local mounts, uses pinned base image)
docker-compose -f docker-compose-build.yml up

# Shell into the Magento container
docker-compose exec app bash

# Run Magento CLI inside the container
docker-compose exec app php bin/magento <command>

# Database backup → ./backup/sql/database.sql (auto-restored on next `db` container init)
./scripts/db-backup.sh

# Export the full /app directory out of the container → ./backup/app/
./scripts/export-app.sh

# Destructive: drop all volumes for this project
./scripts/reset.sh
```

## Alpaca / frontools (theme build)

Run Gulp inside the `app` container. The README's `nvm use 12` is stale — the base image installs Node 16 via NVM.

```bash
docker-compose exec app bash
cd vendor/snowdog/frontools
nvm use 16
gulp svg && gulp babel && gulp styles
gulp watch    # already auto-started by supervisord in dev
```

Theme registration: `app/frontools/config/theme.json` — if a theme is renamed under `app/design/frontend/`, update this file too.

## Service map (docker-compose.yml)

| Service | Image | Notes |
|---|---|---|
| `app` | built from `Dockerfile-dev` | exposes `32733:80`; PHP-FPM + Nginx + Gulp via supervisord |
| `db` | `mariadb:10.4` | restores from `./backup/sql/*.sql` on first init |
| `redis` | `redis:${REDIS_VERSION}` | cache + session backend |
| `es01` | built from `Dockerfile-elastic` | Elasticsearch 7.17.9 with ICU + phonetic plugins |
| `rabbitmq` | `rabbitmq:3.9-management` | message queue, UI on `15672` |

Magento connects to these by service name (`db`, `redis`, `es01`, `rabbitmq`) — configured in `setup.sh` from `.env`.

## Container init flow

`setup.sh` (run by `start.sh` inside the container) is idempotent: it configures DB/Redis/ES/RabbitMQ, runs `setup:install` only if Magento isn't already installed, disables 2FA (dev only), runs `setup:upgrade`, `setup:di:compile`, `setup:static-content:deploy en_GB en_US`, then triggers Gulp and reindex. Edits to env vars in `.env` typically require a container restart, not a rebuild.
