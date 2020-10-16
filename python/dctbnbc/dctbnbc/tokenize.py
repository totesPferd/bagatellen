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


def tally(tally_sheet, token):
   tally_sheet["nr"] =  tally_sheet["nr"] + 1
   if token in tally_sheet["abundance"]:
      tally_sheet["abundance"][token] =  tally_sheet["abundance"][token] + 1
   else:
      tally_sheet["abundance"][token] =  1


def tally_token_list(tally_sheet, token_list):
   for token in token_list:
      tally(tally_sheet, token)


def score(tally_sheet, knowledge):

   retval =  0
   for token in knowledge["scores"]:

      if token not in tally_sheet["abundance"] or token in knowledge["logscores"]:
         retval =  retval - knowledge["scores"][token] * tally_sheet["nr"]

      if token in tally_sheet["abundance"] and token in knowledge["logscores"]:
         retval =  retval + tally_sheet["abundance"][token] * knowledge["logscores"][token]

   return retval

