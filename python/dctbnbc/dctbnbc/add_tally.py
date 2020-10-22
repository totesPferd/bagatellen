import dctbnbc.tally
import getopt
import json
import sys

def print_usage(file):
   file.write("\nUSAGE:\n\n")
   file.write("%s [-h|--help]\n" % sys.argv[0])
   file.write("   write this usage information.\n\n")
   file.write("%s [-u|--update] [{-t|--tally} <tally_file>]\n" % sys.argv[0])
   file.write("   generate initial tally file <tally_file>\n")
   file.write("   or update it by other tally from <stdin> if -u switch is given.\n")
   file.write("   default tally: tally.json.\n")

def interpret_cmdline(result):

   retval =  "OK"

   try:
      optlist, args =  getopt.getopt(sys.argv[1:], "hnt:u", [ "help", "subtract", "tally", "update" ])

      if "update_mode" not in result:
         result["update_mode"] =  False

      if "subtract_mode" not in result:
         result["subtract_mode"] =  False

      if "tally" not in result:
         result["tally"] =  "tally.json"

      for option, arg in optlist:
         if option in { "-h", "--help" }:
            if retval == "OK":
               print_usage(sys.stdout)
               retval =  "HelpMode"
         elif option in { "-n", "--subtract" }:
            result["subtract_mode"] =  True
         elif option in { "-t", "--tally" }:
            result["tally"] =  arg
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
         sys.stderr.write("do not give additional params at cmdline!\n\n")
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

out_tally =  dctbnbc.tally.Tally()
if cmdline_params["update_mode"]:
   try:
      with open(cmdline_params["tally"]) as fd:
         out_data =  json.load(fd)
   except FileNotFoundError:
      sys.stderr.write("file %s not found.\n" % cmdline_params["tally"])
      sys.exit(2)
   if not out_tally.load(out_data):
      sys.stderr.write("tally file %s could not be opened.\n" % cmdline_params["tally"])
      sys.exit(2)
else:
   out_data =  {}
   out_tally.init()
   out_tally.save(out_data)

try:
   in_data =  json.load(sys.stdin)
except:
   sys.stderr.write("unable to input data through <stdin>.\n")
   sys.exit(2)

in_tally =  dctbnbc.tally.Tally()
if not in_tally.load(in_data):
   sys.stderr.write("json file from <stdin> could not be interpreted as tally file.\n")
   sys.exit(2)

if cmdline_params["subtract_mode"]:
   in_tally.sub_to(out_tally)
else:
   in_tally.add_to(out_tally)

try:
   with open(cmdline_params["tally"], "w") as fd:
      json.dump(out_data, fd, indent = 3, sort_keys = True)
except:
   sys.stderr.write("unable to store tally file %s.\n" % cmdline_params["tally"])
   sys.exit(2)
