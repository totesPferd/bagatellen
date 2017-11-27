local Resolve =  require "logics.male.rule.Resolve"

local EqSymm =  Resolve:__new()

package.loaded["logics.pel.rule.EqSymm"] =  EqSymm
local Clause =  require "logics.male.Clause"
local Compound =  require "logics.pel.Compound"
local EqSymbol =  require "logics.pel.EqSymbol"
local List =  require "base.type.List"
local Variable =  require "logics.pel.Variable"
local Set =  require "base.type.Set"

function EqSymm:new()
   local var_a =  Variable:new()
   local var_b =  Variable:new()
   local eq_symbol =  EqSymbol:new()
   local args_premis =  List:empty_list_factory()
   args_premis:append(var_a)
   args_premis:append(var_b)
   local args_conclusion =  List:empty_list_factory()
   args_conclusion:append(var_b)
   args_conclusion:append(var_a)
   local premis =  Compound:new(eq_symbol, args_premis)
   local conclusion =  Compound:new(eq_symbol, args_conclusion)
   local premises =  Set:empty_set_factory()
   premises:add(premis)
   local clause =  Clause:new(premises, conclusion)
   local retval =  Resolve.new(self, clause)
   retval.premis =  premis
   return retval
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

function EqSymm:get_premis()
   return self.premis
end

return EqSymm
