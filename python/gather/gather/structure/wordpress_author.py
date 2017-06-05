import gather.structure.author

class WordpressAuthor(gather.structure.author.Author):

   def __init__(self, id):
      gather.structure.author.Author.__init__(self, name)
      self.id =  id

   def get_id(self):
      return self.id

   def get_wordpress_author(self):
      return self

   def __eq__(self, other):
      other_wordpress_author =  other.get_wordpress_author()
      retval =  false
      if other_wordpress_author:
         retval =  self.get_id() == other_wordpress_author.get_id()
      return retval
