import json
import os
import os.path

def get_config_from_file(result):
   file_path =  os.path.join(os.getenv("HOME"), "dctbnbc.json")
   with open(file_path, "r") as fd:
      raw_data =  fd.read()
      result =  json.loads(raw_data)
      return "bad_guys" in result.keys() and "bad_sites" in result.keys() and "good_sites" in result.keys()
