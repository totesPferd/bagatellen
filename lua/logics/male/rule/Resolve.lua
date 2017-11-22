local Rule =  require "logics.male.Rule"

local Resolve =  Rule:__new()


package.loaded["logics.male.rule.Resolve"] =  Resolve
local Indentation =  require "base.Indentation"
local Set =  require "base.type.Set"
local String =  require "base.type.String"

function Resolve:get_resolve_cast()
   return self
end

function Resolve:new(clause)
   local retval =  Rule.new(self)
   retval.clause =  clause
   return retval
end

function Resolve:new_instance(clause)
   return Resolve:new(clause)
end

function Resolve:get_clause()
   return self.clause
end

function Resolve:apply(proof_state, goal)
   return proof_state:resolve(
         self:get_clause()
      ,  goal )
end

function Resolve:equate(goal)
   return self:get_clause():equate(goal)
end

function Resolve:devar()
   return self:new_instance(self:get_clause():devar())
end

function Resolve:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::male::rule::Resolve "))
   self:get_clause():__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(")"))
end

function Resolve:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics::male::rule::Resolve"))
   local is_last_elem_multiple_line =  true
   indentation:insert_newline()
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}
   is_last_elem_multiple_line =
      self:get_clause():__diagnose_complex(deeper_indentation)
   deeper_indentation:save()
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return Resolve
