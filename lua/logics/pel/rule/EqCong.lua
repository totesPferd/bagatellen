local Clause =  require "logics.male.Clause"
local EqCong =  Clause:__new()

package.loaded["logics.pel.rule.EqCong"] =  EqCong
local Compound =  require "logics.pel.Compound"
local EqSymbol =  require "logics.pel.EqSymbol"
local List =  require "base.type.List"
local Set =  require "base.type.Set"
local Variable =  require "logics.pel.Variable"

function EqCong:new(symbol, arity)
   local lhs_vars =  List:empty_list_factory()
   local rhs_vars =  List:empty_list_factory()
   local premises =  Set:empty_set_factory()
   local premis_list =  {}
   local eq_symbol =  EqSymbol:new()
   for i = 1, arity
   do local lhs_var =  Variable:new()
      local rhs_var =  Variable:new()
      local eq_args =  List:empty_list_factory()
      eq_args:append(lhs_var)
      eq_args:append(rhs_var)
      lhs_vars:append(lhs_var)
      rhs_vars:append(rhs_var)
      local term =  Compound:new(eq_symbol, eq_args)
      premises:add(term)
      table.insert(premis_list, term)
   end
   local lhs_term =  Compound:new(symbol, lhs_vars)
   local rhs_term =  Compound:new(symbol, rhs_vars)
   local eq_args =  List:empty_list_factory()
   eq_args:append(lhs_term)
   eq_args:append(rhs_term)
   local conclusion =  Compound:new(eq_symbol, eq_args)
   local retval =  Clause.new(self, premises, conclusion)
   retval.premis_list =  premis_list
   return retval
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

function EqCong:get_premis(place)
   return self.premis_list[place]
end

return EqCong
