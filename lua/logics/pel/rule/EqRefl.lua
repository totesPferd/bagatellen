local Clause =  require "logics.male.Clause"
local EqRefl =  Clause:__new()

package.loaded["logics.pel.rule.EqRefl"] =  EqRefl
local Compound =  require "logics.pel.Compound"
local EqSymbol =  require "logics.pel.EqSymbol"
local List =  require "base.type.List"
local Set =  require "base.type.Set"
local VarAssgnm =  require "logics.male.VarAssgnm"
local Variable =  require "logics.pel.Variable"

function EqRefl:new()
   local var =  Variable:new()
   local eq_symbol =  EqSymbol:new()
   local args =  List:empty_list_factory()
   args:append(var)
   args:append(var)
   local conclusion =  Compound:new(eq_symbol, args)
   local premises =  Set:empty_set_factory()
   return Clause.new(self, premises, conclusion)
end

function EqRefl:get_eq_refl_cast()
   return self
end

function EqRefl:get_eq_symm_cast()
end

function EqRefl:get_eq_trans_cast()
end

function EqRefl:get_eq_cong_cast()
end

function EqRefl:get_strict_cast()
end

function EqRefl:devar()
   local var_assgnm =  VarAssgnm:new()
   local new_premises =  Set:empty_set_factory()
   for premis in self:get_premises():elems()
   do new_premises:add(premis:devar(var_assgnm))
   end
   local new_conclusion =  self:get_conclusion():devar(var_assgnm)
   return Clause.new(self, new_premises, new_conclusion)
end

return EqRefl
