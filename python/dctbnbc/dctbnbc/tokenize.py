import re

def tokenize(token):
   return re.findall(r'\w+', token)
