import dctbnbc.feed_channel
import json
import sys

class FeedGrabber:

   def __init__(self):
      self.authors =  None
      self.feeds =  set()
      self.out_data =  None

   def init(self):
      pass

   def load(self, d):
      retval =  "feeds" in d and isinstance(d["feeds"], list)
      if retval:

         if "authors" in d:
            self.authors =  set(d["authors"])
         for f in d["feeds"]:
            feed =  dctbnbc.feed_channel.FeedChannel(self.authors)
            feed.load(f)
            self.feeds.add(feed)
         self.save(d)

      return retval

   def save(self, d):
      self.out_data =  d

   def commit(self):

      if self.authors is not None:
         self.out_data["authors"] =  list(self.authors)
         self.out_data["authors"].sort()

      feed_list =  list(self.feeds)
      feed_list.sort()
      self.out_data["feeds"] =  []
      for feed in feed_list:
         f =  {}
         feed.save(f)
         feed.commit()
         self.out_data["feeds"].append(f)

   def search_url(self, url):
      for feed in self.feeds:
         if feed.is_url(url):
            return feed

   def add_url(self, url):
      if self.search_url(url) is None:
         feed =  dctbnbc.feed_channel.FeedChannel(self.authors)
         feed.init(url)
         self.feeds.add(feed)

   def config_feeds(self, d):
      retval =  True

      for u in d:
         if "href" in u:
            self.add_url(u["href"])
         else:
            retval =  False
            sys.stderr.write("href key missing in some sites.\n")

      return retval

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

   def load_from_cmdline(self, cmdline_params):
      retval =  True

      self.config_feeds(cmdline_params["sites"])
      for site_file in cmdline_params["files"]:
         with open(site_file) as fd:
            json_data =  json.load(fd)
            if not self.load_from_sites_dict(json_data):
               retval =  False
               sys.stderr.write("file %s has no sites key\n")

      return retval

   def update(self, tally):
      for feed in self.feeds:
         feed.update(tally)
