import gather.structure.author

class SimpleAuthor(gather.structure.author.Author):

   def __init__(self, name):
      gather.structure.author.Author.__init__(self)
      self.name =  name

   def get_name(self):
      return self.name

   def get_simple_author(self):
      return self
