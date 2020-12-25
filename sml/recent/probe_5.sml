use "general/canonical_eq_type.fun";
use "general/item.sml";
use "logics/pel/constructor.sml";
use "logics/ql/constructor.fun";

structure PELEqType =  CanonicalEqType(
   struct
      type T =  PELConstructor.T
   end );

structure MyQLConstructor =  QLConstructor(
   struct
      structure M =  Item
      structure Q =  Item
   end);

structure QLEqType =  CanonicalEqType(
   struct
      type T =  MyQLConstructor.T
   end );
