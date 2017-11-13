local Type =  require "base.type.aux.Type"

local Set =  Type:__new()


package.loaded["base.type.Set"] =  Set
local Indentation =  require "base.Indentation"
local List =  require "base.type.List"
local String =  require "base.type.String"


--- Factory method producing empty set.
--  @return empty set object
function Set:empty_set_factory()
   local retval =  self:__new()
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
   for i, v in ipairs(self.val)
   do if v == elem
      then
         table.remove(self.val, i)
         break
      end
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
   for key in self:__clone():elems()
   do if not other:is_in(key)
      then
         self:drop(key)
      end
   end
end

--- Dropping all elements which is contained in other set.
--  @param other other set
function Set:diff_set(other)
   for key in self:__clone():elems()
   do if other:is_in(key)
      then
         self:drop(key)
      end
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

--- Is set subset of other?
--  @param other set to be proven whether it is superset
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

--- Makes a list from the elements of my set
--  @return base.type.List
function Set:get_list()
   local retval =  List:empty_list_factory()
   for x in self:elems()
   do retval:append(x)
   end
   return retval
end

--- Get sorted list of all elements contained in my set.
--  @return base.type.List list off all elements, sorted
function Set:get_sorted_list()
   local retval =  self:get_list()
   retval:sort()
   return retval
end

--- choose an element, randomly 
--  @return
function Set:choose_randomly()
   if #self.val > 0
   then
      return self.val[math.ceil(math.random() * #self.val)]
   end
end

--- transforms this set to a list whose elements are ordered randomly
--  @return list
function Set:get_randomly_sorted_list()
   local retval =  self:get_list()
   retval:shuffle()
   return retval
end

function Set:__clone()
   local retval =  Set:empty_set_factory()
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
   indentation:insert(String:string_factory("(base::type::Set"))
   for elem in self:elems()
   do
      indentation:insert(String:string_factory(" "))
      elem:__diagnose_single_line(indentation)
   end
   indentation:insert(String:string_factory(")"))
end

function Set:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(base::type::Set"))
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
