local Clause =  require "logics.male.Clause"
local Strict =  Clause:__new()

package.loaded["logics.pel.rule.Strict"] =  Strict
local Compound =  require "logics.pel.Compound"
local DefSymbol =  require "logics.pel.DefSymbol"
local List =  require "base.type.List"
local Set =  require "base.type.Set"
local VarAssgnm =  require "logics.male.VarAssgnm" 
local Variable =  require "logics.pel.Variable"

function Strict:new(symbol, arity, place)
   local conclusion_var
   local args =  List:empty_list_factory()
   for i = 1, arity
   do local var =  Variable:new()
      args:append(var)
      if i == place
      then
         conclusion_var =  var
      end
   end
   local premis_term =  Compound:new(symbol, args)
   local def_symbol =  DefSymbol:new()
   local premis =  Compound:new(def_symbol, premis_term)
   local conclusion =  Compound:new(def_symbol, conclusion_var)
   local premises =  Set:empty_set_factory()
   premises:add(premis)

   return Clause.new(self, premises, conclusion)
end

function Strict:get_eq_refl_cast()
end

function Strict:get_eq_symm_cast()
end

function Strict:get_eq_trans_cast()
end

function Strict:get_eq_cong_cast()
end

function Strict:get_strict_cast()
   return self
end

function Strict:devar()
   local var_assgnm =  VarAssgnm:new()
   local new_premises =  Set:empty_set_factory()
   for premis in self:get_premises():elems()
   do new_premises:add(premis:devar(var_assgnm))
   end
   local new_conclusion =  self:get_conclusion():devar(var_assgnm)
   return Clause.new(self, new_premises, new_conclusion)
end

return Strict
