import dctbnbc.tokenize
import math

class Algorithm:

   def __init__(self):
      self.size_of_bad_posts =  0
      self.size_of_good_posts =  0
      self.used_by_bad_guys =  {}
      self.used_by_good_guys =  {}

   def register_word(self, word_dict, word):
      s =  len(word)
      if word in word_dict.keys():
         word_dict[word] =  word_dict[word] + s
      else:
         word_dict[word] =  s
   
   def register_content(self, word_dict, content):
      size =  0
      for word in dctbnbc.tokenize.tokenize(content["content"]):
         size =  size + len(word)
         self.register_word(word_dict, word)
      return size
   
   def push_bad_content(self, content):
      self.size_of_bad_posts =  self.size_of_bad_posts + self.register_content(self.used_by_bad_guys, content)

   def push_good_content(self, content):
      self.size_of_good_posts =  self.size_of_good_posts + self.register_content(self.used_by_good_guys, content)

   def get_word_set(self):
      return set(self.used_by_bad_guys.keys()) | set(self.used_by_good_guys.keys())

   def get_presence_of_bad_guy_words(self, word):
      retval =  self.size_of_bad_posts 
      if word in self.used_by_bad_guys.keys():
         retval =  retval - self.used_by_bad_guys[word]

      return retval

   def get_presence_of_good_guy_words(self, word):
      retval =  self.size_of_good_posts
      if word in self.used_by_good_guys.keys():
         retval =  retval - self.used_by_good_guys[word]

      return retval
   
   def get_report(self):
      retval =  { "scores": {} }

      word_set =  self.get_word_set()
      for word in word_set:
         retval["scores"][word] =  math.log(
               (self.size_of_good_posts * self.get_presence_of_bad_guy_words(word))
             / (self.size_of_bad_posts * self.get_presence_of_good_guy_words(word)) )


      return retval
