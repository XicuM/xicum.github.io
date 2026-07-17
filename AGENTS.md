# AGENTS.md — xicu.net

Personal website built with Hugo + PaperMod theme, deployed to GitHub Pages.

## Commands

```bash
hugo server --disableFastRender -D   # dev (drafts/expired included)
hugo --gc --minify                    # production build (CI does this)
```

No test, lint, or typecheck commands exist.

## Architecture

- **Multilingual:** content under `content/en/` and `content/es/`. Root redirects via JS browser-language detection (`layouts/alias.html`).
- **Theme chain:** Three git submodules under `themes/` — PaperMod (primary), hugo-adobe-pdf-embed, hugo-shortcode-gallery. Custom overrides in `layouts/` take precedence.
- **Custom templates:** The base template, single, list, posts list, RSS, header, footer, head, comments (Giscus), TOC sidebar, and share icons are all overridden in `layouts/`. Changes to layout/markup should be made there, not in `themes/`.
- **GitHub Pages:** CI deploys on push to `main` (`.github/workflows/hugo.yaml`). Submodules must be checked out recursively.

## Content conventions

Front matter flags (all optional):
- `comments: true` — enables Giscus (repo `XicuM/xicu.net`)
- `showToc: true` — floating TOC sidebar
- `hideMeta: true` — suppresses date/author metadata
- `cover.image` — hero image for posts
- `github: <url>` — "See on GitHub" button
- `icon: <path>` — icon for project cards in list view

Post images live under `assets/` (Hugo pipeline) with optional `.meta` sidecar files. Static files (CV, icons, logos) live under `static/`.

## Gotchas

- Theme submodules must be cloned (`git clone --recurse-submodules`) or CI build will fail.
- Hugo config is split: `config/_default/hugo.yaml` (main) + `config/_default/languages.yaml` (en/es).
- The `baseof.html` override requires Hugo ≥ v0.112.4. CI uses v0.164.0.
- `debug.sh` adds `127.0.0.1 xicu.net` to `/etc/hosts` before starting the dev server — useful for testing the root language redirect.
