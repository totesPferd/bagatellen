import json
import getopt
import math
import sys


def print_usage(file):
   file.write("\nUSAGE:\n\n")
   file.write("%s [-h|--help]\n" % sys.argv[0])
   file.write("   write this usage information.\n\n")
   file.write("%s\n" % sys.argv[0])
   file.write("   get token list data for nbc algorithm.\n")
   file.write("   program expects json file in <stdin> and outputs to <stdout>.\n")
   file.write("   <stdin> can be gotten from <stdout> of this program or dctbnbc.get_inital_token_list program.\n")


def interpret_cmdline(result):

   retval =  "OK"

   try:
      optlist, args =  getopt.getopt(sys.argv[1:], "h", [ "help" ])

      for option, arg in optlist:
         if option in { "-h", "--help" }:
            if retval == "OK":
               print_usage(sys.stdout)
               retval =  "HelpMode"
         else:
            sys.stderr.write("option %s not permitted.\n\n" % option)
            retval =  "Error"

      if len(args) != 0:
         sys.stderr.write("do not give cmdline params\n")
         retval =  "Error"

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

raw_stdin_data =  sys.stdin.read()
try:
   json_stdin_data =  json.loads(raw_stdin_data)
except json.decoder.JSONDecodeError:
   sys.stderr.write("<stdin> not a json file.\n")
   sys.exit(2)

retval =  0
if "nr" not in json_stdin_data or not isinstance(json_stdin_data["nr"], int):
   sys.stderr.write("json file from <stdin> does not contain a nr key assigned to an int.\n")
   retval =  2

if "abundance" not in json_stdin_data or not isinstance(json_stdin_data["abundance"], dict):
   sys.stderr.write("json file from <stdin> does not contain a abundance key assigned to a dict.\n")
   retval =  2

if retval != 0:
   sys.exit(retval)
out_data =  {"scores": { token: math.log(1 - json_stdin_data["abundance"][token] / json_stdin_data["nr"]) for token in json_stdin_data["abundance"]}}

print(json.dumps(out_data, indent = 3, sort_keys = True))
