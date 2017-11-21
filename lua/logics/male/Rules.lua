local Clause =  require "logics.male.Clause"
local Resolve =  require "logics.male.rule.Resolve"
local Set =  require "base.type.Set"

local Rules =  {}

function Rules:gen_assumption(literal)
   local premises =  Set:empty_set_factory()
   local clause =  Clause:new(premises, literal):devar()
   return Resolve:new(clause)
end

return Rules
