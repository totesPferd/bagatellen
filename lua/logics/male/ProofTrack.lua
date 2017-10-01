local ProofState =  require "logics.male.ProofState"

local ProofTrack =  ProofState:__new()


package.loaded["logics.male.ProofTrack"] =  ProofTrack
local Indentation =  require "base.Indentation"
local String =  require "base.type.String"

function ProofTrack:new(proof, clause)
   local retval =  ProofState:new(proof:get_prs(), clause)
   retval.proof =  proof
   return retval
end

function ProofTrack:get_proof()
   return self.proof
end

function ProofTrack:apply_rule(rule, goal)
   local retval =  ProofState.apply_rule(self, rule, goal)
   if retval
   then
      self:get_proof():add(rule)
   end
   return retval
end

function ProofTrack:__clone()
   local retval =  ProofState.__clone(self)
   retval.proof =  self:get_proof()
   return retval
end

function ProofTrack:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::male::ProofTrack "))
   self:get_premises():__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(" "))
   self:get_conclusions():__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(")"))
end

function ProofTrack:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics::male::ProofTrack"))
   local is_last_elem_multiple_line =  true

   indentation:insert_newline()
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}
   is_last_elem_multiple_line =
      self:get_premises():__diagnose_complex(deeper_indentation)

   deeper_indentation:insert_newline()
   is_last_elem_multiple_line =
      self:get_conclusions():__diagnose_complex(deeper_indentation)

   deeper_indentation:save()
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return ProofTrack
