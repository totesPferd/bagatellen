local Clause =  require "logics.male.Clause"
local EqTrans =  Clause:__new()

package.loaded["logics.pel.rule.EqTrans"] =  EqTrans
local Compound =  require "logics.pel.Compound"
local EqSymbol =  require "logics.pel.EqSymbol"
local List =  require "base.type.List"
local Set =  require "base.type.Set"
local Variable =  require "logics.pel.Variable"

function EqTrans:new(lhs, rhs)
   local var_a =  Variable:new()
   local var_b =  Variable:new()
   local var_c =  Variable:new()
   local eq_symbol =  EqSymbol:new()
   local args_lhs_premis =  List:empty_list_factory()
   args_lhs_premis:append(var_a)
   args_lhs_premis:append(var_b)
   local args_rhs_premis =  List:empty_list_factory()

   local success =  true
   success =  success and args_lhs_premis:equate(lhs)
   success =  success and args_rhs_premis:equate(rhs)

   if success
   then
      args_rhs_premis:append(var_b)
      args_rhs_premis:append(var_c)
      local args_conclusion =  List:empty_list_factory()
      args_conclusion:append(var_a)
      args_conclusion:append(var_c)
      local lhs_premis =  Compound:new(eq_symbol, args_lhs_premis)
      local rhs_premis =  Compound:new(eq_symbol, args_rhs_premis)
      local conclusion =  Compound:new(eq_symbol, args_conclusion)
      local premises =  Set:empty_set_factory()
      premises:add(lhs_premis)
      premises:add(rhs_premis)
      local retval =  Clause.new(self, premises, conclusion)
      retval.lhs_premis =  lhs_premis
      retval.rhs_premis =  rhs_premis
      return retval
   end
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

function EqTrans:get_lhs_premis()
   return self.lhs_premis
end

function EqTrans:get_rhs_premis()
   return self.rhs_premis
end

return EqTrans
