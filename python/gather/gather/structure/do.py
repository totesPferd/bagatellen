import feedparser
import gather.structure.bozo
import gather.structure.entity

def get(registry, url):
   retval =  registry.get_entity(url)
   if not(retval):
      d =  feedparser.parse(url)
      bozo =  None
      entity =  None
      if d.bozo == 0:
         entity =  gather.structure.entity.Entity(url, etag, bozo)
         if d.feed.links:
            for link in d.feed.links:
               if link.rel == "alternate":
                  if link.type == "application/atom+xml":
                     entity.add_feed("Atom", link.href)
                  elif link.type == "application/rss+xml":
                     entity.add_feed("RDF", link.href)
      else:
         col =  d.bozo_exception.getColumnNumber()
         line =  d.bozo_exception.getLineNumber()
         msg =  d.bozo_exception.getMessage()
         bozo =  gather.structure.bozo.Bozo(col, line, msg)
      registry.store_entity(entity)
   return retval
   
