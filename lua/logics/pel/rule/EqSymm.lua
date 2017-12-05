local Clause =  require "logics.male.Clause"
local EqSymm =  Clause:__new()

package.loaded["logics.pel.rule.EqSymm"] =  EqSymm
local Compound =  require "logics.pel.Compound"
local EqSymbol =  require "logics.pel.EqSymbol"
local List =  require "base.type.List"
local Set =  require "base.type.Set"
local VarAssgnm =  require "logics.male.VarAssgnm"
local Variable =  require "logics.pel.Variable"

function EqSymm:new()
   local var_a =  Variable:new(true)
   local var_b =  Variable:new(true)
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
   local retval =  Clause.new(self, premises, conclusion)
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

function EqSymm:devar()
   local var_assgnm =  VarAssgnm:new()
   local new_premises =  Set:empty_set_factory()
   for premis in self:get_premises():elems()
   do new_premises:add(premis:devar(var_assgnm))
   end
   local new_conclusion =  self:get_conclusion():devar(var_assgnm)
   return Clause.new(self, new_premises, new_conclusion)
end

return EqSymm
