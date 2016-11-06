local Type =  require "base.type.aux.Type"

local Qualifier =  Type:__new()


package.loaded["logics.mod.Qualifier"] =  Qualifier
local Indentation =  require "base.Indentation"
local List =  require "base.type.List"
local String =  require "base.type.String"
local Set =  require "base.type.Set"

function Qualifier:set_factory(set)
   local retval =  Qualifier:__new()
   retval.qualids =  set
   return retval
end

function Qualifier:id_factory()
   local id_qualid =  List:empty_list_factory()
   return self:qualid_factory(id_qualid)
end

function Qualifier:qualid_factory(qualid)
   local qualids =  Set:empty_set_factory()
   qualids:add(qualid)
   return self:set_factory(qualids)
end

function Qualifier:get_qualids()
   return self.qualids
end

function Qualifier:add_qualid(qualid)
   self:get_qualids():add(qualid)
end

function Qualifier:append_qualid(qualid)
   for x in self:get_qualids():elems()
   do x:append_list(qualid)
   end
end

function Qualifier:equate(other)
   self:get_qualids():add_set(other:get_qualids())
end

function Qualifier:is_in(qualid)
   return self:get_qualids():is_in(qualid)
end

function Qualifier:is_subeq(other)
   return self:get_qualids():is_subeq(other:get_qualids())
end

function Qualifier:__clone()
   local new_qualids =  Set:empty_set_factory()
   local old_qualids =  self:get_qualids()
   for qualid in old_qualids:elems()
   do new_qualids:add(qualid:__clone())
   end
   return Qualifier:set_factory(new_qualids)
end

function Qualifier:__eq(other)
   return self:get_qualids() == other:get_qualids()
end

function Qualifier:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics.mod.Qualifier "))
   self:get_qualids():__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(")"))
end

function Qualifier:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics.mod.Qualifier "))
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
