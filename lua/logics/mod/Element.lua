local Type =  require "base.type.aux.Type"

local Element =  Type:__new()


package.loaded["logics.mod.Element"] =  Element
local Indentation =  require "base.Indentation"
local String =  require "base.type.String"

function Element:new(key, qualifier)
   local retval =  Element:__new()
   retval.key =  key
   retval.qualifier =  qualifier
   return retval
end

function Element:get_key()
   return self.key
end

function Element:get_qualifier()
   return self.qualifier
end

function Element:set_qualifier(qualifier)
   self.qualifier =  qualifier
end

function Element:append_qualid(qualid)
   self:get_qualifier():append_qualid(qualid)
end

function Element:__clone()
   local retval =  Element:__new()
   retval.key =  self:get_key()
   retval.qualifier =  self:get_qualifier():__clone()
   return retval
end

function Element:__eq(other)
   return
          self:get_key() == other:get_key()
      and self:get_qualifier() == other:get_qualifier()
end
   
function Element:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics.mod.Element key: "))
   self:get_key():__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(" qualifier: "))
   self:get_qualifier():__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(")"))
end

function Element:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics.mod.Element "))
   local is_last_elem_multiple_line =  true

   indentation:insert_newline()
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}
   deeper_indentation:insert(String:string_factory("key: "))
   self:get_key():__diagnose_complex(deeper_indentation)
   deeper_indentation:save()
   indentation:insert_newline()
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}
   deeper_indentation:insert(String:string_factory("qualifier: "))
   is_last_elem_multiple_line =
      self:get_qualifier():__diagnose_complex(deeper_indentation)
   deeper_indentation:save()
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return Element
