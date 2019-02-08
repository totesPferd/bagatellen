structure Iterations =
   struct
      fun repeat phi x
        = case (phi x) of
             { is_loop = true, state = x' }
             => repeat phi x'
           | { is_loop = false, state = x' }
             => x'
   end;
