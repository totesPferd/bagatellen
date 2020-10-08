use "logics/literals.sig";

signature QualifiedLiterals =
   sig
      include Literals

      structure VSingle:
         sig
            type T

            val eq:     T * T -> bool
            val equate: T * T -> bool
            val vmap:   VariableStructure.Map.Map.T -> T -> T
         end

      sharing VSingle = Variables.Base

   end;
