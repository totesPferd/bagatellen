import html.parser
import re

class MyHTMLParser(html.parser.HTMLParser):

   def __init__(self, result):
      html.parser.HTMLParser.__init__(self)
      self.result =  result

   def handle_data(self, data):
      self.result =  self.result + data

   def get_result(self):
      return self.result


def tokenize(text):
   p =  MyHTMLParser("")
   p.feed(text)
   r =  p.get_result()
   return re.findall(r'\w+', r)


def tally(process_data, token):
   process_data["nr"] =  process_data["nr"] + 1
   if token in process_data["abundance"]:
      process_data["abundance"][token] =  process_data["abundance"][token] + 1
   else:
      process_data["abundance"][token] =  1
