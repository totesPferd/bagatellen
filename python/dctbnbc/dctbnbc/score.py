import dctbnbc.base
import dctbnbc.tally
import dctbnbc.tokenize
import feedparser
import getopt
import json
import sys

def print_usage(file):
   file.write("USAGE:\n\n")
   file.write("%s [-h|--help]\n" % sys.argv[0])
   file.write("   write this usage information.\n\n")
   file.write("%s [<feed_url>] ...\n" % sys.argv[0])
   file.write("   compute score of <feed_url> according to knowledge based given by stdin.\n")

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

raw_data =  sys.stdin.read()
knowledge =  json.loads(raw_data)

url_set =  set(cmdline_params["urls"])
retval =  dctbnbc.base.interprete_feed_cmdline(url_set, cmdline_params)
if retval != 0:
   sys.exit(retval)

creatures =  set()
used_words =  knowledge["scores"].keys()
tally =  dctbnbc.tally.Tally()
tally.init()
for url in url_set:
   fp =  feedparser.parse(url)
   for entry in fp["entries"]:
      if "summary" in entry.keys():
         content =  entry["summary"]
         token_list =  dctbnbc.tokenize.tokenize(content)
         for token in token_list:
            tally.inc(token)
         creatures =  creatures | { token for token in token_list if token not in used_words }
score =  tally.total_score(knowledge)
creatures_list =  list(creatures)
creatures_list.sort()

retval =  { "creatures": creatures_list, "score": score }
print(json.dumps(retval, indent = 3, sort_keys = True))
