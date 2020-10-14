def get_score(knowledge, token_list):
   retval =  0

   size =  len(token_list)
   for token in knowledge["scores"]:
      nr =  1
      for tok in token_list:
         if tok == token:
            nr =  nr + 1
      retval =  retval -  knowledge["scores"][token] * size / nr

   return retval
