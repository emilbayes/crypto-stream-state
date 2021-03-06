# `crypto-stream-state`

[![Build Status](https://travis-ci.org/emilbayes/crypto-stream-state.svg?branch=master)](https://travis-ci.org/emilbayes/crypto-stream-state)

> Extension of libsodium crypto_stream_xor to do stateful streaming

:warning: Work in progress :construction:

## Usage

```c
#include <string.h>
#include <sodium.h>
#include "crypto_stream_xor.h"

crypto_stream_xor_state state;

#define PART1 (const unsigned char *) "Arbitrary data to encrypt"
#define PART1_LEN 25

#define PART2 (const unsigned char *) " split into "
#define PART2_LEN 12

#define PART3 (const unsigned char *) "three messages"
#define PART3_LEN 14

#define CIPHERTEXT_LEN PART1_LEN + PART2_LEN + PART3_LEN


unsigned char key[crypto_stream_xor_NONCEBYTES];
unsigned char nonce[crypto_stream_xor_KEYBYTES];
unsigned char ciphertext[CIPHERTEXT_LEN];
unsigned char plaintext[CIPHERTEXT_LEN];

int main (int argc, char *argv[]) {
  crypto_stream_keygen(key);
  randombytes_buf(&nonce, crypto_stream_KEYBYTES);

  unsigned char *c = ciphertext;
  unsigned char *p = plaintext;

  memset(c, 0, CIPHERTEXT_LEN);

  int ret;

  // Encrypt part
  ret = crypto_stream_xor_init(&state, nonce, key);
  if (ret) return ret;

  ret = crypto_stream_xor_update(&state, c, PART1, PART1_LEN);
  if (ret) return ret;
  c += PART1_LEN;

  ret = crypto_stream_xor_update(&state, c, PART2, PART2_LEN);
  if (ret) return ret;
  c += PART2_LEN;

  ret = crypto_stream_xor_update(&state, c, PART3, PART3_LEN);
  if (ret) return ret;
  c += PART3_LEN;

  ret = crypto_stream_xor_final(&state);
  if (ret) return ret;

  // Decrypt part

  c -= CIPHERTEXT_LEN; // Rewind c first

  ret = crypto_stream_xor_init(&state, nonce, key);
  if (ret) return ret;

  ret = crypto_stream_xor_update(&state, p, c, 10);
  if (ret) return ret;
  c += 10;
  p += 10;

  ret = crypto_stream_xor_update(&state, p, c, 15);
  if (ret) return ret;
  c += 15;
  p += 15;

  ret = crypto_stream_xor_update(&state, p, c, 16);
  if (ret) return ret;
  c += 16;
  p += 16;

  ret = crypto_stream_xor_update(&state, p, c, 10);
  if (ret) return ret;
  c += 10;
  p += 10;

  ret = crypto_stream_xor_final(&state);
  if (ret) return ret;

  printf("Decrypted: %s\n", plaintext);
  return 0;
}
```

## API

```c
int crypto_stream_xor_statebytes()
```

```c
int crypto_stream_xor_init
   (crypto_stream_xor_state *state,
    unsigned const char nonce[crypto_stream_NONCEBYTES],
    unsigned const char key[crypto_stream_KEYBYTES])
```

```c
int crypto_stream_xor_update
   (crypto_stream_xor_state *state,
    unsigned char *c,
    const unsigned char *m, unsigned long long mlen)
```

```c
int crypto_stream_xor_final
   (crypto_stream_xor_state *state)
```

The above three functions are also available in `crypto_stream_xsalsa20_xor_*`,
`crypto_stream_xchacha20_xor_*`, `crypto_stream_salsa20_xor_*` and
`crypto_stream_chacha20_xor_*` flavours.

## License

[ISC](LICENSE)
