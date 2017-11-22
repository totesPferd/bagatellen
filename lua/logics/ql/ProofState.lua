-- ProofState fuer QL zu Kanonen auf Spatzen geschossen
-- anstelle ProofState:get_conclusions() reicht
-- moeglicherweise auch ProofState:get_conclusion()
-- , d.h. anstelle einer Schuessel voll Beweiszielen reicht es,
-- einen Behaelter vorzusehen, der hoechstens ein Beweisziel speichern
-- muss.


local ProofState =  require "logics.male.ProofState"
local ReflRule =  require "logics.ql.rule.Refl"
local TransRule =  require "logics.ql.rule.Trans"

function ProofState:apply_assumptions()
   local retval =  true
   for conclusion in self:get_conclusions():elems()
   do local rule =  ReflRule:new()
      retval =  self:apply_rule(rule, conclusion)
      if not retval
      then
         break
      end
   end
   return retval
end

function ProofState:apply_lhs_literal_tactics(proof)
   local rep =  true
   while rep
   do rep =  false
      for conclusion in self:get_conclusions():elems()
      do local rule =  TransRule:new()
         local success =  self:apply_rule(rule, conclusion)
         if success
         then
            local lhs_literal =  rule:get_lhs_literal()
            local lhs_literal_copy =  proof:search_simply(lhs_literal)
            if lhs_literal_copy
            then
               rep =  true
               break
            end
         end
      end
   end
end

return Proofs
