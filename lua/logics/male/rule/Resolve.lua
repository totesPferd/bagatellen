local Rule =  require "logics.male.Rule"

local Resolve =  Rule:__new()


package.loaded["logics.male.rule.Resolve"] =  Resolve
local Indentation =  require "base.Indentation"
local String =  require "base.type.String"

function Resolve:new(key, substitution, goal)
   local retval =  Rule.new(Resolve, goal)
   retval.key =  key
   retval.substitution =  substitution
   return retval
end

function Resolve:get_key()
   return self.key
end

function Resolve:get_substitution()
   return self.substitution
end

function Resolve:apply(proof_state)
   return proof_state:resolve(
         self:get_key()
      ,  self:get_substitution()
      ,  self:get_goal() )
end

function Resolve:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics.male.Resolve "))
   self:get_key():__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(" "))
   self:get_substitution():__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(" "))
   self:get_goal():__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(")"))
end

function Resolve:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics.male.Resolve"))
   local is_last_elem_multiple_line =  true
   indentation:insert_newline()
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}
   is_last_elem_multiple_line =
      self:get_key():__diagnose_complex(deeper_indentation)
   deeper_indentation:insert_newline()
   is_last_elem_multiple_line =
      self:get_substitution():__diagnose_complex(deeper_indentation)
   deeper_indentation:insert_newline()
   is_last_elem_multiple_line =
      self:get_goal():__diagnose_complex(deeper_indentation)
   deeper_indentation:save()
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return Resolve
