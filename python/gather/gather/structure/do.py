import feedparser
import gather.structure.bozo
import gather.structure.entity

def get(registry, url):
   retval =  registry.get_entity(url)
   if not(retval):
      d =  feedparser.parse(url)
      bozo =  None
      entity =  None
      if d.bozo != 0:
         col =  d.bozo_exception.getColumnNumber()
         line =  d.bozo_exception.getLineNumber()
         msg =  d.bozo_exception.getMessage()
         bozo =  gather.structure.bozo.Bozo(col, line, msg)
      retval =  gather.structure.entity.Entity(url, d.etag, bozo)
      registry.store_entity(retval)
      if d.feed.links:
         for link in d.feed.links:
            if link.rel == "alternate":
               href = get(registry, link.href)
               if link.type == "application/atom+xml":
                  retval.add_feed("Atom", href)
               elif link.type == "application/rss+xml":
                  retval.add_feed("RSS", href)
   return retval
   
