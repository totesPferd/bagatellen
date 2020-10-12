def get_score(knowledge, token_list):
   retval =  0

   size =  len(token_list)
   for word in knowledge["scores"].keys():
     if word not in token_list:
        retval =  retval - knowledge["scores"][word] * size

   return retval
