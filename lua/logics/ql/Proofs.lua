local Proof =  require "logics.male.Proof"
local Rules =  require "logics.ql.Rules"

local Proofs =  {}

function Proofs:gen_assumption()
   local retval =  Proof:new()
   retval:add(Rules:gen_refl())
   return retval
end   

return Proofs
