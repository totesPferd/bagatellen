local Dict =  require "base.type.Dict"

local StringKey =  Dict:__new()


package.loaded["base.type.dict.StringKey"] =  StringKey
local String =  require "base.type.String"
local StringSet =  require "base.type.set.StringSet"


function StringKey:empty_dict_factory()
   local retval =  StringKey:__new()
   retval.val =  {}
   return retval
end

function StringKey:is_in_key_set(elem)
   return self.val[elem:get_content()] ~= nil
end

function StringKey:deref(key)
   return self.val[key:get_content()]
end

function StringKey:add(key, val)
   self.val[key:get_content()] =  val
end

function StringKey:drop(key)
   self.val[key:get_content()] =  nil
end

function StringKey:keys()
   local retval =  StringSet:empty_set_factory()
   for key, val in self:elems()
   do retval:add(key)
   end
   return retval
end

function StringKey:elems()
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
      return ks, v
   end
   return f, { pairs(self.val) }
end

function StringKey:__len()
   return #self.val
end

function StringKey:__clone()
   local retval =  StringKey:empty_dict_factory()
   for key, val in self:elems()
   do retval:add(key, val)
   end
   return retval
end

function StringKey:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(base.type.dict.StringKey"))
   for key, val in self:elems()
   do
      indentation:insert(String:string_factory(" "))
      key:__diagnose_single_line(indentation)
      indentation:insert(String:string_factory(": "))
      val:__diagnose_single_line(indentation)
   end
   indentation:insert(String:string_factory(")"))
end

function StringKey:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(base.type.dict.StringKey"))
   local is_last_elem_multiple_line =  true
   for key, val in self:elems()
   do
      indentation:insert_newline()
      local deeper_indentation =
         indentation:get_deeper_indentation_factory {}
      is_last_elem_multiple_line =
         key:__diagnose_complex(deeper_indentation)
         deeper_indentation:insert(String:string_factory(": "))
         val:__diagnose_complex(deeper_indentation)
      deeper_indentation:save()
   end
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return StringKey
