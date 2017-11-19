local MALEMetaVariable =  require "logics.male.MetaVariable"

local MetaVariable =  MALEMetaVariable:__new()

package.loaded["logics.qualifier.MetaVariable"] =  MetaVariable
local CompoundQualifier =  require "logics.qualifier.CompoundQualifier"
local String =  require "base.type.String"

function MetaVariable:new()
   local retval =  MALEMetaVariable.new(self)
   return retval
end

function MetaVariable:copy()
   return self.__index:new()
end

function MetaVariable:new_compound_qualifier(terminal, qualifier)
   return CompoundQualifier:new(terminal, qualifier)
end

function MetaVariable:get_compound_qualifier_cast()
end

function MetaVariable:destruct_terminal(terminal)

   local this_val =  self:get_val()
   if this_val
   then
      if this_val:get_terminal() == terminal
      then
         return this_val:get_qualifier()
      end
   end

   local new_var =  self:copy()
   local new_val =  self:new_compound_qualifier(terminal, new_var)
   self:set_val(new_val)
   return new_var

end

function MetaVariable:get_name()
   local this_val =  self:get_val()
   if this_val
   then
      return this_val:get_name()
   end

   local retval =  String:string_factory("?")
   retval:append_string(self:get_rhs_object():get_name())
   return retval
end

return MetaVariable
