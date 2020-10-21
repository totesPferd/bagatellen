import dctbnbc.get_authors
import dctbnbc.tokenize
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
      retval =  "href" in d and "ids" in d and isinstance(d["href"], str) and isinstance(d["ids"], list)
      if retval:

         self.url =  d["href"]
         self.ids =  set(d["ids"])

      return retval

   def save(self, d):
      d["href"] =  self.url
      idl =  list(self.ids)
      idl.sort()
      d["ids"] =  idl

   def is_url(self, url):
      return self.url == url

   def decide_according_to_authors(self, entry):
      retval =  True
   
      if self.authors is not None:
         authors =  set()
         dctbnbc.get_authors.get_authors_entry(authors, entry)
         retval =  not self.authors.isdisjoint(authors)
   
      return retval
   
   def update(self, tally):
      fp =  feedparser.parse(self.url)
      ids =  set()
      for entry in fp["entries"]:
         if self.decide_according_to_authors(entry):
            id_key =  dctbnbc.get_authors.get_id_key(entry)
            if id_key not in self.ids:
               for token in dctbnbc.tokenize.tokenize(entry["summary"]):
                  tally.inc(token)
            ids.add(id_key)
      self.ids.clear()
      self.ids.update(ids)
