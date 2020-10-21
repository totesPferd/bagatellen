import feedparser

class FeedChannel:

   def __init__(self, authors):
      self.authors =  authors

   def __hash__(self):
      return self.url.__hash__(url)

   def __lt__(self, other):
      return self.url < other.url

   def __le__(self, other):
      return self.url <= other.url

   def __eq__(self, other):
      return self.url == other.url

   def __ge__(self, other):
      return self.url >= other.url

   def __gt__(self, other):
      return self.url > other.url

   def __ne__(self, other):
      return self.url != other.url

   def init(self, url):
      self.url =  url
      self.ids =  set()

   def load(self, d):
      self.url =  d["href"]
      self.ids =  set(d["ids"])

   def save(self, d):
      d["href"] =  self.url
      idl =  list(self.ids)
      idl.sort()
      d["ids"] =  idl

   def get_url(self):
      return self.url

   def is_url(self, url):
      return self.url == url
