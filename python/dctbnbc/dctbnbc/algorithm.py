import dctbnbc.tokenize
import math

def register_word(word_dict, word):
   if word in word_dict.keys():
      word_dict[word] =  word_dict[word] + 1
   else:
      word_dict[word] =  1

def register_content(word_dict, content):
   for word in dctbnbc.tokenize.tokenize(content):
      self.register_word(word_dict, word)


class Algorithm:

   def __init__(self):
      self.nr_of_bad_posts =  0
      self.nr_of_good_posts =  0
      self.used_by_bad_guys =  {}
      self.used_by_good_guys =  {}

   def push_bad_content(self, content):
      self.nr_of_bad_posts =  self.nr_of_bad_posts + 1
      register_content(self.used_by_bad_guys, content)

   def push_good_content(self, content):
      self.nr_of_good_posts =  self.nr_of_good_posts + 1
      register_content(self.used_by_good_guys, content)

   def get_report(self):
      retval =  { "scores": {} }

      retval["used_by_bad_guys_only"] =  [ word for word in self.used_by_bad_guys.keys() if word not in self.used_by_good_guys.keys() ]
      retval["used_by_bad_guys_only"].sort()

      retval["used_by_good_guys_only"] =  [ word for word in self.used_by_good_guys.keys() if word not in self.used_by_bad_guys.keys() ]
      retval["used_by_good_guys_only"].sort()

      for word in [ word for word in self.used_by_bad_guys.keys() if word in self.used_by_good_guys.keys() ]:
         retval["scores"][word] =  math.log(
               (self.used_by_good_guys[word] * self.nr_of_bad_posts) / (self.used_by_bad_guys[word] * self.nr_of_good_posts) )


      return retval
