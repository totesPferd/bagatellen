#!/bin/sh

cd `dirname "$0"`

cat bad.json | python3 -m dctbnbc.get_init_token_list -u -f bad_sites.json >bad.json.bak
python3 -m dctbnbc.update_token_list <bad.json.bak >bad.json || mv bad.json.bak bad.json
cat bad.json | python3 -m dctbnbc.get_token_list >bad_tl.json
cat good.json | python3 -m dctbnbc.get_init_token_list -u -f good_sites.json >good.json.bak
python3 -m dctbnbc.update_token_list <good.json.bak >good.json || mv good.json.bak good.json
cat good.json | python3 -m dctbnbc.get_token_list >good_tl.json
python3 -m dctbnbc.subtract -a bad_tl.json -b good_tl.json >knowledge
