import gather.data.author

class SimpleAuthor(gather.data.author.Author):

   def __init__(self, name):
      gather.data.author.Author.__init__(self)
      self.name =  name

   def get_name(self):
      return self.name

   def get_simple_author(self):
      return self
