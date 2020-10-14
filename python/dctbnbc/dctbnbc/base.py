import json
import sys

def interprete_feed_cmdline(url_set, cmdline_params):
   retval =  0
   for f in cmdline_params["files"]:
      try:
         with open(f) as fd:
            raw_f_data =  fd.read()
            json_f_data =  json.loads(raw_f_data)
            if "sites" in json_f_data and isinstance(json_f_data["sites"], list):
               for site in json_f_data["sites"]:
                  if "href" in site:
                     url_set.add(site["href"])
                  else:
                     sys.stderr.write("href key is missing in a element of list assigned to sites key in json file %s given in -f cmdline param.\n" % f)
            else:
               sys.stderr.write("json file %s given in a -f cmdline param has no sites key assigned with a list of sites.\n" % f)
      except FileNotFoundError:
         sys.stderr.write("%s given in a -f cmdline param not found.\n" % f)
         retval =  2

   return retval
   
