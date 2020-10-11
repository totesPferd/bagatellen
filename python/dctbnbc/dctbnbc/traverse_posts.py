import dctbnbc.get_authors
import feedparser
import sys

def transform_entry(entry):
   if isinstance(entry, dict) and "summary" in entry.keys():
      authors_set =  set()
      dctbnbc.get_authors.get_authors_entry(authors_set, entry)
      content =  entry["summary"]
   else:
      sys.stderr.write("misses summary in a feed item from a good site.\n")
      return False

   return True, { "authors": authors_set, "content": content }


def traverse_posts(iAlgo, config):
   retval =  True
   for site in config["good_sites"]:
      if isinstance(site, dict) and "href" in site.keys():
         url =  site["href"]
         fp =  feedparser.parse(url)
         for entry in fp["entries"]:
            retval, feed_item =  transform_entry(entry)
            if not retval:
               break
            iAlgo.push_good_content(feed_item)
      else:
        sys.stderr.write("there are illformed items in good_sites region in config file.\n")
        retval =  False
        break

   if retval:
      for site in config["bad_sites"]:
         if isinstance(site, dict) and "href" in site.keys():
            url =  site["href"]
            fp =  feedparser.parse(url)
            for entry in fp["entries"]:
               retval, feed_item =  transform_entry(entry)
               if not retval:
                  break
               if not feed_item["authors"].isdisjoint(config["bad_guys"]):
                  iAlgo.push_bad_content(feed_item)
         else:
           sys.stderr.write("there are illformed items in bad_sites region in config file.\n")
           retval =  False
           break

   return retval
