def get_score(knowledge, token_list):
   retval =  0

   size =  len(token_list)
   for word in knowledge["scores"].keys():
     nr_of_occurences =  len ([ w for w in token_list if word == w ])
     retval =  retval - nr_of_occurences * knowledge["scores"][word] / size

   return retval
