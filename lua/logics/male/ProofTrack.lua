local ProofState =  require "logics.male.ProofState"

local ProofTrack =  ProofState:__new()


package.loaded["logics.male.ProofTrack"] =  ProofTrack
local Indentation =  require "base.Indentation"
local String =  require "base.type.String"

function ProofTrack:new(proof_state, proof)
   local retval =  ProofState.__new(self)
   retval.proof =  proof
   retval.proof_state =  proof_state
   return retval
end

function ProofTrack:new_instance(proof_state)
   return ProofTrack:new(proof_state, self:get_proof())
end

function ProofTrack:get_proof()
   return self.proof
end

function ProofTrack:get_proof_state()
   return self.proof_state
end

function ProofTrack:get_conclusions()
   return self:get_proof_state():get_conclusions()
end

function ProofTrack:resolve(axiom, goal)
   local retval =  self:get_proof_state():resolve(axiom, goal)
   if retval
   then
      self:get_proof():add(axiom)
   end
   return retval
end

function ProofTrack:devar()
   local proof_state =  self:get_proof_state():devar()
   return self:new_instance(proof_state)
end

function ProofTrack:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::male::ProofTrack "))
   self:get_conclusions():__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(")"))
end

function ProofTrack:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics::male::ProofTrack"))
   local is_last_elem_multiple_line =  true

   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}

   deeper_indentation:insert_newline()
   is_last_elem_multiple_line =
      self:get_conclusions():__diagnose_complex(deeper_indentation)

   deeper_indentation:save()
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return ProofTrack
