local Type =  require "base.type.aux.Type"

local Set =  Type:__new()


package.loaded["base.type.Set"] =  Set
local Indentation =  require "base.Indentation"
local List =  require "base.type.List"
local String =  require "base.type.String"


--- Factory method producing empty set.
--  @return empty set object
function Set:empty_set_factory()
   local retval =  Set:__new()
   retval.val =  {}
   return retval
end

--- Does my set contain a given element?
--  @param elem element to be proven to be contained in set
--  @return boolean
function Set:is_in(elem)
   local retval =  false
   for set_elem in self:elems()
   do if elem == set_elem
      then
         retval =  true
         break
      end
   end
   return retval
end

--- Adding an element to a set.
--  @param elem element to be added
function Set:add(elem)
   if not self:is_in(elem)
   then
      table.insert(self.val, elem)
   end
end

--- Dropping an element from a set.
--  @param elem to be dropped
function Set:drop(elem)
   local index =  1
   while self.val[index]
   do if self.val[index] == elem
      then
         table.remove(self.val, index)
         return
      end
      index =  index + 1
   end
end

--- Adding all elements of another set.
--  @param other other set whose elements should be added
function Set:add_set(other)
   for elem in other:elems()
   do self:add(elem)
   end
end

--- Dropping all elements which are not contained in other set.
--  @param other other set
function Set:cut_set(other)
   local index =  1
   while self.val[index]
   do while self.val[index] and not other:is_in(self.val[index])
      do table.remove(self.val, index)
      end
      index =  index + 1
   end
end

--- Dropping all elements which is contained in other set.
--  @param other other set
function Set:diff_set(other)
   local index =  1
   while self.val[index]
   do while self.val[index] and other:is_in(self.val[index])
      do table.remove(self.val, index)
      end
      index =  index + 1
   end
end

--- Iterator iterating all elements.
--  @usage Use it as follows:<blockquote><code>
--  for elem in s:elems()<br/>
--  do &laquo; ...do this and that with elem ... &raquo;<br/>
--  end</code></blockquote>
function Set:elems()
   function f(s, var)
      if not var
      then
        s.index =  0
      end
      s.index =  s.index + 1
      return self.val[s.index]
   end
   return f, {}
end

--- Is other set subset?
--  @param other set to be proven whether it is subset
--  @return boolean
function Set:is_subeq(other)
   local retval =  true
   for elem in self:elems()
   do if not other:is_in(elem)
      then
         retval =  false
         break
      end
   end
   return retval
end

--- Get sorted list of all elements contained in my set.
--  @return base.type.List list off all elements, sorted
function Set:get_sorted_list()
   local retval =  List:empty_list_factory()
   for x in self:elems()
   do retval:append(x)
   end
   retval:sort()
   return retval
end

function Set:__clone()
   local retval =  self:empty_set_factory()
   for elem in self:elems()
   do retval:add(elem)
   end
   return retval
end

function Set:__len()
   return #self.val
end

function Set:__eq(other)
   return self:is_subeq(other) and other:is_subeq(self)
end

function Set:__tostring()
   local retval =  "{"
   local first_time =  true
   for elem in self:elems()
   do if first_time
      then
         first_time =  false
      else
         retval =  retval .. ", "
      end
      retval =  retval .. tostring(elem)
   end
   retval =  retval .. "}"
   return retval
end

function Set:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(base.type.Set"))
   for elem in self:elems()
   do
      indentation:insert(String:string_factory(" "))
      elem:__diagnose_single_line(indentation)
   end
   indentation:insert(String:string_factory(")"))
end

function Set:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(base.type.Set"))
   local is_last_elem_multiple_line =  true
   for elem in self:elems()
   do
      indentation:insert_newline()
      local deeper_indentation =
         indentation:get_deeper_indentation_factory {}
      is_last_elem_multiple_line =
         elem:__diagnose_complex(deeper_indentation)
      deeper_indentation:save()
   end
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return Set
