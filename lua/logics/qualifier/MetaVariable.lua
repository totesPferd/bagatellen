local MALEMetaVariable =  require "logics.male.MetaVariable"

local MetaVariable =  MALEMetaVariable:__new()

package.loaded["logics.qualifier.MetaVariable"] =  MetaVariable
local Compound =  require "logics.qualifier.Compound"
local String =  require "base.type.String"

function MetaVariable:new(rhs_object)
   local retval =  MALEMetaVariable.new(self)
   retval.rhs_object =  rhs_object
   return retval
end

function MetaVariable:copy()
   return self.__index:new(self:get_rhs_object())
end

function MetaVariable:get_rhs_object()
   return self.rhs_object
end

function MetaVariable:get_compound_cast()
end

function MetaVariable:finish()
   local this_val =  self:get_val()
   local rhs_object =  self:get_rhs_object()
   if this_val
   then
      return this_val == rhs_object
   else
      self:set_val(rhs_object)
      return true
   end
end

function MetaVariable:destruct_terminal(terminal)
   local this_val =  self:get_val()
   if this_val
   then
      return this_val:destruct_terminal(terminal)
   else
      local arg =  self:copy()
      local val =  Compound:new(terminal, arg)
      self:set_val(val)
      return arg
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
   indentation:insert(String:string_factory("(logics::qualifier::MetaVariable "))
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

   indentation:insert(String:string_factory("(logics::qualifier::MetaVariable"))
   indentation:insert_newline()
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}
   deeper_indentation:insert(self:get_non_nil_name())
   local this_val =  self:get_val()
   if this_val
   then
      deeper_indentation:insert_newline()
      is_last_elem_multiple_line
         =  this_val:__diagnose_complex(deeper_indentation)
   end
   deeper_indentation:save()
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return MetaVariable
