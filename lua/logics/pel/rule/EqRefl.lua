local Resolve =  require "logics.male.rule.Resolve"

local EqRefl =  Resolve:__new()

package.loaded["logics.pel.rule.EqRefl"] =  EqRefl
local Clause =  require "logics.male.Clause"
local Compound =  require "logics.pel.Compound"
local EqSymbol =  require "logics.pel.EqSymbol"
local List =  require "base.type.List"
local ObjectVariable =  require "logics.pel.ObjectVariable"
local Set =  require "base.type.Set"

function EqRefl:new()
   local var =  ObjectVariable:new()
   local eq_symbol =  EqSymbol:new()
   local args =  List:empty_list_factory()
   args:append(var)
   args:append(var)
   local conclusion =  Compound:new(eq_symbol, args)
   local premises =  Set:empty_set_factory()
   local clause =  Clause:new(premises, conclusion)
   return Resolve:new(clause)
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

return EqRefl
