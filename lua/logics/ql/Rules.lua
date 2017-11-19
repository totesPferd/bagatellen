local Clause =  require "logics.male.Clause"
local MetaVariable =  require "logics.qualifier.MetaVariable"
local ObjectVariable =  require "logics.qualifier.ObjectVariable"
local Resolve =  require "logics.male.rule.Resolve"
local Set =  require "base.type.Set"
local ToLiteral =  require "logics.ql.ToLiteral"

local function gen_refl()
   local var =  ObjectVariable:new()
   local conclusion =  ToLiteral:new(var, var)
   local premises =  Set:empty_set_factory()
   local clause =  Clause:new(premises, conclusion)
   return Resolve:new(clause)
end

local function gen_trans()
   local lhs_var =  ObjectVariable:new()
   local mid_var =  MetaVariable:new()
   local rhs_var =  ObjectVariable:new()
   local lhs_cath =  ToLiteral:new(lhs_var, mid_var)
   local rhs_cath =  ToLiteral:new(mid_var, rhs_var)
   local hypoth =  ToLiteral:new(lhs_var, rhs_var)

   local conclusion =  hypoth
   local premises =  Set:empty_set_factory()
   premises:add(lhs_cath)
   premises:add(rhs_cath)

   local clause =  Clause:new(premises, conclusion)
   return Resolve:new(clause)
end

local function gen_td()
   local lhs_var =  MetaVariable:new()
   local mid_var =  ObjectVariable:new()
   local rhs_var =  ObjectVariable:new()
   local lhs_cath =  ToLiteral:new(lhs_var, mid_var)
   local rhs_cath =  ToLiteral:new(mid_var, rhs_var)
   local hypoth =  ToLiteral:new(lhs_var, rhs_var)

   local conclusion =  rhs_cath
   local premises =  Set:empty_set_factory()
   premises:add(lhs_cath)
   premises:add(hypoth)

   local clause =  Clause:new(premises, conclusion)
   return Resolve:new(clause)
end

local Rules =  {
      ["refl"] =  gen_refl()
   ,  ["td"] =  gen_td()
   ,  ["trans"] =  gen_trans()
}

return Rules
