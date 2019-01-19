local Type =  require "base.type.aux.Type"

local ProofState =  Type:__new()


package.loaded["logics.male.ProofState"] =  ProofState
local Clause =  require "logics.male.Clause"
local ContectedTerm =  require "logics.male.ContectedTerm"
local Indentation =  require "base.Indentation"
local Set =  require "base.type.Set"
local String =  require "base.type.String"
local VarAssgnm =  require "logics.male.VarAssgnm"

function ProofState:new(var_ctxt, conclusions)
   local retval =  self:__new()
   retval.conclusions =  conclusions
   retval.var_ctxt =  var_ctxt
   return retval
end

function ProofState:get_var_ctxt()
   return self.var_ctxt
end

function ProofState:new_instance(conclusions)
   return ProofState:new(self:get_var_ctxt(), conclusions)
end

function ProofState:new_contected_term(var_ctxt, term)
   return ContectedTerm:new(var_ctxt, term)
end

function ProofState:new_clause(var_ctxt, premises, conclusion)
   return Clause:new(var_ctxt, premises, conclusion)
end

function ProofState:new_var_assgnm()
   return VarAssgnm:new()
end

function ProofState:get_conclusions()
   return self.conclusions
end

function ProofState:add(literal)
   self:get_conclusions():add(literal)
end

function ProofState:is_proven()
   return self:get_conclusions():is_empty()
end

function ProofState:use(rule)
end

function ProofState:drop(conclusion)
   self:get_conclusions():drop(conclusion)
end

function ProofState:resolve(axiom, goal)
   local contected_goal =  self:new_contected_term(
         self:get_var_ctxt()
      ,  goal)
   local retval =  axiom:equate(contected_goal)
   if retval
   then
      self:use(axiom)
      self:get_conclusions():drop(goal)
      for premis in axiom:get_premises():elems()
      do self:get_conclusions():add(premis)
      end
   end
   return retval
end

function ProofState:apply_proof(proof)
   for conclusion in self:get_conclusions():elems()
   do self:drop(conclusion)
      proof:apply(self, conclusion)
   end
end

function ProofState:push_to_proof(proof, premises)
   local var_ctxt =  self:get_var_ctxt()
   for conclusion in self:get_conclusions():elems()
   do  local next_clause =  self:new_clause(var_ctxt, premises, conclusion)
       proof:add(next_clause)
   end
end

function ProofState:get_devared_conclusions(var_assgnm)
   local retval =  Set:empty_set_factory()
   for conclusion in self:get_conclusions():elems()
   do retval:add(conclusion:devar(var_assgnm))
   end
   return retval
end

function ProofState:devar()
   local var_assgnm =  self:new_var_assgnm()
   local new_conclusions =  self:get_devared_conclusions(var_assgnm)
   return self:new_instance(new_conclusions)
end

function ProofState:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::male::ProofState "))
   self:get_conclusions():__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(")"))
end

function ProofState:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics::male::ProofState"))
   local is_last_elem_multiple_line =  true

   indentation:insert_newline()
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}

   is_last_elem_multiple_line =
      self:get_conclusions():__diagnose_complex(deeper_indentation)

   deeper_indentation:save()
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return ProofState
