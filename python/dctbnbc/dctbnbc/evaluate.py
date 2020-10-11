import dctbnbc.tokenize


def refused_to_be_a_bad_guy(knowledge, content):
   retval =  False
   for word in dctbnbc.tokenize.tokenize(content):
      if word in knowledge["used_by_good_guys_only"]:
         retval =  True
         break

   return retval


def refused_to_be_a_good_guy(knowledge, content):
   retval =  False
   for word in dctbnbc.tokenize.tokenize(content):
      if word in knowledge["used_by_bad_guys_only"]:
         retval =  True
         break

   return retval


def get_score(knowledge, content):
   retval =  0

   token_list =  dctbnbc.tokenize.tokenize(content)
   size =  len(content)
   for word in knowledge["score"].keys():
     if word not in token_list:
        retval =  retval - knowledge["score"][word] * size / len(content)

   return retval
