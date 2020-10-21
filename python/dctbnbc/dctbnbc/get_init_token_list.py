import dctbnbc.get_authors
import dctbnbc.tally
import feedparser
import json
import getopt
import sys


def print_usage(file):
   file.write("\nUSAGE:\n\n")
   file.write("%s [-h|--help]\n" % sys.argv[0])
   file.write("   write this usage information.\n\n")
   file.write("%s [-u|--update] [{-f|--file} <site_files] ... [<feed_url>] ...\n" % sys.argv[0])
   file.write("   provide initial data to <stdout> which can be consumed by dctbnbc.update_token_list program.\n")
   file.write("   give -u switch for update mode: read from <stdin>.\n")


def interpret_cmdline(result):

   retval =  "OK"

   try:
      optlist, args =  getopt.getopt(sys.argv[1:], "hf:u", [ "help", "file", "update" ])

      if "update_mode" not in result.keys():
         result["update_mode"] =  False

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
         elif option in { "-u", "--update" }:
            if result["update_mode"]:
               sys.stderr.write("give -u option once only!\n");
               retval =  "Error"
            else:
               result["update_mode"] =  True
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


def add_post(out_data, url):
   is_found =  False
   for eurl in out_data["posts"]:
      if "href" in eurl and isinstance(eurl["href"], str):
         if eurl["href"] == url:
            is_found = True
            break
      else:
         sys.stderr.write("there are malformed posts in post region in json file.\n")
   if not is_found:
      out_data["posts"].append({
            "href": url
         ,  "ids": [] })
         

# interprete cmdline.
cmdline_params =  {}
retval =  interpret_cmdline(cmdline_params)
if retval == "Error":
   sys.exit(2)
elif retval == "HelpMode":
   sys.exit(0)

tally =  dctbnbc.tally.Tally()
if cmdline_params["update_mode"]:
   raw_stdin_data =  sys.stdin.read()
   try:
      out_data =  json.loads(raw_stdin_data)
   except json.decoder.JSONDecodeError:
      sys.stderr.write("<stdin> not a json file.\n")
      sys.exit(2)

   errval =  0

   if "posts" not in out_data or not isinstance(out_data["posts"], list):
      sys.stderr.write("<stdin> json file does not contain posts key assigning to dict.\n")
      errval =  2

   if not tally.load(out_data):
      sys.stderr.write("<stdin> json file does not contain absolute key assigning to dict.\n")
      errval =  2

   if errval != 0:
      sys.exit(errval)


else:
   out_data =  { "posts": [] }
   tally.init()
   tally.save(out_data)
   

for url in cmdline_params["urls"]:
   add_post(out_data, url)

for f in cmdline_params["files"]:
   try:
      with open(f) as fd:
         raw_f_data =  fd.read()
         json_f_data =  json.loads(raw_f_data)
         if "sites" in json_f_data and isinstance(json_f_data["sites"], list):
            for site in json_f_data["sites"]:
               if "href" in site:
                  add_post(out_data, site["href"])
               else:
                  sys.stderr.write("href key is missing in a element of list assigned to sites key in json file %s given in -f cmdline param.\n" % f)
         else:
            sys.stderr.write("json file %s given in a -f cmdline param has no sites key assigned with a list of sites.\n" % f)
         if "authors" in json_f_data and isinstance(json_f_data["authors"], list):
            if "authors" in out_data:
               out_data["authors"] =  list(set(out_data["authors"]) | set(json_f_data["authors"]))
               out_data["authors"].sort()
            else:
               out_data["authors"] =  json_f_data["authors"]
   except FileNotFoundError:
      sys.stderr.write("%s given in a -f cmdline param not found.\n" % f)
      sys.exit(2)

print(json.dumps(out_data, indent = 3, sort_keys = True))
