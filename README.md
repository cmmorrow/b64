# b64

A command-line tool for working with base-64 encoded strings.

## Requirements

b64 is written in Elixir and will require Elixir > 1.10 if installed locally.

## Installation

### Docker

Run `docker build -t b64 .`
Verify b64 is installed properly by running `docker run -i --rm b64 --help`.

### Local

Start by cloning the repo at [https://github.com/cmmorrow/b64](https://github.com/cmmorrow/b64).

Run mix escript.build from the command line to build the b64 binary.
Verify b64 is installed properly by running `./b64 --help`.

## Usage

```text
Usage: b64 [--encode|--decode] [STRING]

  A command-line tool for working with base-64 encoded strings.

  STRING - If encoding, STRING is a unicode, ASCII, or binary string.
            If decoding, STRING is a base-64 encoded string.
            Optionally, STRING can be piped from STDIN.

Options:
  --decode       Decode a base-64 encoded string to a binary string.
  -d             Alias for --decode.
  --encode       Encode a unicode, ASCII, or binary string to base-64.
  -e             Alias for --encode.
  --help         Prints this message.
  --urldecode    Decode a base-64 encoded string containing URL safe 
                  characters.
  --urlencode    Encode a base-64 string using URL safe characters.
```

## Examples

Encode an ASCII string.

```bash
b64 --encode hello
```

Decode an ASCII string.

```bash
b64 --decode aGVsbG8=
```

Encode an ASCII string from stdin.

```bash
echo 'hello' | b64 --encode
```

Decode an ASCII string from stdin.

```bash
echo 'aGVsbG8=' | b64 --decode
```

Encode a unicode string.

```bash
b64 --encode エンコード
```

Decode a unicode string

```bash
b64 --decode 44Ko44Oz44Kz44O844OJ
```
