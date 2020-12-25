use "general/eq_type.sig";
use "logics/literal_equate.sig";
use "logics/multi_literal.sig";
use "logics/polymorphic_container_type.sig";
use "logics/polymorphic_variable.sig";

functor QLLiteral (X:
   sig
      structure C: EqType
      structure PCT: PolymorphicContainerType
      structure PV:  PolymorphicVariable
   end ) =
   struct

      datatype Construction =  Construction of X.C.T * Construction X.PCT.T | Variable of Construction X.PV.Variable

      local
         fun get_val (p as Construction(c, xi)) =  p
           | get_val (p as Variable x)
           = case (X.PV.get_val x) of
                Option.NONE => p
             |  Option.SOME k => get_val k
      in
         fun eq(k, l)
           = case ((get_val k), (get_val l)) of
               (Construction(c, xi), Construction(d, ypsilon))
               => X.C.eq(c, d) andalso multi_eq(xi, ypsilon)
             | (Construction(c, xi), Variable y) => false
             | (Variable x, Construction(d, ypsilon)) => false
             | (Variable x, Variable y) =>  X.PV.eq (x, y)
         and multi_eq (xi, ypsilon) =  X.PCT.cong eq (xi, ypsilon)
         fun equate(k, l)
           = case (get_val k, get_val l) of
                (Construction(c, xi), Construction(d, ypsilon))
             => if X.C.eq(c, d)
                then
                  multi_equate(xi, ypsilon)
               else
                  false
             |  (Construction(c, xi), Variable y) =>  false
             |  (Variable x, l)
             => X.PV.set_val l x
         and multi_equate(xi, ypsilon) =  X.PCT.cong (equate) (xi, ypsilon)

      end

      structure Single: LiteralEquate =
         struct
            type T =  Construction
            val eq =  eq
            val equate =  equate

            structure Variable: Variable =
               struct
                  type T =  Construction X.PV.Variable
                  val copy =  X.PV.copy
               end

         end
      structure Multi: MultiLiteral =
         struct
            type T =  Construction X.PCT.T 
            val eq =  multi_eq
            val equate =  multi_equate

            structure Variable: Variable =
               struct
                  type T =  Single.Variable.T X.PCT.T
                  val copy =  X.PCT.map Single.Variable.copy
               end

            val empty =  X.PCT.empty
            val is_empty =  X.PCT.is_empty
         end

   end;
