import dctbnbc.algorithm
import dctbnbc.config_file
import dctbnbc.traverse_posts
import getopt
import json
import sys

def print_usage(file):
   file.write("USAGE:\n\n")
   file.write("%s [-h|--help]\n" % sys.argv[0])
   file.write("   write this usage information.\n\n")
   file.write("%s\n" % sys.argv[0])
   file.write("   learn.\n")


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

# fetch config file
config_info = {}
if not dctbnbc.config_file.get_config_from_file(config_info):
   sys.stderr.write("problem in config file found.\n")
   sys.exit(2)

algo =  dctbnbc.algorithm.Algorithm()
dctbnbc.traverse_posts.traverse_posts(algo, config_info)

print(json.dumps(algo.get_report(), indent = 3, sort_keys = True))
