local QLObjectVariable =  require "logics.ql.ObjectVariable"
local String =  require "base.type.String"

local ObjectVariable =  QLObjectVariable:__new()

function ObjectVariable:new_ql_variable(male_variable, qualifier)
   local retval =  ObjectVariable:__new()
   retval.male_variable =  male_variable
   retval.qualifier =  qualifier
   return retval
end

function ObjectVariable:new_instance()
   return self:new_ql_variable(
         self:get_male_variable()
      ,  self:get_qualifier() )
end

function ObjectVariable:get_name()
   return self.name
end

function ObjectVariable:set_name(name)
   self.name =  name
end

function ObjectVariable:get_non_nil_name()
   return self:get_name() or String:string_factory("?")
end

function ObjectVariable:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::dql::ObjectVariable "))
   indentation:insert(self:get_qualifier():get_name())
   indentation:insert(String:string_factory(" "))
   indentation:insert(self:get_non_nil_name())
   local val =  self:get_val()
   if val
   then
      indentation:insert(String:string_factory(" "))
      val:__diagnose_single_line(indentation)
   end
   indentation:insert(String:string_factory(")"))
end

function ObjectVariable:__diagnose_multiple_line(indentation)
   local is_last_elem_multiple_line =  true

   indentation:insert(String:string_factory("(logics::dql::ObjectVariable "))
   indentation:insert(self:get_qualifier():get_name())
   indentation:insert_newline()
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}
   deeper_indentation:insert(self:get_non_nil_name())
   local val =  self:get_val()
   if val
   then
      deeper_indentation:insert_newline()
      is_last_elem_multiple_line
         =  val:__diagnose_complex(deeper_indentation)
   end
   deeper_indentation:save()
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end


return ObjectVariable
