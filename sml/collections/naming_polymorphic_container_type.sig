signature NamingPolymorphicContainerType =
   sig
      type 'a T =  (string Option.option ref * 'a) list
   end;
