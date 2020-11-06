use "general/item.sig";

functor QLConstructor (X:
   sig
      structure M: Item
      structure Q: Item
   end ) =
   struct
      datatype T =  Module of X.M.T | Qualifier of X.Q.T
   end;
