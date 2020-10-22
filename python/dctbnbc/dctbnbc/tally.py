class Tally:

   def init(self):
      self.absolute =  {}

   def load(self, d):
      retval =  "absolute" in d and isinstance(d["absolute"], dict)
      if retval:

         self.absolute =  d["absolute"]

      return retval

   def save(self, d):
      d["absolute"] =  self.absolute

   def val(self, k):
      retval =  0
      if k in self.absolute:
         retval =  self.absolute[k]
      return retval

   def total(self):
      return sum(self.absolute[k] for k in self.absolute)

   def add(self, k, v):
      self.absolute[k] =  self.val(k) + v

   def inc(self, k):
      self.add(k, 1)

   def add_to(self, other):
      for k in self.absolute:
         other.add(k, self.absolute[k])

   def sub_to(self, other):
      for k in self.absolute:
         other.add(k, - self.absolute[k])

   def save_scores(self, result):
      total =  self.total()
      if total != 0:
         result["scores"] =  { token: self.absolute[token] / total for token in self.absolute }

   def total_score(self, knowledge):
      retval =  0
      for token in knowledge["scores"]:
   
         if self.val(token) == 0 or token in knowledge["logscores"]:
            retval =  retval - knowledge["scores"][token] * self.total()
   
         if self.val(token) != 0 and token in knowledge["logscores"]:
            retval =  retval + self.val(token) * knowledge["logscores"][token]
   
      return retval


