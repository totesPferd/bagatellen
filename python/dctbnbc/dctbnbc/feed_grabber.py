import dctbnbc.feed_channel

class FeedGrabber:

   def init(self):
      self.authors =  set()
      self.feeds =  set()

   def load(self, d):
      self.authors =  set(d["authors"])
      for f in d["feeds"]:
         feed =  dctbnbc.feed_channel.FeedChannel(self.authors)
         feed.load(f)
         self.feeds.append(feed)

   def save(self, d):
      authors_list =  list(self.authors)
      authors_list.sort()
      d["authors"] =  authors_list
      self.feeds.sort()
      d["feeds"] =  []
      for feed in self.feeds:
         f =  {}
         feed.save(f)
         d["feeds"].append(f)

   def search_url(self, url):
      for feed in self.feeds:
         if feed.is_url(url):
            return feed

   def config_feeds(self, d):
      for url in d:
         if self.search_url(url) is None:
            feed =  dctbnbc.feed_channel.FeedChannel(self.authors)
            feed.init(url)
            self.feeds.append(feed)

   def load_from_sites_dict(self, d):
      if "authors" in d:
         self.authors =  self.authors | set(d["authors"])
      self.config_feeds(d["sites"])
