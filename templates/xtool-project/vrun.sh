#!/usr/bin/env bash
# Build {{APP_NAME}} as an unsigned IPA and install/launch it in the running vphone VM.
set -euo pipefail
cd "$(dirname "$0")"

xtool dev build --ipa
~/Documents/vphone-linux/tools/install-ipa.py xtool/{{APP_NAME}}.ipa \
  --launch {{BUNDLE_ID}} \
  --cid "${CID:-3}"