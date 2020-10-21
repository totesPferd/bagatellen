import dctbnbc.feed_channel

class FeedGrabber:

   def init(self):
      self.authors =  None
      self.feeds =  set()

   def load(self, d):
      retval =  "feeds" in d and isinstance(d["feeds"], dict)
      if retval:

         if "authors" in d:
            self.authors =  set(d["authors"])
         for f in d["feeds"]:
            feed =  dctbnbc.feed_channel.FeedChannel(self.authors)
            feed.load(f)
            self.feeds.add(feed)

      return retval

   def save(self, d):
      if self.authors is not None:
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
      retval =  "sites" in d and isinstance(d["sites"], list)
      if retval:

         if "authors" in d:
            if self.authors is None:
               self.authors =  set(d["authors"])
            else:
               self.authors.update(set(d["authors"]))
         self.config_feeds(d["sites"])

      return retval
