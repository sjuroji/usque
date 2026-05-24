# Initial research on Cloudflare's MASQUE implementation

It took me months to get this all figured out *(though there is a lot of room for me to improve)*, so I figured I will write down my findings and hopefully give pointers to interested future contributors. This is going to sound like a blog post, but I hope it will be useful for someone. In the future I might will make a more concise version of this with just the protocol details, but for now this contains the whole journey's important bits.

## Table of contents

- [Initial research on Cloudflare's MASQUE implementation](#initial-research-on-cloudflares-masque-implementation)
  - [Table of contents](#table-of-contents)
  - [Initial poking](#initial-poking)
  - [API](#api)
  - [Poking on QUIC](#poking-on-quic)
  - [TLS Authentication](#tls-authentication)
  - [QUIC](#quic)
  - [Connect-IP](#connect-ip)
  - [libwarp\_mobile.so](#libwarp_mobileso)
  - [TL;DR](#tldr)
  - [WireShark inspection of the decrypted traffic](#wireshark-inspection-of-the-decrypted-traffic)
  - [Final thoughts](#final-thoughts)
  - [Extras](#extras)
  - [Interesting other CONNECT-IP related projects](#interesting-other-connect-ip-related-projects)
  - [Interesting other QUIC related projects](#interesting-other-quic-related-projects)

## Initial poking

First I took a look at the Android app. Frida support is great there and with the help of [this](https://github.com/httptoolkit/frida-interception-and-unpinning/tree/4d477da) and mitmproxy, it was trivial to see how the app registers a new user and enrolls the new device, switches keys, etc.

## API

I am not going to go into details about the API, as it is pretty well studied already by others. I did not, but you should check out [wgcf](https://github.com/ViRb3/wgcf) as they went into great lengths to reverse engineer the API.

One call stood out though:

```shell
curl -H 'Authorization: Bearer 00000000-0000-0000-0000-000000000000' -H 'User-Agent: WARP for Android' -H 'CF-Client-Version: a-6.81-4616' -H 'Content-Type: application/json; charset=UTF-8' -H 'Connection: Keep-Alive' --compressed -X PATCH https://api.cloudflareclient.com/v0a4616/reg/00000000-0000-0000-0000-000000000000 -d '{"key":"M...redacted...==","key_type":"secp256r1","tunnel_type":"masque"}'
```

The app sends this once you switch over to the MASQUE protocol. I wanted to know more about the seemingly Base64 encoded key, so I copied it over to my favorite [ASN.1 decoder](https://pkitools.net/pages/ca/asn1.html).

Looked like an `ecPublicKey` with `prime256v1`, so the `secp256r1` key type made sense. Based on earlier findings from other people regarding WireGuard, I assumed that this is the way how the client tells the server about our public key. And I assumed that there is TLS authentication later instead of other credentials.

## Poking on QUIC

Then I installed the Linux client for ease of network debugging and opened WireShark. It's important that you have an up to date WireShark as QUIC support isn'

> **Personal note:** I reproduced the WireShark capture steps on Wireshark 4.2.5 on Arch Linux and everything worked as described. Make sure to set the `SSLKEYLOGFILE` environment variable before launching the WARP client so the TLS session keys get exported and QUIC traffic can be decrypted.
