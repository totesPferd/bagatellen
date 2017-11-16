local Clause =  require "logics.male.Clause"
local EqLiteral =  require "logics.ql.EqLiteral"
local Qualifier =  require "logics.ql.Qualifier"
local Resolve =  require "logics.male.rule.Resolve"
local Set =  require "base.type.Set"
local ToLiteral =  require "logics.ql.ToLiteral"
local Variable =  require "logics.ql.Variable"

local function gen_refl()
   local var =  Variable:new(Qualifier:id_factory())
   local conclusion =  ToLiteral:new(var, var)
   local premises =  Set:empty_set_factory()
   local clause =  Clause:new(premises, conclusion)
   return Resolve:new(clause)
end

local function gen_eq_i()
   local lhs_var_a =  Variable:new(Qualifier:id_factory())
   local lhs_var_b =  Variable:new(Qualifier:id_factory())
   local rhs_var =  Variable:new(Qualifier:id_factory())

   local premis_a =  ToLiteral:new(lhs_var_a, rhs_var)
   local premis_b =  ToLiteral:new(lhs_var_b, rhs_var)
   local conclusion =  EqLiteral:new(lhs_var_a, lhs_var_b)
   local premises =  Set:empty_set_factory()
   premises:add(premis_a)
   premises:add(premis_b)

   local clause =  Clause:new(premises, conclusion)
   return Resolve:new(clause)
end

local function gen_trans()
   local lhs_var =  Variable:new(Qualifier:id_factory())
   local mid_var =  Variable:new(Qualifier:id_factory())
   local rhs_var =  Variable:new(Qualifier:id_factory())
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

local function gen_eq_da()
   local lhs_var_a =  Variable:new(Qualifier:id_factory())
   local lhs_var_b =  Variable:new(Qualifier:id_factory())
   local rhs_var =  Variable:new(Qualifier:id_factory())

   local premis_a =  ToLiteral:new(lhs_var_a, rhs_var)
   local premis_b =  EqLiteral:new(lhs_var_a, lhs_var_b)
   local conclusion =  ToLiteral:new(lhs_var_b, rhs_var)
   local premises =  Set:empty_set_factory()
   premises:add(premis_a)
   premises:add(premis_b)

   local clause =  Clause:new(premises, conclusion)
   return Resolve:new(clause)
end

local function gen_eq_db()
   local lhs_var_a =  Variable:new(Qualifier:id_factory())
   local lhs_var_b =  Variable:new(Qualifier:id_factory())
   local rhs_var =  Variable:new(Qualifier:id_factory())

   local premis_a =  ToLiteral:new(lhs_var_b, rhs_var)
   local premis_b =  EqLiteral:new(lhs_var_a, lhs_var_b)
   local conclusion =  ToLiteral:new(lhs_var_a, rhs_var)
   local premises =  Set:empty_set_factory()
   premises:add(premis_a)
   premises_add(premis_b)

   local clause =  Clause:new(premises, conclusion)
   return Resolve:new(clause)
end

local function gen_td()
   local lhs_var =  Variable:new(Qualifier:id_factory())
   local mid_var =  Variable:new(Qualifier:id_factory())
   local rhs_var =  Variable:new(Qualifier:id_factory())
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

local Rules =  {
      ["eqda"] =  gen_eq_da()
   ,  ["eqdb"] =  gen_eq_da()
   ,  ["eqi"] =  gen_eq_i()
   ,  ["refl"] =  gen_refl()
   ,  ["td"] =  gen_td()
   ,  ["trans"] =  gen_trans()
}

return Rules
