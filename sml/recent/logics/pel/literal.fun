use "general/eq_type.sig";
use "logics/literal.sig";
use "logics/literal_equate.sig";
use "logics/multi_literal.sig";
use "logics/polymorphic_container_type.sig";
use "logics/polymorphic_variable.sig";

functor PELLiteral (X:
   sig
      structure C: EqType
      structure Q: Literal
      structure PCT: PolymorphicContainerType
      structure PV:  PolymorphicVariable
   end ): Literal =
   struct

      datatype Construction =  Construction of X.C.T * X.Q.Single.T * Construction X.PCT.T | Variable of Construction X.PV.Variable

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
               => X.C.eq(c, d) andalso X.Q.Single.eq (alpha, beta) andalso multi_eq(xi, ypsilon)
             | (Construction(c, alpha, xi), Variable y) => false
             | (Variable x, Construction(d, beta, ypsilon)) => false
             | (Variable x, Variable y) =>  X.PV.eq (x, y)
         and multi_eq (xi, ypsilon)
           = X.PCT.cong eq (xi, ypsilon)
         fun equate(k, l)
           = case (get_val k, get_val l) of
                (Construction(c, alpha, xi), Construction(d, beta, ypsilon))
             => X.C.eq(c, d) andalso X.Q.Single.equate(alpha, beta) andalso multi_equate(xi, ypsilon)
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
         end
      structure Multi: MultiLiteral =
         struct
            type T =  Construction X.PCT.T 
            val eq =  multi_eq
            val equate =  multi_equate

            val empty =  X.PCT.empty
            val is_empty =  X.PCT.is_empty
         end

      val is_in =  X.PCT.is_in Single.eq
      val subeq =  X.PCT.subeq Single.eq

      fun lift f =  X.PCT.lift f

      structure VariableContext: EqType =
         struct
            type T =  X.Q.VariableContext.T * Construction X.PV.Variable X.PCT.T
            fun eq((q1, v1), (q2, v2)) =  X.Q.VariableContext.eq(q1, q2) andalso (X.PCT.cong X.PV.eq) (v1, v2)
         end
      type variableMap_t =  X.Q.variableMap_t * (Construction X.PV.Variable -> Construction X.PV.Variable)
      val copy =  (X.Q.copy, X.PV.copy)
      fun context_alpha_transform (fq, fx) (cq, cx) =  (X.Q.context_alpha_transform fq cq, X.PCT.map fx cx)
      fun single_alpha_transform (fq, fx) (Construction (c, q, xi)) =  Construction (c, X.Q.single_alpha_transform fq q, multi_alpha_transform (fq, fx) xi)
        | single_alpha_transform (fq, fx) (Variable x) =  Variable (fx x)
      and multi_alpha_transform phi =  X.PCT.map (single_alpha_transform phi)

      type alphaTransform_t =  X.Q.alphaTransform_t * Construction X.PV.Variable X.PCT.T * Construction X.PV.Variable X.PCT.T
      fun make_alpha_transform ((vcq, vcx), (fq, mx)) =  (
            X.Q.make_alpha_transform (vcq, fq)
         ,  vcx
         ,  X.PCT.map mx vcx )
      fun get_alpha_transform (aq, vm_1, vm_2) =  (
            X.Q.get_alpha_transform aq
         ,  X.PCT.get_alpha_transform X.PV.eq (vm_1, vm_2) )

   end;
