local MALEMetaVariable =  require "logics.male.MetaVariable"

local MetaVariable =  MALEMetaVariable:__new()

package.loaded["logics.qualifier.MetaVariable"] =  MetaVariable
local Compound =  require "logics.qualifier.Compound"
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

function MetaVariable:destruct_terminal(q, terminal)
   local this_val =  self:get_val()
   if not this_val
   then
      self:set_val(q)
   end
   if this_val and (this_val == q) or not this_val
   then
      local ret_pt = q:get_qualifier()
      local retval =  self:copy()
      retval:set_val(ret_pt)
      return retval
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
