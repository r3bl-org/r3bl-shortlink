# Rewrite r3bl-shortlink in Rust with Leptos

## Goal
Rewrite the existing JavaScript/React browser extension into Rust using the Leptos framework, Trunk for building, and custom Wasm bindings for Browser APIs. This will eliminate NPM security vulnerabilities and provide a faster, safer codebase.

## Tech Stack
- **Framework**: [Leptos](https://leptos.dev/) (Signals-based reactivity)
- **Build Tool**: [Trunk](https://trunkrs.dev/)
- **Serialization**: `serde` + `serde-wasm-bindgen` (for Chrome Storage JSON)
- **Browser Interop**: `wasm-bindgen` + `js-sys` (custom bindings for `chrome.*`)
- **Parsing**: Standard Rust string methods (no heavy regex/parser crates)
- **Platform**: Chrome & Firefox (Manifest V3)

## Architecture

### 1. Data Model (`src/models.rs`)
Port existing TypeScript interfaces to Rust structs with `serde`:
- `Shortlink`: name and vector of URLs.
- `StoredValue`: wrapper for storage.
- `Command`: Enum representing all user actions (`Go`, `Save`, `Delete`, `Copy`, `Import`, `Export`).

### 2. Browser API Bindings (`src/browser.rs`)
Manually define `extern "C"` blocks for:
- `chrome.storage.sync` (get, set, remove, clear)
- `chrome.tabs` (query, create)
- `chrome.runtime` (lastError)
- `chrome.omnibox` (onInputEntered)
- `navigator.clipboard` (writeText)

### 3. Business Logic (`src/logic.rs`)
- **Command Parsing**: Port `command.ts` using `input.trim()`, `input.starts_with()`, etc.
- **Shortlink Operations**: CRUD logic, validation (port `validateShortlinkName`).
- **Tab Management**: logic for opening multiple URLs.

### 4. UI Layer (`src/main.rs`)
- Use Leptos components for the popup.
- Bind the input field to a signal for real-time parsing.
- Reuse existing CSS (`style.css`, `reset.css`, `native-toast.css`).

### 5. Service Worker (`background.js` shim)
- A small JS file to load the Wasm module and wire up the Omnibox listener.

---

## Roadmap

### Phase 1: Project Scaffolding
- [ ] Initialize Rust project.
- [ ] Configure `Trunk.toml` and `Cargo.toml`.
- [ ] Set up basic "Hello World" Leptos popup.

### Phase 2: Core Logic & Types
- [ ] Define Rust models and `serde` implementations.
- [ ] Port command parsing logic.
- [ ] Add unit tests in Rust for parsing and validation.

### Phase 3: Browser Interop
- [ ] Write `wasm-bindgen` bindings for `chrome.storage`.
- [ ] Write `wasm-bindgen` bindings for `chrome.tabs` and `clipboard`.
- [ ] Implement storage provider abstraction in Rust.

### Phase 4: UI Port
- [ ] Recreate the Popup UI in Leptos.
- [ ] Integrate CSS assets.
- [ ] Implement Toast notifications (can reuse JS lib or port to Rust).

### Phase 5: Manifests & Distribution
- [ ] Update `make-distro.sh` to build Rust via Trunk.
- [ ] Ensure Chrome and Firefox manifests correctly point to the Wasm-loaded popup.
- [ ] Implement the Omnibox listener in Rust/JS.

### Phase 6: Validation & Cleanup
- [ ] Verify Import/Export functionality.
- [ ] Test cross-browser compatibility (Chrome and Firefox).
- [ ] Remove all legacy JS/React files once parity is reached.
