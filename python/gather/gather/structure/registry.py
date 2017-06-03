class Registry:

   def __init__(self):
      self.dict =  {}

   def get_entity(self, url):
      if url in self.dict.keys():
         return self.dict[url]

   def store_entity(self, entity):
      url =  entity.get_url()
      self.dict[url] =  entity
