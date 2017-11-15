local Clause =  require "logics.male.Clause"
local EqLiteral =  require "logics.ql.EqLiteral"
local List =  require "base.type.List"
local Resolve =  require "logics.male.rule.Resolve"
local ToLiteral =  require "logics.ql.ToLiteral"
local Variable =  require "logics.ql.Variable"

local function gen_refl()
   local var =  Variable:new()
   local conclusion =  ToLiteral:new(var, var)
   local premises =  List:empty_list_factory()
   local clause =  Clause:new(premises, conclusion)
   return Resolve:new(clause)
end

local function gen_eq_i()
   local lhs_var_a =  Variable:new()
   local lhs_var_b =  Variable:new()
   local rhs_var =  Variable:new()

   local premis_a =  ToLiteral:new(lhs_var_a, rhs_var)
   local premis_b =  ToLiteral:new(lhs_var_b, rhs_var)
   local conclusion =  EqLiteral:new(lhs_var_a, lhs_var_b)
   local premises =  List:list_factory { premis_a, premis_b }

   local clause =  Clause:new(premises, conclusion)
   return Resolve:new(clause)
end

local function gen_trans()
   local lhs_var =  Variable:new()
   local mid_var =  Variable:new()
   local rhs_var =  Variable:new()
   local lhs_cath =  ToLiteral:new(lhs_var, mid_var)
   local rhs_cath =  ToLiteral:new(mid_var, rhs_var)
   local hypoth =  ToLiteral:new(lhs_var, rhs_var)

   local conclusion =  hypoth
   local premises =  List:list_factory { lhs_cath, rhs_cath }

   local clause =  Clause:new(premises, conclusion)
   return Resolve:new(clause)
end

local function gen_eq_da()
   local lhs_var_a =  Variable:new()
   local lhs_var_b =  Variable:new()
   local rhs_var =  Variable:new()

   local premis_a =  ToLiteral:new(lhs_var_a, rhs_var)
   local premis_b =  EqLiteral:new(lhs_var_a, lhs_var_b)
   local conclusion =  ToLiteral:new(lhs_var_b, rhs_var)
   local premises =  List:list_factory { premis_a, premis_b }

   local clause =  Clause:new(premises, conclusion)
   return Resolve:new(clause)
end

local function gen_eq_db()
   local lhs_var_a =  Variable:new()
   local lhs_var_b =  Variable:new()
   local rhs_var =  Variable:new()

   local premis_a =  ToLiteral:new(lhs_var_b, rhs_var)
   local premis_b =  EqLiteral:new(lhs_var_a, lhs_var_b)
   local conclusion =  ToLiteral:new(lhs_var_a, rhs_var)
   local premises =  List:list_factory { premis_a, premis_b }

   local clause =  Clause:new(premises, conclusion)
   return Resolve:new(clause)
end

local function gen_td()
   local lhs_var =  Variable:new()
   local mid_var =  Variable:new()
   local rhs_var =  Variable:new()
   local lhs_cath =  ToLiteral:new(lhs_var, mid_var)
   local rhs_cath =  ToLiteral:new(mid_var, rhs_var)
   local hypoth =  ToLiteral:new(lhs_var, rhs_var)

   local conclusion =  hypoth
   local premises =  List:list_factory { lhs_cath, rhs_cath }

   local clause =  Clause:new(premises, conclusion)
   return Resolve:new(clause)
end

local Rules =  {
      ["eqda"] =  gen_eq_da()
   ,  ["eqdb"] =  gen_eq_da()
   ,  ["eqi"] =  gen_eq_i()
   ,  ["refl"] =  gen_refl()
   ,  ["td"] =  gen_td()
   ,  ["trans"] =  gen_trans()
}

return Rules
