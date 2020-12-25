use "general/eq_type.sig";
use "logics/literal_equate.sig";
use "logics/multi_literal.sig";
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
               => X.C.eq(c, d) andalso X.Q.eq (alpha, beta) andalso multi_eq(xi, ypsilon)
             | (Construction(c, alpha, xi), Variable y) => false
             | (Variable x, Construction(d, beta, ypsilon)) => false
             | (Variable x, Variable y) =>  X.PV.eq (x, y)
         and multi_eq (xi, ypsilon)
           = X.PCT.cong eq (xi, ypsilon)
         fun equate(k, l)
           = case (get_val k, get_val l) of
                (Construction(c, alpha, xi), Construction(d, beta, ypsilon))
             => X.C.eq(c, d) andalso X.Q.equate(alpha, beta) andalso multi_equate(xi, ypsilon)
             |  (Construction(c, alpha, xi), Variable y) =>  false
             |  (Variable x, l)
             => X.PV.set_val l x
         and multi_equate(xi, ypsilon)
           = X.PCT.cong equate (xi, ypsilon)
      end

      structure Single: LiteralEquate =
         struct
            type T =  Construction
            val eq =  eq
            val equate =  equate

            structure Variable: Variable =
               struct
                  type T =  X.Q.Variable.T * Construction X.PV.Variable
                  fun copy (q, x) =  (X.Q.Variable.copy q, X.PV.copy x)
               end

         end
      structure Multi: MultiLiteral =
         struct
            type T =  Construction X.PCT.T 
            val eq =  multi_eq
            val equate =  multi_equate

            structure Variable: Variable =
               struct
                  type T =  X.Q.Variable.T X.PCT.T * Single.Variable.T X.PCT.T
                  fun copy (q, x) =  (X.PCT.map X.Q.Variable.copy q, X.PCT.map Single.Variable.copy x)
               end

            val empty =  X.PCT.empty
            val is_empty =  X.PCT.is_empty
         end

   end;
