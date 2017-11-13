local Type =  require "base.type.aux.Type"

local List =  Type:__new()


package.loaded["base.type.List"] =  List
local Indentation =  require "base.Indentation"
local String =  require "base.type.String"

--- Factory method factoring empty list.
--  @return empty list object
function List:empty_list_factory()
   local retval =  self:__new()
   retval.val =  {}
   return retval
end

--- Factory method factoring list containing elems von lua list l
--  @param l
--  @return
function List:list_factory(l)
   local retval =  List:empty_list_factory()
   for k, v in pairs(l)
   do retval:append(v)
   end
   return retval
end

--- Is my list empty?
--  @return boolean
function List:is_empty()
   return #self.val == 0
end

--- Does list end with other?
--  @return boolean
function List:is_final_seq(other)
   local diff_len =  #self.val - #other.val
   if diff_len >= 0
   then
      local i
      for i = 1, #other.val
      do if self.val[i + diff_len] ~= other.val[i]
         then
            return false
         end
      end
      return true
   end
   return false
end

--- Does list starts with other?
--  @return boolean
function List:is_initial_seq(other)
   local diff_len =  #self.val - #other.val
   if diff_len >= 0
   then
      local i
      for i = 1, #other.val
      do if self.val[i] ~= other.val[i]
         then
            return false
         end
      end
      return true
   end
   return false
end

--- if other is final seq then drop it
--  @param List
--  @return boolean
function List:drop_final_seq(other)
   local retval =  self:is_final_seq(other)
   if retval
   then
      local diff_len =  #self.val - #other.val
      local i
      local e =  #self.val
      for i =  diff_len + 1, e
      do table.remove(self.val)
      end
   end
   return retval
end

--- if other is initial seq then drop it
--  @param List
--  @return boolean
function List:drop_initial_seq(other)
   local retval =  self:is_initial_seq(other)
   if retval
   then
      local diff_len =  #self.val - #other.val
      local i
      local e =  #self.val
      for i =  diff_len + 1, e
      do table.remove(self.val, 1)
      end
   end
   return retval
end

--- Appending an element at the right-hand side of a list.
--  @param elem element
function List:append(elem)
   table.insert(self.val, elem)
end

--- Prepending an element at the left-hand side of a list.
--  @param elem element
function List:prepend(elem)
   table.insert(self.val, 1, elem)
end

--- Appending another list at the right-hand side of a list.
--  @param other the list to be appended
function List:append_list(other)
   for elem in other:elems()
   do self:append(elem)
   end
end

--- Iterator iterating over all elements in a list.
--  @usage Use it as follows:<blockquote><code>
--  for elem in l:elems()<br/>
--  do &laquo; ... do this and that with elem ... &raquo;<br/> 
--  end<br/>
function List:elems()
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

--- Get first element
--  @return first element
function List:get_head()
   return self.val[1]
end

--- Drop first element
function List:cut_head()
   table.remove(self.val, 1)
end

--- Get last element
--  @return last element
function List:get_tail()
   return self.val[#self.val]
end

--- Drop last element
function List:cut_tail()
   table.remove(self.val, #self.val)
end

--- Lower or equal according to lexicographical ordering.
--  @param other list to be compared
--  @return boolean
function List:lexicographically_le(other)
   local itFun, itState =  other:elems()
   local retval =  true
   for elem in self:elems()
   do local other_elem =  itFun(itState, other_elem)
      if other_elem
      then
         if elem ~= other_elem
         then
            if not (elem:__le(other_elem))
            then
               retval =  false
            end
            break
         end
      else
         retval =  false
         break
      end
   end
   return retval
end

--- choose an element, randomly 
--  @return
function List:choose_randomly()
   if #self.val > 0
   then
      return self.val[math.ceil(math.random() * #self.val)]
   end
end

function List:__len()
   return #self.val
end

function List:__concat(other)
   local retval =  self:empty_list_factory()
   retval:append_list(self)
   retval:append_list(other)
   return retval
end

function List:__eq(other)
   local itFun, itState =  other:elems()
   local retval =  true
   local other_elem
   for elem in self:elems()
   do other_elem =  itFun(itState, other_elem)
      if not (other_elem and elem == other_elem)
      then
         retval =  false
         break
      end
   end
   if retval and itFun(itState, other_elem)
   then
      retval =  false
   end
   return retval
end

function List:__tostring()
   local retval =  "("
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
   retval =  retval .. ")"
   return retval
end

--- Sorting list elements.
function List:sort()
   table.sort(self.val)
end

--- Exchange List.
--  @param base.type.List other other list
--  @return integer How many elements must be dropped from right-hand side?
--  @return base.type.List Which elements must be added at the right-hand
--     side to get other?
function List:exchange(other)
   local nrDiff =  #self.val
   local idxOldList =  1
   local oldList =  self.val
   local diff =  List:empty_list_factory()
   local state =  "initial"
   local val =  {}

   for elem in other:elems()
   do if state == "initial"
      then
         if elem ~= oldList[idxOldList]
         then
            state =  "working"
         end
      end
      if state == "working"
      then
         diff:append(elem)
      else
         nrDiff =  nrDiff - 1
      end
      val[idxOldList] =  elem
      idxOldList =  idxOldList + 1
   end

   self.val =  val
   return nrDiff, diff
end

function List:__clone()
   local retval =  self:empty_list_factory()
   for elem in self:elems()
   do retval:append(elem)
   end
   return retval
end

function List:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(base::type::List"))
   for elem in self:elems()
   do
      indentation:insert(String:string_factory(" "))
      elem:__diagnose_single_line(indentation)
   end
   indentation:insert(String:string_factory(")"))
end

function List:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(base::type::List"))
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

return List
