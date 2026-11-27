#!/bin/sh
# BASIC listing -> tape recording for the Sharp PC-E500(S), with a read-back check.
# Uses the Sharp Pocket-Tools (bas2img, bin2wav, wav2bin; sources in this folder).
# Usage: tools/make_wav.sh Basic/listing.txt wav/out.wav NAME [img|txt]     (NAME: up to 8 characters)
#   img (default): BASIC program image with intermediate code.  txt: TEXT-mode image (load, then BASIC).
set -e
SRC="$1"; OUT="$2"; NAME="$3"; TYPE="${4:-img}"
[ -n "$NAME" ] || { echo "usage: $0 listing.txt out.wav NAME [img|txt]"; exit 1; }
D=$(dirname "$0"); B="$D/bin"
mkdir -p "$B"
for t in bas2img bin2wav wav2bin; do
  [ -x "$B/$t" ] || gcc -O2 -o "$B/$t" "$D/$t.c" -lm
done
T=$(mktemp -d)
"$B/bas2img" -q -p E500S -t "$TYPE" "$SRC" "$T/p.$TYPE"
"$B/bin2wav" -q -p E500S -t "$TYPE" --name="$NAME" "$T/p.$TYPE" "$OUT"
"$B/wav2bin" -q -t "$TYPE" -p E500S "$OUT" "$T/back.$TYPE"
cmp "$T/p.$TYPE" "$T/back.$TYPE" && echo "read-back check OK: $OUT ($TYPE, $(wc -c < "$T/p.$TYPE") bytes)"
rm -rf "$T"
