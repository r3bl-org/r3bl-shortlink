# R3BL Shortlink - a browser extension written in Typescript and React

[![Chrome Web Store](https://img.shields.io/badge/Chrome_Web_Store-R3BL_Shortlink-4285F4?logo=googlechrome&logoColor=white)](https://chromewebstore.google.com/detail/r3bl-shortlink/ffhfkgcfbjoadmhdmdcmigopbfkddial)
[![Firefox Add-on](https://img.shields.io/badge/Firefox_Add--on-R3BL_Shortlink-FF7139?logo=firefox&logoColor=white)](https://addons.mozilla.org/en-US/firefox/addon/r3bl-shortlink/)

Table of contents:

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Install the extension 📦](#install-the-extension-)
- [Demo of it in action](#demo-of-it-in-action)
- [What is it?](#what-is-it)
- [Prerequisites](#prerequisites)
- [Option](#option)
- [Includes the following](#includes-the-following)
- [Project Structure](#project-structure)
- [Setup](#setup)
- [Build](#build)
- [Build in watch mode](#build-in-watch-mode)
  - [terminal](#terminal)
  - [Visual Studio Code](#visual-studio-code)
- [Load extension to chrome](#load-extension-to-chrome)
- [Test](#test)
- [Firefox version](#firefox-version)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Install the extension 📦

- **Chrome Web Store**: [Install R3BL Shortlink for Google Chrome](https://chromewebstore.google.com/detail/r3bl-shortlink/ffhfkgcfbjoadmhdmdcmigopbfkddial)
- **Firefox Add-ons**: [Install R3BL Shortlink for Mozilla Firefox](https://addons.mozilla.org/en-US/firefox/addon/r3bl-shortlink/)

## Demo of it in action

https://github.com/r3bl-org/shortlink/assets/2966499/fbe8df3f-2ad9-43b8-8a13-ad43e09a9bed

## What is it?

Years ago when I used to work at Google, there was a way to create something called a "go link".
Here's a
[deprecated extension](https://chrome.google.com/webstore/detail/shortlink/apgeooocopnncglmnlngfpgggkmlcldf)
in the Chrome store that replicated this functionality. The idea was to create a name that you can
remember to represent one or more tabs. So for example, if you want to visit your "banking" sites,
you can create a shortlink called "banking" to open Bank of America and Bank of the West websites
for example.

This is equivalent to creating a bookmark. Except it is much faster and you can just type "go" into
your chrome address bar, and then press <kbd>Tab</kbd>, then type "banking". Press <kbd>Enter</kbd>
and your tabs will reopen!

This browser extension is available for both Google Chrome and Mozilla Firefox. If you would like to contribute there
are plenty of issues that need to be worked on.

## Prerequisites

- [node + npm](https://nodejs.org/) (Current Version)

## Option

- [Visual Studio Code](https://code.visualstudio.com/)

## Includes the following

- TypeScript
- Webpack
- React
- Jest
- Code
  - Chrome Storage
  - Badge number
  - Background script

## Project Structure

| Folder    | Description                |
| --------- | -------------------------- |
| `src/`    | TypeScript source files    |
| `public/` | static files               |
| `dist`    | Chrome Extension directory |
| `dist/js` | Generated JavaScript files |

## Setup

```
npm install
```

## Build

```
npm run build
```

## Build in watch mode

### terminal

```
npm run watch
```

### Visual Studio Code

Run watch mode.

type `Ctrl + Shift + B`

## Load extension to chrome

Load `dist` directory.

## Test

Run `npx jest` or `npm run test`.

## Firefox version

- [Listing on Firefox Add-ons](https://addons.mozilla.org/en-US/firefox/addon/r3bl-shortlink/)
- [PR with changes made for this version](https://github.com/r3bl-org/shortlink/pull/40)
- [Info on porting from chrome to firefox extension](https://decembergarnetsmith.com/2024/05/10/how-to-port-an-mv3-chrome-extension-to-firefox/)
- [Differences between chrome and firefox extensions](https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json/background#browser_support)
