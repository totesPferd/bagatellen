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
