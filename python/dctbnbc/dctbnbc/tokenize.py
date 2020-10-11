import re

def tokenize(content):
   return re.findall(r'\w+', content)
