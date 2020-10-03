use "probe_1.ml";

structure MyPELLiteralsConstruction =  LiteralsConstruction (
   struct
      structure C =  PELConstructors;
      structure PCT =  NamingPolymorphicContainerType;
      structure PV =  PolymorphicVariables;
   end );

structure MyPELLiteralsBinaryRelation: BaseBinaryRelation =
   struct
      structure Domain =  MyPELLiteralsConstruction.Variables.Base.Single
      structure Relation =
         struct
            type T =  Domain.T * Domain.T -> bool
         end
      fun apply f (x, y) = f (x, y)
      fun get_binary_relation f =  f
   end;

structure MyPELLiteralsMap: BaseMap =
   struct
      structure Start =  MyPELLiteralsConstruction.Variables.Base.Single
      structure End =  MyPELLiteralsConstruction.Variables.Base.Single
      structure Map =
         struct
            type T =  Start.T -> End.T
         end

      fun apply f x =  f x
      fun get_map f =  f
   end;


