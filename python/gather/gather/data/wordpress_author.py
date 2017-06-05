import gather.data.author

class WordpressAuthor(gather.data.author.Author):

   def __init__(self, id):
      gather.data.author.Author.__init__(self, name)
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
