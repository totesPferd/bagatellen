local Type =  require "base.type.aux.Type"

local Dict =  Type:__new()


package.loaded["base.type.Dict"] =  Dict
local Indentation =  require "base.Indentation"
local Set =  require "base.type.Set"
local String =  require "base.type.String"


--- Factory method factoring empty dictionary.
--  @return empty dict object
function Dict:empty_dict_factory()
   local retval =  Dict:__new()
   retval.val =  {}
   return retval
end

--- Does dictionary contains a certain key?
--  @param elem elem to be proven key
--  @return boolean
function Dict:is_in_key_set(elem)
   local retval =  false
   for key_elem, val_elem in self:elems()
   do if elem == key_elem
      then
         retval =  true
         break
      end
   end
   return retval
end

--- Does dictionary contains a value?
--  @param elem value
--  @return boolean
function Dict:is_in_val_set(elem)
   local retval =  false
   for key_elem, val_elem in self:elems()
   do if elem == val_elem
      then
         retval =  true
         break
      end
   end
   return retval
end

--- Get a value assigned to a key.
--  @param key
--  @return the value assigned to key if there is one or nil, resp.
function Dict:deref(key)
   for k, v in self:elems()
   do if key == k
      then
         return v
      end
   end
   return
end

--- Assigning value to a key.
--  @param key key
--  @param val value
function Dict:add(key, val)
   local is_in_key_val =  false
   for k, v in pairs(self.val)
   do if v.key == key
      then
         v.val = val
         is_in_key_val =  true
      end
   end
   if not(is_in_key_val)
   then
      table.insert(self.val, { key =  key, val = val })
   end
end

--- Dropping a key-value pair
--  @param key
function Dict:drop(key)
   for i, v in ipairs(self.val)
   do if v.key == key
      then
         table.remove(self.val, i)
         break
      end
   end
end

--- Assigning all key-val-pairs of other dictionary.
--  @param other other dictionary
function Dict:add_dict(other)
   for key, val in other:elems()
   do self:add(key, val)
   end
end

--- Dropping all key-val-pairs which is not contained in other dictionary.
--  @param other other dictionary
function Dict:cut_dict(other)
   for key in self:keys():elems()
   do if not other:is_in_key_set(key)
      then
         self:drop(key)
      end
   end
end

--- Dropping all key-val-pairs which is contained in other dictionary.
--  @param other other dictionary
function Dict:diff_dict(other)
   for key in self:keys():elems()
   do if other:is_in_key_set(key)
      then
         self:drop(key)
      end
   end
end

--- Getting a set of all keys.
--  @return a set of all keys
function Dict:keys()
   local retval =  Set:empty_set_factory()
   for key, val in self:elems()
   do retval:add(key)
   end
   return retval
end

--- Getting a set of all vals.
--  @return a set of all vals
function Dict:vals()
   local retval =  Set:empty_set_factory()
   for key, val in self:elems()
   do retval:add(val)
   end
   return retval
end

--- Iterator iterating over all key-val-pairs.
--  @usage Use it as follows:<blockquote><code>
--  for key, val in d:elems()<br/>
--  do &laquo; ...do this and that... &raquo;<br/>
--  end</code></blockquote>
function Dict:elems()
   function f(s, var)
      if not var
      then
        s.index =  0
      end
      s.index =  s.index + 1
      if self.val[s.index]
      then
         return self.val[s.index].key, self.val[s.index].val
      else
         return
      end
   end
   return f, {}
end

--- does v_s == v_o hold
--     for all k with (k, v_s) in self and (k, v_o) in other?
--  @param other dictionary
--  @return boolean: if false then self will not be affected
function Dict:is_consistent(other)
   for key, val in self:elems()
   do local other_val =  other:deref(key)
      if other_val and other_val ~= val
      then return false
      end
   end
   return true
end

--- Is other dictionary contains my dictionary?
--  @param other dictionary
--  @return boolean
function Dict:is_subeq(other)
   local retval =  true
   for key, val in self:elems()
   do if not other:deref(key) or not other:deref(key) == val
      then
         retval =  false
         break
      end
   end
   return retval
end

function Dict:__clone()
   local retval =  Dict:empty_dict_factory()
   for key, val in self:elems()
   do retval:add(key, val)
   end
   return retval
end

function Dict:__len()
   return #self.val
end

function Dict:__eq(other)
   return self:is_subeq(other) and other:is_subeq(self)
end

function Dict:__tostring()
   local retval =  "{"
   local first_time =  true
   for key, val in self:elems()
   do if first_time
      then
         first_time =  false
      else
         retval =  retval .. ", "
      end
      retval =  retval .. tostring(key) .. ": " .. tostring(val)
   end
   retval =  retval .. "}"
   return retval
end

function Dict:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(base.type.Dict"))
   for key, val in self:elems()
   do
      indentation:insert(String:string_factory(" "))
      key:__diagnose_single_line(indentation)
      indentation:insert(String:string_factory(": "))
      val:__diagnose_single_line(indentation)
   end
   indentation:insert(String:string_factory(")"))
end

function Dict:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(base.type.Dict"))
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

return Dict
