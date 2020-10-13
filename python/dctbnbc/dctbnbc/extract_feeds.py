import getopt
import html.parser
import json
import requests
import sys
import urllib.parse


def print_usage(file):
   file.write("\nUSAGE:\n\n")
   file.write("%s [-h|--help]\n" % sys.argv[0])
   file.write("   write this usage information.\n\n")
   file.write("%s [<base_url>] ...\n" % sys.argv[0])
   file.write("   extract feed data related to <base_url>.\n")


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
            retval =  "Error"
   
      for arg in args:
         result["urls"].append(arg)

   except getopt.GetoptError as err:
      sys.stderr.write("%s\n\n" % str(err))
      retval =  "Error"

   if retval == "Error":
      print_suage(sys.stderr)
   
   return retval


class MyHTMLParser(html.parser.HTMLParser):

   def __init__(self, base_url, result):
      html.parser.HTMLParser.__init__(self)
      self.base_url =  base_url
      self.result =  result

   def handle_starttag(self, tag, attrs):
      if tag == "link":
         feed_info =  {}
         rel =  False
         for (k, v) in attrs:
            if k == "href":
               feed_info["href"] =  urllib.parse.urljoin(self.base_url, v)
            elif k == "title":
               feed_info["title"] =  v
            elif k == "type":
               feed_info["type"] =  v
            elif k == "rel" and v == "alternate":
               rel =  True
         if rel and "type" in feed_info.keys() and feed_info["type"] in { "application/atom+xml", "application/rdf+xml", "application/rss+xml" }:
            self.result.append(feed_info)


# interprete cmdline.
url_list =  {}
retval =  interpret_cmdline(url_list)
if retval == "Error":
   sys.exit(2)
elif retval == "HelpMode":
   sys.exit(0)

feed_list =  []
for url in url_list["urls"]:
   try:
      r =  requests.get(url)
      hp =  MyHTMLParser(url, feed_list)
      hp.feed(r.text)
   except requests.exceptions.ConnectionError:
      sys.stderr.write("failed to establish connection to %s.\n" % url)
      sys.exit(2)
   except requests.exceptions.Timeout:
      sys.stderr.write("connection (%s) time out.\n" % url)
      sys.exit(2)
   except requests.exceptions.TooManyRedirects:
      sys.stderr.write("too many redirects (%s).\n" % url)

result =  { "feeds": feed_list }
print(json.dumps(result, indent = 3, sort_keys = True))
