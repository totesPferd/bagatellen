local Type =  require "base.type.aux.Type"

local Qualifier =  Type:__new()


package.loaded["logics.mod_male.Qualifier"] =  Qualifier
local Indentation =  require "base.Indentation"
local String =  require "base.type.String"
local Set =  require "base.type.Set"

function Qualifier:set_factory(set)
   local retval =  Qualifier:__new()
   retval.qualids =  set
   return retval
end

function Qualifier:id_factory()
   local retval =  Qualifier:__new()
   retval.qualids =  Set:empty_set_factory()
   return retval
end

function Qualifier:qualid_factory(qualid)
   local retval =  self:id_factory()
   retval.qualids:add(qualid)
   return
end

function Qualifier:get_qualids()
   return self.qualids
end

function Qualifier:append_qualid(qualid)
   local is_empty =  true
   for x in self:get_qualids():elems()
   do x:append(qualid)
      is_empty =  false
   end
   if is_empty
   then
      self:get_qualids():add(qualid)
   end
end

function Qualifier:equate(other)
   self:get_qualids():add_set(other:get_qualids())
end

function Qualifier:subeq(other)
   return self:get_qualids():subeq(other:get_qualids())
end

function Qualifier:__clone()
   return Qualifier:set_factory(self:get_qualids():__clone())
end

function Qualifier:__eq(other)
   return self:get_qualids() == other:get_qualids()
end

function Qualifier:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics.mod_male.Qualifier "))
   self:get_qualids():__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(")"))
end

function Qualifier:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics.mod_male.Qualifier "))
   local is_last_elem_multiple_line =  true

   indentation:insert_newline()
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}
   is_last_elem_multiple_line =
      self:get_qualids():__diagnose_complex(deeper_indentation)

   deeper_indentation:save()
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return Qualifier
