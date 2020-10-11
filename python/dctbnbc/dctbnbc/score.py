import dctbnbc.evaluate
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
      optlist, args =  getopt.getopt(sys.argv[1:], "h", [ "help" ])

      if "urls" not in result.keys():
         result["urls"] =  []

      for option, arg in optlist:
         if option in { "-h", "--help" }:
            if retval != "OK":
               print_usage(sys.stdout)
               retval =  "HelpMode"
         else:
            sys.stderr.write("option %s not permitted.\n\n" % option)
            print_usage(sys.stderr)
            retval =  "Error"

      for arg in args:
         result["urls"].append(arg)

   except getopt.GetoptError as err:
      sys.stderr.write("%s\n\n" % str(err))
      print_usage(sys.stderr)
      retval =  "Error"

   return retval


# interprete cmdline.
url_list =  {}
retval =  interpret_cmdline(url_list)
if retval == "Error":
   sys.exit(2)

raw_data =  sys.stdin.read()
knowledge =  json.loads(raw_data)

score =  0
creatures =  set()
used_words =  knowledge["score"].keys()
for url in url_list["urls"]:
   fp =  feedparser.parse(url)
   for entry in fp["entries"]:
      if "summary" in entry.keys():
         content =  entry["summary"]
         token_list =  dctbnbc.tokenize.tokenize(content)
         score =  score + dctbnbc.evaluate.get_score(knowledge, token_list)
         creatures =  creatures | { token for token in token_list if token not in used_words }
creatures_list =  list(creatures)
creatures_list.sort()

retval =  { "creatures": creatures_list, "score": score }
print(json.dumps(retval, indent = 3, sort_keys = True))
