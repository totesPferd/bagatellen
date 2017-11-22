local ProofState =  require "logics.male.ProofState"
local Rules =  require "logics.ql.Rules"

function ProofState:apply_assumptions()
   local retval =  true
   for conclusion in self:get_conclusions():elems()
   do local rule =  Rules:gen_refl()
      retval =  self:apply_rule(rule, conclusion)
      if not retval
      then
         break
      end
   end
   return retval
end

return Proofs
