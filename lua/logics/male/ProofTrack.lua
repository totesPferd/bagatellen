local ProofState =  require "logics.male.ProofState"

local ProofTrack =  ProofState:__new()


package.loaded["logics.male.ProofTrack"] =  ProofTrack
local Indentation =  require "base.Indentation"
local String =  require "base.type.String"

function ProofTrack:new(proof, conclusions)
   local retval =  ProofState.new(self, conclusions)
   retval.proof =  proof
   return retval
end

function ProofTrack:new_instance(premises, conclusions)
   return ProofTrack:new(self:get_proof(), premises, conclusions)
end

function ProofTrack:get_proof()
   return self.proof
end

function ProofTrack:resolve(axiom, goal)
   local retval =  ProofState.resolve(self, axiom, goal)
   if retval
   then
      self:get_proof():add(rule)
   end
   return retval
end

function ProofTrack:devar()
   local retval =  ProofState.devar(self)
   retval.proof =  self:get_proof()
   return retval
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
