# CLAUDE.md

## Project Overview

R3BL Shortlink is a browser extension (Manifest V3) for creating "go links" — short aliases that open one or more URLs. Published to both the Chrome Web Store and Firefox Add-ons (AMO).

## Tech Stack

- **Language:** TypeScript, React 18
- **Bundler:** Webpack 5
- **Testing:** Jest + ts-jest
- **Formatter:** Prettier
- **Package manager:** npm

## Project Structure

- `src/` — TypeScript source code
  - `app/` — Main React app (App.tsx, logic.tsx, command.ts, toast.ts)
  - `browser_host/` — Browser API abstraction layer (storage, omnibox, messaging)
  - `browser_utils/` — Tab utilities
  - `core/` — Shared types
  - `service_worker/` — Omnibox listener
  - `background.ts` — Service worker entry point
  - `popup.tsx` — Popup UI entry point
- `public/` — Static assets copied to `dist/` by webpack
  - `manifest.chrome.json` — Chrome-specific manifest (uses `background.service_worker`)
  - `manifest.firefox.json` — Firefox-specific manifest (uses `background.scripts`, includes `browser_specific_settings`)
- `webpack/` — Webpack configs (common, dev, prod)
- `dist/` — Build output (gitignored)

## Important: Separate Manifests

Chrome and Firefox require **different** manifest.json files for MV3:
- Chrome: `"background": { "service_worker": "js/background.js" }` — does NOT support `"scripts"`
- Firefox: `"background": { "scripts": ["js/background.js"] }` — does NOT support `"service_worker"`

Both manifests live in `public/` and the build script copies the correct one to `dist/manifest.json`. When bumping versions, update **both** manifest files.

## Release Workflow

### 1. Make changes
Edit source in `src/`, then bump the version in **both** manifests:
- `public/manifest.chrome.json`
- `public/manifest.firefox.json`

### 2. Build for testing
```sh
./make-distro.sh build              # Build both (single webpack build, produces both artifacts)
./make-distro.sh build chrome       # Build Chrome only
./make-distro.sh build firefox      # Build Firefox only
```

When building both, `dist/` is left with the Chrome manifest so you can load it directly.

### 3. Test locally
- **Chrome:** Go to `chrome://extensions`, enable Developer mode, click "Load unpacked", select `dist/`.
- **Firefox:** Go to `about:debugging#/runtime/this-firefox`, click "Load Temporary Add-on", select `dist/manifest.json`.

### 4. Publish when ready
```sh
./make-distro.sh publish            # Build and publish both
./make-distro.sh publish chrome     # Build Chrome only (manual upload reminder)
./make-distro.sh publish firefox    # Build, sign, and publish Firefox to AMO
```

**Important:**
- `build` produces artifacts for local testing only — **no publishing**.
- `publish` builds AND publishes. Firefox `web-ext sign` **auto-publishes to AMO immediately** — do not run publish until you have tested locally.
- Chrome always requires **manual upload** to [Chrome Web Store developer dashboard](https://chrome.google.com/webstore/devconsole) — upload `shortlink.zip`.
- Firefox signing requires `MOZ_AMO_KEY` and `MOZ_AMO_SECRET` env vars (loaded from `~/.profile`).
- `web-ext` must be installed globally (`sudo npm install -g web-ext`).

## Development

```sh
npm run watch    # Webpack watch mode (dev build with source maps)
npm run build    # Production build
npm run test     # Run Jest tests
npm run style    # Prettier formatting
npm run clean    # Remove dist/
```

When using `npm run watch` or `npm run build` directly (without `make-distro.sh`), you need to manually copy the manifest:
```sh
cp public/manifest.chrome.json dist/manifest.json   # For Chrome
cp public/manifest.firefox.json dist/manifest.json  # For Firefox
```

## Storage

Uses `chrome.storage.sync` API — data syncs across user's devices. The `browser_host/` abstraction layer allows swapping storage providers for testing.
