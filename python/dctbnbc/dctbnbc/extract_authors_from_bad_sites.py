import dctbnbc.config_file
import dctbnbc.get_authors
import feedparser
import getopt
import json
import sys


def print_usage(file):
   file.write("USAGE:\n\n")
   file.write("%s [-h|--help]\n" % sys.argv[0])
   file.write("   write this usage information.\n\n")
   file.write("%s\n" % sys.argv[0])
   file.write("   extract authors appearing in bad sites.\n")


def interpret_cmdline():

   retval =  "OK"

   try:
      optlist, args =  getopt.getopt(sys.argv[1:], "h", [ "help" ])

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
         sys.stderr.write("no comdline arg permitted.\n\n")
         print_usage(sys.stderr)
         retval =  "Error"

   except getopt.GetoptError as err:
      sys.stderr.write("%s\n\n" % str(err))
      print_usage(sys.stderr)
      retval =  "Error"

   return retval


# interprete cmdline.
retval =  interpret_cmdline()
if retval == "Error":
   sys.exit(2)
elif retval == "HelpMode":
   sys.exit(0)

# fetch config gile
result = {}
if not dctbnbc.config_file.get_config_from_file(result):
   sys.stderr.write("problem in config file found.\n")
   sys.exit(2)

authors_set =  set()
for site in result["bad_sites"]:
   if isinstance(site, dict) and "href" in site.keys():
      url =  site["href"]
      fp =  feedparser.parse(url)
      dctbnbc.get_authors.get_authors_feed(authors_set, fp)
   else:
     sys.stderr.write("there are illformed items in bad_sites region in config file.\n")
     sys.exit(2)

authors_list =  list(authors_set)
authors_list.sort()
retval =  { "authors": authors_list }
print(json.dumps(retval, indent = 3, sort_keys = True))

