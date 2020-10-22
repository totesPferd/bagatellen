import dctbnbc.state
import getopt
import sys


def print_usage(file):
   file.write("\nUSAGE:\n\n")
   file.write("%s [-h|--help]\n" % sys.argv[0])
   file.write("   write this usage information.\n\n")
   file.write("%s [{-s|--state} <state_file>]\n" % sys.argv[0])
   file.write("   extract abundances of all tokens.\n")
   file.write("   program expects json file in <state_file> and outputs to <state_file>.\n")
   file.write("   <state_file> can be gotten from this program or dctbnbc.get_inital_token_list program.\n")


def interpret_cmdline(result):

   retval =  "OK"

   try:
      optlist, args =  getopt.getopt(sys.argv[1:], "hs:", [ "help", "state" ])

      if "state" not in result:
         result["state"] =  "state.json"

      for option, arg in optlist:
         if option in { "-h", "--help" }:
            if retval == "OK":
               print_usage(sys.stdout)
               retval =  "HelpMode"
         elif option in { "-s", "--state" }:
            result["state"] =  arg
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

state =  dctbnbc.state.State(cmdline_params["state"])
if not state.load():
   sys.stderr.write("state file %s could not be opened.\n" % cmdline_params["state"])
   sys.exit(2)

if not state.update():
   sys.stderr.write("problem during updating state file %s.\n" % cmdline_params["state"])
   sys.exit(2)

if not state.close():
   sys.stderr.write("state file %s could not be closed.\n" % cmdline_params["state"])
   sys.exit(2)
