#!/bin/sh

cd `dirname "$0"`

cp bad.json bad.json.bak
python3 -m dctbnbc.get_init_token_list -u -f bad_sites.json -s bad.json
python3 -m dctbnbc.update_token_list -s bad.json
cat bad.json | python3 -m dctbnbc.get_token_list >bad_tl.json
cp good.json good.json.bak
python3 -m dctbnbc.get_init_token_list -u -f good_sites.json -s good.json
python3 -m dctbnbc.update_token_list -s good.json
cat good.json | python3 -m dctbnbc.get_token_list >good_tl.json
python3 -m dctbnbc.approach_b.gen_knowledge -a good_tl.json -b bad_tl.json >knowledge
