import dctbnbc.content_grabber
import dctbnbc.feed_grabber
import dctbnbc.tally
import json
import getopt
import sys


def print_usage(file):
   file.write("\nUSAGE:\n\n")
   file.write("%s [-h|--help]\n" % sys.argv[0])
   file.write("   write this usage information.\n\n")
   file.write("%s [-u|--update] [{-f|--file} <site_files] ... [<feed_url>] ...\n" % sys.argv[0])
   file.write("   provide initial data to <stdout> which can be consumed by dctbnbc.update_token_list program.\n")
   file.write("   give -u switch for update mode: read from <stdin>.\n")


def interpret_cmdline(result):

   retval =  "OK"

   try:
      optlist, args =  getopt.getopt(sys.argv[1:], "hf:u", [ "help", "file", "update" ])

      if "update_mode" not in result.keys():
         result["update_mode"] =  False

      if "files" not in result.keys():
         result["files"] =  []

      if "sites" not in result.keys():
         result["sites"] =  []

      for option, arg in optlist:
         if option in { "-h", "--help" }:
            if retval == "OK":
               print_usage(sys.stdout)
               retval =  "HelpMode"
         elif option in { "-f", "--file" }:
            result["files"].append(arg)
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

content_grabber =  dctbnbc.content_grabber.ContentGrabber()
feed_grabber =  dctbnbc.feed_grabber.FeedGrabber()
content_grabber.register_grabber(feed_grabber)
tally =  dctbnbc.tally.Tally()
if cmdline_params["update_mode"]:
   raw_stdin_data =  sys.stdin.read()
   try:
      out_data =  json.loads(raw_stdin_data)
   except json.decoder.JSONDecodeError:
      sys.stderr.write("<stdin> not a json file.\n")
      sys.exit(2)

   errval =  0

   if not content_grabber.load(out_data):
      sys.stderr.write("json file in <stdin> file does not respect schema.\n")
      errval =  2

   if not tally.load(out_data):
      sys.stderr.write("<stdin> json file does not contain absolute key assigning to dict.\n")
      errval =  2

   if errval != 0:
      sys.exit(errval)

else:
   out_data =  {}

   content_grabber.init()
   content_grabber.save(out_data)

   tally.init()
   tally.save(out_data)
   
if not feed_grabber.load_from_cmdline(cmdline_params):
   sys.exit(2)

content_grabber.commit()
print(json.dumps(out_data, indent = 3, sort_keys = True))
