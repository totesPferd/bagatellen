import gather.data.author

class GoogleAuthor(gather.data.author.Author):

   def __init__(self, profile, email, name):
      gather.data.author.Author.__init__(self)
      self.profile =  profile
      self.email =  email
      self.name =  name

   def get_profile(self):
      return self.profile

   def get_email(self):
      return self.email

   def get_name(self):
      return self.name

   def get_google_author(self):
      return self

   def __eq__(self, other):
      other_google_author =  other.get_google_author()
      retval =  false
      if other_google_author:
         retval =  self.get_profile() == other.get_profile()
      return retval
