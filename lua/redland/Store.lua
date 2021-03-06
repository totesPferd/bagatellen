local bindings_redland_module =  require "bindings.redland"
local Type =  require "base.type.aux.Type"

local Store =  Type:__new()


package.loaded["redland.Store"] =  Store
local Indentation =  require "base.Indentation"
local Node =  require "redland.Node"
local Stream =  require "redland.Stream"
local String =  require "base.type.String"
local Transaction =  require "redland.Transaction"
local World =  require "redland.World"

function Store:bindings_store_factory(bindings_store)
   local retval =  Store:__new()
   retval.val =  bindings_store
   return retval
end

function Store:get_bindings_store()
   return self.val
end

function Store:add(stmt, context)
   if context
   then
      return bindings_redland_module.store.context_add(
            self:get_bindings_store()
         ,  context:get_bindings_node()
         ,  stmt:get_bindings_stmt() )
   else
      return bindings_redland_module.store.add(
            self:get_bindings_store()
         ,  stmt:get_bindings_stmt() )
   end
end

function Store:add_stream(stream, context)
   if context
   then
      return bindings_redland_module.store.context_add_stream(
            self:get_bindings_store()
         ,  context:get_bindings_node()
         ,  stream:get_bindings_stream() )
   else
      return bindings_redland_module.store.add_stream(
            self:get_bindings_store()
         ,  stream:get_bindings_stream() )
   end
end

function Store:close()
   return bindings_redland_module.store.close(
         self:get_bindings_store() )
end

function Store:del(stmt, context)
   local bindings_context_node
   if context
   then
      bindings_context_node =  context:get_bindings_node()
   end
   return bindings_redland_module.store.del(
         self:get_bindings_store()
      ,  stmt:get_bindings_store()
      ,  { context = bindings_context_node } )
end

function Store:del_context(stmt, context)
   local bindings_context_node
   if context
   then
      bindings_context_node =  context:get_bindings_node()
   end
   return bindings_redland_module.store.del_context(
         self:get_bindings_store()
      ,  context:get_bindings_node()
      ,  stmt:get_bindings_store() )
end

function Store:find(stmt, context)
   local bindings_context_node
   if context
   then
      bindings_context_node =  context:get_bindings_node()
   end
   return bindings_redland_module.store.find(
         self:get_bindings_store()
      ,  stmt:get_bindings_stmt()
      ,  { context = bindings_context_node } )
end

function Store:find_with_options(stmt, params)
   local bindings_context_node
   if params.context
   then
      bindings_context_node =  params.context:get_bindings_node()
   end
   local bindings_hash
   if params.hash
   then
      bindings_hash =  params.hash:get_bindings_hash()
   end
   return bindings_redland_module.store.find_with_options(
         self:get_bindings_store()
      ,  stmt:get_bindings_stmt()
      ,  { context = bindings_context_node, hash = bindings_hash } )
end

function Store:get_feature(feature)
   local bindings_node =   bindings_redland_module.store.get_feature(
         self:get_bindings_store()
      ,  feature:get_bindings_uri() )
   if bindings_node
   then
      return Node:bindings_node_factory(bindings_node)
   end
end

function Store:get_transaction()
   local bindings_transaction =  bindings_redland_module.store.transaction_get_handle(
         self:get_bindings_store() )
   if bindings_transaction
   then
      return Transaction:bindings_transaction_factory(bindings_transaction)
   end
end

function Store:get_world()
   local bindings_node =   bindings_redland_module.store.get_world(
         self:get_bindings_store() )
   if bindings_node
   then
      return World:bindings_world_factory(bindings_world)
   end
end

function Store:is_containing(stmt)
   return bindings_redland_module.store.is_containing(
         self:get_bindings_store()
      ,  stmt:get_bindings_stmt() )
end

function Store:is_supporting_query(query)
   return bindings_redland_module.store.is_supporting_query(
         self:get_bindings_store()
      ,  query:get_bindings_query() )
end

function Store:is_there_object(subject, predicate)
   return bindings_redland_module.store.is_there_object(
         self:get_bindings_store()
      ,  subject:get_bindings_node()
      ,  predicate:get_bindings_node() )
end

function Store:is_there_subject(object, predicate)
   return bindings_redland_module.store.is_there_object(
         self:get_bindings_store()
      ,  object:get_bindings_node()
      ,  predicate:get_bindings_node() )
end

function Store.lookup(world, idx)
   local raw_result =  bindings_redland_module.store.lookup(
         world:get_bindings_world()
      ,  idx )
   if raw_result
   then
      local label
      if raw_result.label
      then
         label =  String:string_factory(raw_result.label)
      end
      local name
      if raw_result.name
      then
         name =  String:string_factory(raw_result.name)
      end
      return { label = label, name = name }
   end
end

function Store:new(world, hash, storage_name, name)
   local bindings_store =  bindings_redland_module.store.new(
         world:get_bindings_world()
      ,  hash:get_bindings_hash()
      ,  storage_name:get_content()
      ,  name:get_content() )
   if bindings_store
   then
      return self:bindings_store_factory(bindings_store)
   end
end

function Store:open(model)
   return bindings_redland_module.store.open(
         self:get_bindings_store()
      ,  model:get_bindings_model() )
end

function Store:serialize(context)
   if context
   then
      return bindings_redland_module.store.context_serialize(
            self:get_bindings_store()
         ,  context:get_bindings_node() )
   else
      return bindings_redland_module.store.serialize(
            self:get_bindings_store() )
   end
end

function Store:set_feature(feature, value)
   return bindings_redland_module.store.set_feature(
         self:get_bindings_store()
      ,  feature:get_bindings_uri()
      ,  value:get_bindings_node() )
end

function Store:sync()
   return bindings_redland_module.store.sync(
         self:get_bindings_store() )
end

function Store:transaction_commit()
   return bindings_redland_module.store.transaction_commit(
         self:get_bindings_store() )
end

function Store:transaction_rollback()
   return bindings_redland_module.store.transaction_rollback(
         self:get_bindings_store() )
end

function Store:transaction_start(transaction)
   if transaction
   then
      return bindings_redland_module.store.transaction_start_with_handle(
            self:get_bindings_store()
         ,  transaction:get_bindings_transaction() )
   else
      return bindings_redland_module.store.transaction_start(
            self:get_bindings_store() )
   end
end

function Store:__clone()
   return bindings_redland_module.store.__clone(
      self:get_bindings_store() )
end

function Store:__len()
   return bindings_redland_module.store.size(
      self:get_bindings_store() )
end

function Store:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(
         "(redland::Store)" ))
end

function Store:__diagnose_multiple_line(indentation)
   return self:__diagnose_single_line(indentation)
end

return Store


