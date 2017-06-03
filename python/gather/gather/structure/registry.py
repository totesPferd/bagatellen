class Registry:

   def __init__(self):
      self.dict =  {}

   def get_entity(self, url):
      return dict[url]

   def store_entity(self, entity):
      local url =  entity.get_url()
      self.dict[url] =  entity
