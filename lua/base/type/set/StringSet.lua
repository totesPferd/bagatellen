local Set =  require "base.type.Set"

local StringSet =  Set:__new()


package.loaded["base.type.set.StringSet"] =  StringSet
local String =  require "base.type.String"


function StringSet:empty_set_factory()
   local retval =  StringSet:__new()
   retval.val =  {}
   return retval
end

function StringSet:is_in(elem)
   return self.val[elem:get_content()] ~= nil
end

function StringSet:add(key)
   self.val[key:get_content()] =  true
end

function StringSet:drop(key)
   self.val[key:get_content()] =  nil
end

function StringSet:elems()
   function f(s, index)
      local g =  s[1]
      local t =  s[2]
      local i =  nil
      if index
      then
         i =  index:get_content()
      end
      
      local k, v =  g(t, i)
      local ks =  nil
      if k
      then
         ks =  String:string_factory(k)
      end
      return ks
   end
   return f, { pairs(self.val) }
end

function StringSet:__len()
   return #self.val
end

function StringSet:__clone()
   local retval =  StringSet:empty_set_factory()
   for key in self:elems()
   do retval:add(key)
   end
   return retval
end

function StringSet:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(base::type::set::StringSet"))
   for key in self:elems()
   do
      indentation:insert(String:string_factory(" "))
      key:__diagnose_single_line(indentation)
   end
   indentation:insert(String:string_factory(")"))
end

function StringSet:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(base::type::set::StringSet"))
   local is_last_elem_multiple_line =  true
   for key in self:elems()
   do
      indentation:insert_newline()
      local deeper_indentation =
         indentation:get_deeper_indentation_factory {}
      is_last_elem_multiple_line =
         key:__diagnose_complex(deeper_indentation)
      deeper_indentation:save()
   end
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return StringSet
