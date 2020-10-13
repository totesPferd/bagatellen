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


# interprete cmdline.
cmdline_params =  {}
retval =  interpret_cmdline(cmdline_params)
if retval == "Error":
   sys.exit(2)
elif retval == "HelpMode":
   sys.exit(0)



