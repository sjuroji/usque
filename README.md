# usque

🥚➡️🍏🍎

Usque is an open-source reimplementation of the Cloudflare WARP client's MASQUE mode. It leverages the [Connect-IP (RFC 9484)](https://datatracker.ietf.org/doc/rfc9484/) protocol and comes with many operation modes including a native tunnel, a SOCKS5 proxy, and a HTTP proxy.

## Table of Contents

- [usque](#usque)
  - [Table of Contents](#table-of-contents)
  - [Installation](#installation)
  - [Building from source](#building-from-source)
    - [Docker](#docker)
  - [Usage](#usage)
    - [Registration](#registration)
    - [Enrolling](#enrolling)
    - [Native Tunnel Mode (for Advanced Users, Linux and Windows only!)](#native-tunnel-mode-for-advanced-users-linux-and-windows-only)
      - [On Linux](#on-linux)
      - [On Windows](#on-windows)
      - [Routes on Linux](#routes-on-linux)
      - [Routes on Windows](#routes-on-windows)
    - [SOCKS5 Proxy Mode (easy, cross-platform)](#socks5-proxy-mode-easy-cross-platform)
    - [HTTP Proxy Mode (easy, cross-platform)](#http-proxy-mode-easy-cross-platform)
    - [Port Forwarding Mode (for Advanced Users, cross-platform)](#port-forwarding-mode-for-advanced-users-cross-platform)
    - [Connect/Disconnect Hooks](#connectdisconnect-hooks)
      - [Example on Linux](#example-on-linux)
      - [Example on Windows](#example-on-windows)
    - [TCP and HTTP/2 Support](#tcp-and-http2-support)
      - [HTTP/2 Configuration](#http2-configuration)
    - [Configuration](#configuration)
      - [Fields](#fields)
  - [ZeroTrust support](#zerotrust-support)
  - [Performance](#performance)
    - [Performance Tuning](#performance-tuning)
      - [Linux/BSD](#linuxbsd)
      - [DNS](#dns)
  - [Using this tool as a library](#using-this-tool-as-a-library)
  - [Known Issues](#known-issues)
  - [Miscellaneous](#miscellaneous)
    - [Censorship circumvention](#censorship-circumvention)
  - [Should I replace WireGuard with this?](#should-i-replace-wireguard-with-this)
    - [Why would you still switch?](#why-would-you-still-switch)
  - [Protocol \& research details](#protocol--research-details)
  - [Why was this built?](#why-was-this-built)
  - [Why did you fork connect-ip-go?](#why-did-you-fork-connect-ip-go)
  - [Why the name?](#why-the-name)
  - [Contributing](#contributing)
  - [Acknowledgements](#acknowledgements)
  - [Disclaimer](#disclaimer)

> **Personal fork note:** I'm using this primarily for learning about MASQUE/QUIC tunneling. Tested on Linux `amd64` only. Upstream repo: [Diniboy1123/usque](https://github.com/Diniboy1123/usque).

## Installation

You can download the latest release from the [releases page](https://github.com/Diniboy1123/usque/releases). For now, Android (`arm64`), Linux (`armv5`, `armv6`, `armv7`, `arm64`, `amd64`), Windows (`arm64`, `amd64`) and Darwin (`arm64`, `amd64`) binaries are provided. **However only the Linux `amd64` binary was tested.** If you have a different platform, you can build from source.

Extract the archive and you will find a binary named `usque` in the root directory. You can move this binary to a directory in your `PATH` to make it accessible from anywhere.

## Building from source

Since the tool is written in Go, it should be rather trivial.

1