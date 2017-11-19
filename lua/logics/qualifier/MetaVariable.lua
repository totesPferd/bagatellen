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

function MetaVariable:get_compound_qualifier_cast()
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
   local this_val =  self:get_val()
   if this_val
   then
      return this_val:get_name()
   end

   local retval =  String:string_factory("?")
   return retval
end

return MetaVariable
