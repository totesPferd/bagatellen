local SimpleProofState =  require "logics.male.SimpleProofState"
local ReflRule =  require "logics.ql.simple_rule.Refl"
local TransRule =  require "logics.ql.simple_rule.Trans"

function SimpleProofState:apply_assumptions()
   local rule =  ReflRule:new()
   self:apply_rule(rule, self:get_conclusion())
end

function SimpleProofState:apply_literal_tactics(literals)
   local rep =  true
   local conclusion =  self:get_conclusion()
   while rep
   do rep =  false
      for literal in literals:elems()
      do local rule =  TransRule:new(literal):devar()
         local success =  self:apply_rule(rule, conclusion)
         if success
         then
            rep =  true
            break
         end
      end
   end
end

function SimpleProofState:normalize(literals)
   self:apply_literal_tactics(literals)
   self:apply_assumptions()
end

function SimpleProofState:add_literal(literals)
   self:normalize(literals)
   local conclusion =  self:get_conclusion()
   if conclusion
   then
      literals:add(self:get_conclusion())
   end
end

return SimpleProofState
