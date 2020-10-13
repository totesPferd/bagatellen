import dctbnbc.get_authors
import feedparser
import json
import getopt
import sys


def print_usage(file):
   file.write("\nUSAGE:\n\n")
   file.write("%s [-h|--help]\n" % sys.argv[0])
   file.write("   write this usage information.\n\n")
   file.write("%s [{-f|--file} <site_files] ... [<feed_url>] ...\n" % sys.argv[0])
   file.write("   provide initial data to <stdout> which can be consumed by dctbnbc.update_token_list program.\n")


def interpret_cmdline(result):

   retval =  "OK"

   try:
      optlist, args =  getopt.getopt(sys.argv[1:], "hf:", [ "help", "file" ])

      if "files" not in result.keys():
         result["files"] =  []

      if "urls" not in result.keys():
         result["urls"] =  []

      for option, arg in optlist:
         if option in { "-h", "--help" }:
            if retval == "OK":
               print_usage(sys.stdout)
               retval =  "HelpMode"
         elif option in { "-f", "--file" }:
            result["files"].append(arg)
         else:
            sys.stderr.write("option %s not permitted.\n\n" % option)
            retval =  "Error"

      for arg in args:
         result["urls"].append(arg)

   except getopt.GetoptError as err:
      sys.stderr.write("%s\n\n" % str(err))
      retval =  "Error"

   if retval == "Error":
      print_usage(sys.stderr)

   return retval

# interprete cmdline.
cmdline_params =  {}
retval =  interpret_cmdline(cmdline_params)
if retval == "Error":
   sys.exit(2)
elif retval == "HelpMode":
   sys.exit(0)

out_data =  {
      "nr": 0
   ,  "abundance": {}
   ,  "etags": [{
            "href": url
         ,  "etags": [] } for url in cmdline_params["urls"] ]}

for f in cmdline_params["files"]:
   try:
      with open(f) as fd:
         raw_f_data =  fd.read()
         json_f_data =  json.loads(raw_f_data)
         if "sites" in json_f_data and isinstance(json_f_data["sites"], list):
            for site in json_f_data["sites"]:
               if "href" in site:
                  out_data["etags"].append({ "href": site["href"], "etags": [] })
               else:
                  sys.stderr.write("href key is missing in a element of list assigned to sites key in json file %s given in -f cmdline param.\n" % f)
         else:
            sys.stderr.write("json file %s given in a -f cmdline param has no sites key assigned with a list of sites.\n" % f)
         if "authors" in json_f_data and isinstance(json_f_data["authors"], list):
            if "authors" in out_data:
               out_data["authors"] =  list(set(out_data["authors"]) | set(json_f_data["authors"]))
            else:
               out_data["authors"] =  json_f_data["authors"]
   except FileNotFoundError:
      sys.stderr.write("%s given in a -f cmdline param not found.\n" % f)
      sys.exit(2)

print(json.dumps(out_data, indent = 3, sort_keys = True))
