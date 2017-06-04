class Entity:

   def __init__(self, url, bozo = None):
      self.url =  url
      self.bozo =  bozo
      self.feeds =  set()

   def get_url(self):
      return self.url

   def get_bozo(self):
      return self.bozo

   def add_feed(self, protocol, entity):
      self.feeds.add((protocol, entity))

   def get_feeds(self):
      return self.feeds
