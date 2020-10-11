import dctbnbc.tokenize
import math

class Algorithm:

   def __init__(self):
      self.size_of_bad_posts =  0
      self.size_of_good_posts =  0
      self.used_by_bad_guys =  {}
      self.used_by_good_guys =  {}

   def register_word(self, word_dict, word):
      if word in word_dict.keys():
         word_dict[word] =  word_dict[word] + 1
      else:
         word_dict[word] =  1
   
   def register_content(self, word_dict, content):
      size =  0
      for word in dctbnbc.tokenize.tokenize(content):
         size =  size + len(word)
         self.register_word(word_dict, word)
      return size
   
   def push_bad_content(self, content):
      self.size_of_bad_posts =  self.size_of_bad_posts + self.register_content(self.used_by_bad_guys, content)

   def push_good_content(self, content):
      self.size_of_good_posts =  self.size_of_good_posts + self.register_content(self.used_by_good_guys, content)

   def get_report(self):
      retval =  { "scores": {} }

      retval["used_by_bad_guys_only"] =  [ word for word in self.used_by_bad_guys.keys() if word not in self.used_by_good_guys.keys() ]
      retval["used_by_bad_guys_only"].sort()

      retval["used_by_good_guys_only"] =  [ word for word in self.used_by_good_guys.keys() if word not in self.used_by_bad_guys.keys() ]
      retval["used_by_good_guys_only"].sort()

      for word in [ word for word in self.used_by_bad_guys.keys() if word in self.used_by_good_guys.keys() ]:
         retval["scores"][word] =  math.log(
               (self.size_of_good_posts * (self.size_of_bad_posts - self.used_by_bad_guys[word] * len(word)))
             / (self.size_of_bad_posts * (self.size_of_good_posts - self.used_by_good_guys[word] * len(word))) )


      return retval
