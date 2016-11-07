local Type =  require "base.type.aux.Type"

local Qualifier =  Type:__new()


package.loaded["logics.mod.Qualifier"] =  Qualifier
local Indentation =  require "base.Indentation"
local List =  require "base.type.List"
local String =  require "base.type.String"
local Set =  require "base.type.Set"

function Qualifier:set_factory(set)
   local retval =  Qualifier:__new()
   retval.qualwords =  set
   return retval
end

function Qualifier:id_factory()
   local id_qualword =  List:empty_list_factory()
   return self:qualword_factory(id_qualword)
end

function Qualifier:qualword_factory(qualword)
   local qualwords =  Set:empty_set_factory()
   qualwords:add(qualword)
   return self:set_factory(qualwords)
end

function Qualifier:get_qualwords()
   return self.qualwords
end

function Qualifier:add_qualword(qualword)
   self:get_qualwords():add(qualword)
end

function Qualifier:append_qualid(qualid)
   for x in self:get_qualid():elems()
   do x:append(qualid)
   end
end

function Qualifier:append_qualword(qualword)
   for x in self:get_qualwords():elems()
   do x:append_list(qualword)
   end
end

function Qualifier:equate(other)
   self:get_qualwords():add_set(other:get_qualwords())
end

function Qualifier:is_in(qualword)
   for q in self:get_qualwords():elems()
   do if q:is_final_seq(qualword)
      then
         return true
      end
   end
   return false
end

function Qualifier:__clone()
   local new_qualwords =  Set:empty_set_factory()
   local old_qualwords =  self:get_qualwords()
   for qualword in old_qualwords:elems()
   do new_qualwords:add(qualword:__clone())
   end
   return Qualifier:set_factory(new_qualwords)
end

function Qualifier:__eq(other)
   return self:get_qualwords() == other:get_qualwords()
end

function Qualifier:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics.mod.Qualifier "))
   self:get_qualwords():__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(")"))
end

function Qualifier:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics.mod.Qualifier "))
   local is_last_elem_multiple_line =  true

   indentation:insert_newline()
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}
   is_last_elem_multiple_line =
      self:get_qualwords():__diagnose_complex(deeper_indentation)

   deeper_indentation:save()
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return Qualifier
