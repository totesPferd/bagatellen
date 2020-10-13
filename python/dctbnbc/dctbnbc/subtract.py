import getopt
import json
import sys

def print_usage(file):
   file.write("\nUSAGE:\n\n")
   file.write("%s [-h|--help]\n" % sys.argv[0])
   file.write("   write this usage information.\n\n")
   file.write("%s -a <minuend> -b <subtrahend>\n" % sys.argv[0])
   file.write("   <minuend> and <subtrahend> are knowledge files.  It subtracts second one from fist one and puts the result onto stdout.\n")

def interpret_cmdline(result):

   retval =  "OK"

   try:
      optlist, args =  getopt.getopt(sys.argv[1:], "ha:b:", [ "help" ])

      for option, arg in optlist:
         if option in { "-h", "--help" }:
            if retval != "OK":
               print_usage(sys.stdout)
               retval =  "HelpMode"
         elif option == "-a":
            if "minuend" in result:
               sys.stderr.write("use -a only once!\n")
               retval =  "Error"
            else:
               result["minuend"] =  arg
         elif option == "-b":
            if "subtrahend" in result:
               sys.stderr.write("use -b only once!\n")
               retval =  "Error"
            else:
               result["subtrahend"] =  arg
         else:
            sys.stderr.write("option %s not permitted.\n" % option)
            print_usage(sys.stderr)
            retval =  "Error"

      if len(args) != 0:
         sys.stderr.write("no other cmdline args as -a und -b permitted.\n")
         retval =  "Error"

      if "minuend" not in result:
         sys.stderr.write("give -a switch!  It is mandatory!\n")
         retval =  "Error"

      if "subtrahend" not in result:
         sys.stderr.write("give -b switch!  It is mandatory!\n")
         retval =  "Error"


   except getopt.GetoptError as err:
      sys.stderr.write("%s\n\n" % str(err))
      retval =  "Error"

   if retval == "Error":
      print_usage(sys.stderr)

   return retval


def doit(json_a_data, json_b_data):
   out =  { "scores": {} }

   for token in json_a_data["scores"]:
      if token in json_b_data["scores"]:
         out["scores"][token] =  json_a_data["scores"][token] - json_b_data["scores"][token]
      else:
         out["scores"][token] =  json_a_data["scores"][token]

   for token in json_b_data["scores"]:
      if token not in out["scores"]:
         out["scores"][token] =  - json_b_data["scores"][token]

   print(json.dumps(out, sort_keys = True, indent = 3))


# interprete cmdline.
cmdline_params =  {}
retval =  interpret_cmdline(cmdline_params)
if retval == "Error":
   sys.exit(2)
elif retval == "HelpMode":
   sys.exit(0)


retval =  0
try:
   with open(cmdline_params["minuend"]) as fda:
      raw_a_data =  fda.read()
      json_a_data =  json.loads(raw_a_data)
      if "scores" not in json_a_data or not isinstance(json_a_data["scores"], dict):
         sys.stderr.write("%s given in -a cmdline param contains no json with scores key assigned to a dict.\n" % cmdline_params["minuend"])
         retval =  2
      else:
         try:
            with open(cmdline_params["subtrahend"]) as fdb:
               raw_b_data =  fdb.read()
               json_b_data =  json.loads(raw_b_data)
         
               if "scores" not in json_b_data or not isinstance(json_b_data["scores"], dict):
                  sys.stderr.write("%s given in -b cmdline param contains no json with scores key assigned to a dict.\n" % cmdline_params["subtrahend"])
                  retval =  2
               else:
                  doit(json_a_data, json_b_data)
         except FileNotFoundError:
            sys.stderr.write("file %s given in -b cmdline param  not found.\n" % cmdline_params["subtrahend"])
            retval =  2
except FileNotFoundError:
   sys.stderr.write("file %s given in -a cmdline param not found.\n" % cmdline_params["minuend"])
   retval =  2

sys.exit(retval)
