import json
import os
import os.path
import sys

def get_config_from_file(result):
   retval =  False

   file_path =  os.path.join(os.getenv("HOME"), "dctbnbc.json")
   try:
      with open(file_path, "r") as fd:
         raw_data =  fd.read()
         json_data =  json.loads(raw_data)
         result["bad_guys"] =  json_data["bad_guys"]
         result["bad_sites"] =  json_data["bad_sites"]
         result["good_sites"] =  json_data["good_sites"]
         retval =  True
   except FileNotFoundError:
      sys.stderr.write("config file %s not found.\n" % file_path)
   except json.decoder.JSONDecodeError:
      sys.stderr.write("no valid json data in config file %s.\n" % file_path)

   return retval
