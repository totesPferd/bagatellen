local Resolve =  require "logics.male.rule.Resolve"

local EqTrans =  Resolve:__new()

package.loaded["logics.pel.rule.EqTrans"] =  EqTrans
local Clause =  require "logics.male.Clause"
local Compound =  require "logics.pel.Compound"
local EqSymbol =  require "logics.pel.EqSymbol"
local List =  require "base.type.List"
local MetaVariable =  require "logics.pel.MetaVariable"
local ObjectVariable =  require "logics.pel.ObjectVariable"
local Set =  require "base.type.Set"

function EqTrans:new()
   local var_a =  ObjectVariable:new()
   local var_b =  MetaVariable:new()
   local var_c =  ObjectVariable:new()
   local eq_symbol =  EqSymbol:new()
   local args_lhs_premis =  List:empty_list_factory()
   args_lhs_premis:append(var_a)
   args_lhs_premis:append(var_b)
   local args_rhs_premis =  List:empty_list_factory()
   args_rhs_premis:append(var_b)
   args_rhs_premis:append(var_c)
   local args_conclusion =  List:empty_list_factory()
   args_conclusion:append(var_a)
   args_conclusion:append(var_c)
   local lhs_premis =  Compound:new(eq_symbol, args_lhs_premis)
   local rhs_premis =  Compound:new(eq_symbol, args_rhs_premis)
   local conclusion =  Compound:new(eq_symbol, args_conclusion)
   local premises =  Set:empty_set_factory()
   premises:add(lhs_remis)
   premises:add(rhs_remis)
   local clause =  Clause:new(premises, conclusion)
   return Resolve.new(self, clause)
end

function EqTrans:get_eq_refl_cast()
end

function EqTrans:get_eq_symm_cast()
end

function EqTrans:get_eq_trans_cast()
   return self
end

function EqTrans:get_eq_cong_cast()
end

function EqTrans:get_strict_cast()
end

return EqTrans
