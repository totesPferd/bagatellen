local MALESimpleProof =  require "logics.male.SimpleProof"
local SimpleProof =  MALESimpleProof:__new()

package.loaded["logics.ql.SimpleProof"] =  SimpleProof
local TransRule =  require "logics.ql.simple_rule.Trans"

function SimpleProof:new()
   return MALESimpleProof.new(self)
end

function SimpleProof:add_literal(literal)
   return self:add_rule(TransRule:new(literal))
end

return SimpleProof
