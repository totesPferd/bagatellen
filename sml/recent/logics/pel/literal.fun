use "general/eq_type.sig";
use "logics/literal_equate.sig";
use "logics/polymorphic_container_type.sig";
use "logics/polymorphic_variable.sig";

functor PELLiteral (X:
   sig
      structure C: EqType
      structure Q: LiteralEquate
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
         fun equate(k, l)
           = case (get_val k, get_val l) of
                (Construction(c, alpha, xi), Construction(d, beta, ypsilon))
             => if X.C.eq(c, d)
                then
                  multi_equate((alpha, xi), (beta, ypsilon))
               else
                  false
             |  (Construction(c, alpha, xi), Variable y) =>  false
             |  (Variable x, l)
             => X.PV.set_val l x
         and multi_equate((alpha, xi), (beta, ypsilon))
            =        X.Q.equate (alpha, beta)
               andalso
                     X.PCT.cong equate (xi, ypsilon)
      end

      structure Single =
         struct
            type T =  Construction
            val eq =  eq
            val equate =  equate
         end
      structure Multi =
         struct
            type T =  Construction X.PCT.T 
            val eq =  multi_eq
            val equate =  multi_equate
         end

   end;
