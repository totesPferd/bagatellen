local MALEMetaVariable =  require "logics.male.MetaVariable"

local MetaVariable =  MALEMetaVariable:__new()

package.loaded["logics.qualifier.MetaVariable"] =  MetaVariable
local CompoundQualifier =  require "logics.qualifier.CompoundQualifier"

function MetaVariable:new(rhs_object)
   local retval =  MALEMetaVariable.new(self)
   retval.rhs_object =  rhs_object
   return retval
end

function MetaVariable:new_compound_qualifier(terminal, qualifier)
   return CompoundQualifier:new(terminal, qualifier)
end

function MetaVariable:get_compound_qualifier_cast()
end

function MetaVariable:get_rhs_object()
   return self.rhs_object
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

   local rhs_obj_compound_qualifier_cast
      =  self:get_rhs_object():get_compound_qualifier_cast()
   if
         rhs_obj_compound_qualifier_cast
     and rhs_obj_compound_qualifier_cast:get_terminal() == terminal
   then
      self:set_val(rhs_obj_compound_qualifier_cast)
      return rhs_obj_compound_qualifier_cast:get_qualifier()
   end

   local new_var =  self:copy()
   local new_val =  self:new_compound_qualifier(terminal, new_var)
   self:set_val(new_val)
   return new_var
end

function MetaVariable:append_qualifier(qualifier)
   self:get_rhs_object():append_qualifier(qualifier)
end

function MetaVariable:is_id()
   local this_val =  self:get_val()
   if this_val
   then
      return this_val:is_id()
   else
      return self:get_rhs_object():is_id()
   end
end

return MetaVariable
