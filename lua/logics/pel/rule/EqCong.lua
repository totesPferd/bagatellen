local Resolve =  require "logics.male.rule.Resolve"

local EqCong =  Resolve:__new()

package.loaded["logics.pel.rule.EqCong"] =  EqCong
local Clause =  require "logics.male.Clause"
local Compound =  require "logics.pel.Compound"
local EqSymbol =  require "logics.pel.EqSymbol"
local List =  require "base.type.List"
local ObjectVariable =  require "logics.pel.ObjectVariable"
local Set =  require "base.type.Set"

function EqCong:new(symbol, arity)
   lhs_vars =  List:empty_list_factory()
   rhs_vars =  List:empty_list_factory()
   premises =  Set:empty_set_factory()
   local eq_symbol =  EqSymbol:new()
   for i = 1, arity
   do local lhs_var =  ObjectVariable:new()
      local rhs_var =  ObjectVariable:new()
      local eq_args =  List:empty_list_factory()
      eq_args:append(lhs_var)
      eq_args:append(rhs_var)
      lhs_vars:append(lhs_var)
      rhs_vars:append(rhs_var)
      premises:add(Compound:new(eq_symbol, eq_args))
   end
   local lhs_term =  Compound:new(symbol, lhs_vars)
   local rhs_term =  Compound:new(symbol, rhs_vars)
   local eq_args =  List:empty_list_factory()
   eq_args:append(lhs_term)
   eq_args:append(rhs_term)
   local conclusion =  Compound:new(eq_symbol, eq_args)
   local clause =  Clause:new(premises, conclusion)
   return Resolve.new(self, clause)
end

function EqCong:get_eq_refl_cast()
end

function EqCong:get_eq_symm_cast()
end

function EqCong:get_eq_trans_cast()
end

function EqCong:get_eq_cong_cast()
   return self
end

function EqCong:get_strict_cast()
end

return EqCong
