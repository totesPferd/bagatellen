local Resolve =  require "logics.male.rule.Resolve"

local EqSymm =  Resolve:__new()

package.loaded["logics.pel.rule.EqSymm"] =  EqSymm
local Clause =  require "logics.male.Clause"
local Compound =  require "logics.pel.Compound"
local EqSymbol =  require "logics.pel.EqSymbol"
local List =  require "base.type.List"
local ObjectVariable =  require "logics.pel.ObjectVariable"
local Set =  require "base.type.Set"

function EqSymm:new()
   local var_a =  ObjectVariable:new()
   local var_b =  ObjectVariable:new()
   local eq_symbol =  EqSymbol:new()
   local args_premis =  List:empty_list_factory()
   args:append(var_a)
   args:append(var_b)
   local args_conclusion =  List:empty_list_factory()
   args:append(var_b)
   args:append(var_a)
   local premis =  Compound:new(eq_symbol, args_premis)
   local conclusion =  Compound:new(eq_symbol, args_conclusion)
   local premises =  Set:empty_set_factory()
   premises:add(premis)
   local clause =  Clause:new(premises, conclusion)
   return Resolve.new(self, clause)
end

function EqSymm:get_eq_refl_cast()
end

function EqSymm:get_eq_symm_cast()
   return self
end

function EqSymm:get_eq_trans_cast()
end

function EqSymm:get_eq_cong_cast()
end

function EqSymm:get_strict_cast()
end

return EqSymm
