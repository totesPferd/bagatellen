import dctbnbc.get_authors
import feedparser
import json
import getopt
import sys


def print_usage(file):
   file.write("USAGE:\n\n")
   file.write("%s [-h|--help]\n" % sys.argv[0])
   file.write("   write this usage information.\n\n")
   file.write("%s [<feed_url>] ...\n" % sys.argv[0])
   file.write("   extract authors appearing in <feed_url>.\n")


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
elif retval == "HelpMode":
   sys.exit(0)

authors_set =  set()
for url in url_list["urls"]:
   fp =  feedparser.parse(url)
   dctbnbc.get_authors.get_authors(authors_set, fp)
authors_list =  list(authors_set)
authors_list.sort()
retval =  { "authors": authors_list }
print(json.dumps(retval, indent = 3, sort_keys = True))
