use "general/eq_type.sig";
use "logics/polymorphic_container_type.sig";
use "logics/polymorphic_variable.sig";

functor PELLiteral (X:
   sig
      structure C: EqType
      structure Q: EqType
      structure PCT: PolymorphicContainerType
      structure PV:  PolymorphicVariable
   end ) =
   struct

      datatype Construction =  Construction of X.C.T * X.Q.T * Construction X.PCT.T | Variable of Construction X.PV.Variable

      local
         fun get_val (p as Construction(c, _, _)) =  p
           | get_val (p as Variable x)
           = case (X.PV.get_val x) of
                Option.NONE => p
             |  Option.SOME k => get_val k
      in
         fun eq(k, l)
           = case ((get_val k), (get_val l)) of
               (Construction(c, alpha, xi), Construction(d, beta, ypsilon))
               => X.C.eq(c, d) andalso multi_eq((alpha, xi), (beta, ypsilon))
             | (Construction(c, alpha, xi), Variable y) => false
             | (Variable x, Construction(d, beta, ypsilon)) => false
             | (Variable x, Variable y) =>  X.PV.eq (x, y)
         and multi_eq ((alpha, xi), (beta, ypsilon))
           =          X.Q.eq (alpha, beta)
               andalso
                      X.PCT.cong eq (xi, ypsilon)
      end

      structure Single =
         struct
            type T =  Construction
            val eq =  eq
         end
      structure Multi =
         struct
            type T =  Construction X.PCT.T 
            val eq =  multi_eq
         end

   end;
