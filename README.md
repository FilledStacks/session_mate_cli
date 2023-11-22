# Session Mate CLI

The companion of Session Mate is a CLI app called **sessionmate**. Is in charge of the replay of the sessions. Also, allows the user to login, logout, register an application and register a user.

## Installation

### macOS
The installation of the CLI is through the package manager Homebrew.

Install our Brew Repository known as Tap.

```bash
brew tap filledstacks/tap
```

Then install the package.

```bash
brew install sessionmate
```

## Upgrade

To upgrade sessionmate CLI you can execute the following command:

```bash
brew upgrade filledstacks/tap/sessionmate
```

## Get Started

> For **session mate** to be able to replay a session it must be a device running on your computer.
> - Emulator supported: Android and iOS
> - Devices supported: Android

To launch the app through sessionmate CLI run

```bash
sessionmate drive -p .
```

If you need to pass additional commands like **flavor** information or anything like that you can use the **additional-commands** option.

```bash
sessionmate drive -p . --additional-commands="--flavor dev"
```

The drive command will start the app and enable the replay UI.

You can run help like below to see the rest of the options

```bash
sessionmate drive -h
```

## Development

To use **Firebase Emulator** instead of the production Firebase instance, you need to pass **USE_FIREBASE_EMULATOR** dart define environment variable as below.

```bash
dart --define=WEB_API_KEY=xxxxxx --define=USE_FIREBASE_EMULATOR=true run bin/sessionmate.dart drive -p .
```