import feedparser
import gather.structure.bozo
import gather.structure.entity

def get(registry, url):
   retval =  registry.get_entity(url)
   if not(retval):
      d =  feedparser.parse(url)
      entity =  None
      bozo =  gather.structure.bozo.from_feed_object(d)
      retval =  gather.structure.entity.Entity(url, bozo)
      registry.store_entity(retval)
      if d.feed.links:
         for link in d.feed.links:
            if link.rel == "alternate":
               href = get(registry, link.href)
               if link.type == "application/atom+xml":
                  retval.add_feed("Atom", href)
               elif link.type == "application/rss+xml":
                  retval.add_feed("RSS", href)
               elif link.type == "text/xml":
                  retval.add_feed("RDF", href)
   return retval
   
