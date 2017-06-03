class Entity:

   def __init__(self, url, etag = None, bozo = None):
      self.url =  url
      self.etag =  etag
      self.bozo =  bozo
      self.feeds =  set()

   def self:get_url(self):
      return self.url

   def self:get_etag(self):
      return self.etag

   def self:get_bozo(self):
      return self.bozo

   def self.add_feed(self, protocol, url):
      self.feeds.add((protocol, url))

   def get_feeds(self):
      return self.feeds
