def get_score(knowledge, token_list):
   retval =  0

   size =  sum ([ len(token) for token in token_list ])
   for word in knowledge["score"].keys():
     if word not in token_list:
        retval =  retval - knowledge["score"][word] * size

   return retval
