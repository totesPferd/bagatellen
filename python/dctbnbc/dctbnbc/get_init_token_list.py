import dctbnbc.state
import getopt
import sys


def print_usage(file):
   file.write("\nUSAGE:\n\n")
   file.write("%s [-h|--help]\n" % sys.argv[0])
   file.write("   write this usage information.\n\n")
   file.write("%s [-u|--update] [{-f|--file} <site_files] ... [{-s|--state} <state_file>] [<feed_url>] ...\n" % sys.argv[0])
   file.write("   provide initial data to <state_file> which can be consumed by dctbnbc.update_token_list program.\n")
   file.write("   default for -s is state.json.\n")
   file.write("   give -u switch for update mode: read from <stdin>.\n")


def interpret_cmdline(result):

   retval =  "OK"

   try:
      optlist, args =  getopt.getopt(sys.argv[1:], "hf:s:u", [ "help", "file", "state", "update" ])

      if "update_mode" not in result:
         result["update_mode"] =  False

      if "files" not in result:
         result["files"] =  []

      if "sites" not in result:
         result["sites"] =  []

      if "state" not in result:
         result["state"] =  "state.json"

      for option, arg in optlist:
         if option in { "-h", "--help" }:
            if retval == "OK":
               print_usage(sys.stdout)
               retval =  "HelpMode"
         elif option in { "-f", "--file" }:
            result["files"].append(arg)
         elif option in { "-s", "--state" }:
            result["state"] =  arg
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
         result["sites"].append( { "href": arg })

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
if cmdline_params["update_mode"]:
   if not state.load():
      sys.stderr.write("state file %s could not be opened.\n" % cmdline_params["state"])
      sys.exit(2)
else:
   if not state.init():
      sys.stderr.write("state file %s could not be inited.\n" % cmdline_params["state"])
      sys.exit(2)

if not state.load_from_cmdline(cmdline_params):
   sys.exit(2)

if not state.close():
   sys.stderr.write("state file %s could not be closed.\n" % cmdline_params["state"])
   sys.exit(2)
