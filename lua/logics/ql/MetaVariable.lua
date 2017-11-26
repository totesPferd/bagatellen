local MALEMetaVariable =  require "logics.male.MetaVariable"

local MetaVariable =  MALEMetaVariable:__new()

package.loaded["logics.ql.MetaVariable"] =  MetaVariable
local Compound =  require "logics.ql.Compound"
local String =  require "base.type.String"

function MetaVariable:new()
   local retval =  MALEMetaVariable.new(self)
   return retval
end

function MetaVariable:copy()
   return self.__index:new()
end

function MetaVariable:get_compound_cast()
end

function MetaVariable:destruct_terminal(p, terminal)
   local this_val =  self:get_bound_val()
   if this_val
   then
      return this_val:destruct_terminal(this_val, terminal)
   else
      self:set_val(p)
      return p:get_rhs_object()
   end
end

function MetaVariable:get_name()
   return self.name
end

function MetaVariable:set_name(name)
   self.name =  name
end

function MetaVariable:get_non_nil_name()
   return self:get_name() or String:string_factory("???")
end

function MetaVariable:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::ql::MetaVariable ["))
   if self:is_bound()
   then
      indentation:insert(String:string_factory("bound; "))
   end
   indentation:insert(String:string_factory(tostring(self)))
   indentation:insert(String:string_factory("] "))
   indentation:insert(self:get_non_nil_name())
   local this_val =  self:get_val()
   if this_val
   then
      indentation:insert(String:string_factory(" "))
      self:get_val():__diagnose_single_line(indentation)
   end
   indentation:insert(String:string_factory(")"))
end

function MetaVariable:__diagnose_multiple_line(indentation)
   local is_last_elem_multiple_line =  true

   indentation:insert(String:string_factory("(logics::ql::MetaVariable ["))
   if self:is_bound()
   then
      indentation:insert(String:string_factory("bound; "))
   end
   indentation:insert(String:string_factory(tostring(self)))
   indentation:insert(String:string_factory("] "))
   indentation:insert(self:get_non_nil_name())
   local this_val =  self:get_val()
   if this_val
   then
      indentation:insert_newline()
      local deeper_indentation =
         indentation:get_deeper_indentation_factory {}
      is_last_elem_multiple_line
         =  this_val:__diagnose_complex(deeper_indentation)
      deeper_indentation:save()
   end
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return MetaVariable
