use "logics/constructors.sig";
use "logics/literals.sig";
use "logics/polymorphic_variables.sig";

functor PELLiterals(X:
   sig
      structure C: Constructors
      structure V: PolymorphicVariables
   end ) : Literals =
   struct
      structure Constructors =  X.C
      structure PolymorphicVariables = X.V

      datatype T =  Construction of Constructors.Constructor * T |  Variable of T PolymorphicVariables.Variable
      structure Variables =
         struct
            type T =  T PolymorphicVariables.Variable
            val eq =  PolymorphicVariables.eq
            val copy =  PolymorphicVariables.copy
         end
      fun get_val (p as Construction(c, xi)) =  p
        | get_val (p as Variable x)
        = case (PolymorphicVariables.get_val x) of
             Option.NONE => p
          |  Option.SOME k => get_val k

      fun eq(k, l)
        = case (get_val k, get_val l) of
             (Construction(c, xi), Construction(d, ypsilon))
                => Constructors.eq(c, d) andalso multi_eq(xi, ypsilon)
          |  (Construction(c, xi), Variable y) => false
          |  (Variable x, Construction(d, ypsilon)) => false
          |  (Variable x, Variable y) =>  PolymorphicVariables.eq(x, y)
      and multi_eq(xi, ypsilon) =  eq(xi, ypsilon)

      fun equate(k, l)
        = case (get_val k, get_val l) of
             (Construction(c, xi), Construction(d, ypsilon))
          => if Constructors.eq(c, d)
             then
               multi_equate(xi, ypsilon)
            else
               false
          |  (Construction(c, xi), Variable y) =>  false
          |  (Variable x, l)
          => PolymorphicVariables.set_val l x

      and multi_equate(xi, ypsilon) =  equate(xi, ypsilon)

      fun vmap f (Construction(c, xi)) =  Construction(c, multi_vmap f xi)
        | vmap f (Variable x) =  Variable (f x)
      and multi_vmap f l =  vmap f l

   end;
