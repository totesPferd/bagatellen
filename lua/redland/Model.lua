local bindings_redland_module =  require "bindings.redland"
local Type =  require "base.type.aux.Type"

local Model =  Type:__new()


package.loaded["redland.Model"] =  Model
local Indentation =  require "base.Indentation"
local Node =  require "redland.Node"
local Results =  require "redland.Results"
local Store =  require "redland.Store"
local Stream =  require "redland.Stream"
local String =  require "base.type.String"
local Transaction =  require "redland.Transaction"
local World =  require "redland.World"

function Model:bindings_model_factory(bindings_model)
   local retval =  Model:__new()
   retval.val =  bindings_model
   return retval
end

function Model:get_bindings_model()
   return self.val
end

function Model:add(stmt, context)
   if context
   then
      return bindings_redland_module.model.context_add(
            self:get_bindings_model()
         ,  context:get_bindings_node()
         ,  stmt:get_bindings_stmt() )
   else
      return bindings_redland_module.model.add(
            self:get_bindings_model()
         ,  stmt:get_bindings_stmt() )
   end
end

function Model:add_stream(stream, context)
   if context
   then
      return bindings_redland_module.model.context_add_stream(
            self:get_bindings_model()
         ,  context:get_bindings_node()
         ,  stream:get_bindings_stream() )
   else
      return bindings_redland_module.model.add_stream(
            self:get_bindings_model()
         ,  stream:get_bindings_stream() )
   end
end

function Model:close()
   return bindings_redland_module.model.close(
         self:get_bindings_model() )
end

function Model:del(stmt, context)
   local bindings_context_node
   if context
   then
      bindings_context_node =  context:get_bindings_node()
   end
   return bindings_redland_module.model.del(
         self:get_bindings_model()
      ,  stmt:get_bindings_model()
      ,  { context = bindings_context_node } )
end

function Model:del_context(stmt, context)
   local bindings_context_node
   if context
   then
      bindings_context_node =  context:get_bindings_node()
   end
   return bindings_redland_module.model.del_context(
         self:get_bindings_model()
      ,  context:get_bindings_node()
      ,  stmt:get_bindings_model() )
end

function Model:find(stmt, context)
   local bindings_context_node
   if context
   then
      bindings_context_node =  context:get_bindings_node()
   end
   return bindings_redland_module.model.find(
         self:get_bindings_model()
      ,  stmt:get_bindings_stmt()
      ,  { context = bindings_context_node } )
end

function Model:find_with_options(stmt, params)
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
   return bindings_redland_module.model.find_with_options(
         self:get_bindings_model()
      ,  stmt:get_bindings_stmt()
      ,  { context = bindings_context_node, hash = bindings_hash } )
end

function Model:get_feature(feature)
   local bindings_node =   bindings_redland_module.model.get_feature(
         self:get_bindings_model()
      ,  feature:get_bindings_uri() )
   if bindings_node
   then
      return Node:bindings_node_factory(bindings_node)
   end
end

function Model:get_object(subject, predicate)
   local bindings_node =  bindings_redland_module.model.get_object(
         self:get_bindings_model()
      ,  subject:get_bindings_node()
      ,  predicate:get_bindings_node() )
   if bindings_node
   then
      Node:bindings_node_factory(bindings_node)
   end
end

function Model:get_predicate(subject, object)
   local bindings_node =  bindings_redland_module.model.get_predicate(
         self:get_bindings_model()
      ,  subject:get_bindings_node()
      ,  object:get_bindings_node() )
   if bindings_node
   then
      Node:bindings_node_factory(bindings_node)
   end
end

function Model:get_store()
   local bindings_store =  bindings_redland_module.model.get_store(
         self:get_bindings_model() )
   if bindings_store
   then
      Store:bindings_store_factory(bindings_store)
   end
end

function Model:get_subject(predicate, object)
   local bindings_node =  bindings_redland_module.model.get_predicate(
         self:get_bindings_model()
      ,  predicate:get_bindings_node()
      ,  object:get_bindings_node() )
   if bindings_node
   then
      Node:bindings_node_factory(bindings_node)
   end
end

function Model:get_transaction()
   local bindings_transaction =  bindings_redland_module.model.transaction_get_handle(
         self:get_bindings_model() )
   if bindings_transaction
   then
      return Transaction:bindings_transaction_factory(bindings_transaction)
   end
end

function Model:is_containing(stmt)
   return bindings_redland_module.model.is_containing(
         self:get_bindings_model()
      ,  stmt:get_bindings_stmt() )
end

function Model:is_containing_context(context)
   return bindings_redland_module.model.is_containing_context(
         self:get_bindings_model()
      ,  context:get_bindings_node() )
end

function Model:is_supporting_contexts()
   return bindings_redland_module.model.is_supporting_contexts(
         self:get_bindings_model() )
end

function Model:is_supporting_query(query)
   return bindings_redland_module.model.is_supporting_query(
         self:get_bindings_model()
      ,  query:get_bindings_query() )
end

function Model:is_there_object(subject, predicate)
   return bindings_redland_module.model.is_there_object(
         self:get_bindings_model()
      ,  subject:get_bindings_node()
      ,  predicate:get_bindings_node() )
end

function Model:is_there_subject(object, predicate)
   return bindings_redland_module.model.is_there_object(
         self:get_bindings_model()
      ,  object:get_bindings_node()
      ,  predicate:get_bindings_node() )
end

function Model:load(uri, params)
   local name_str
   if params.name
   then
      name_str =  params.name:get_content()
   end
   local mime_type_str
   if params.mime_type
   then
      mime_type_str =  params.mime_type:get_content()
   end
   local bindings_type_uri
   if params.type
   then
      bindings_type_uri =  params.type.get_bindings_uri()
   end

   return bindings_redland_module.model.load(
         self:get_bindings_model()
      ,  uri:get_bindings_uri()
      ,  { name =  name_str, mime_type =  mime_type_str, type =  bindings_type_uri } )
end

function Model.lookup(world, idx)
   local raw_result =  bindings_redland_module.model.lookup(
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

function Model:new(world, store, hash)
   local bindings_model =  bindings_redland_module.model.new(
         world:get_bindings_world()
      ,  store:get_bindings_store()
      ,  hash:get_bindings_hash() )
   if bindings_model
   then
      return self:bindings_model_factory(bindings_model)
   end
end

function Model:open(model)
   return bindings_redland_module.model.open(
         self:get_bindings_model()
      ,  model:get_bindings_model() )
end

function Model:query(query)
   local bindings_results =  bindings_redland_module.model.query(
         self:get_bindings_model()
      ,  query:get_bindings_query() )
   if bindings_results
   then
      return Results:bindings_results_factory(bindings_results)
   end
end

function Model:serialize(context)
   if context
   then
      return bindings_redland_module.model.context_serialize(
            self:get_bindings_model()
         ,  context:get_bindings_node() )
   else
      return bindings_redland_module.model.serialize(
            self:get_bindings_model() )
   end
end

function Model:set_feature(feature, value)
   return bindings_redland_module.model.set_feature(
         self:get_bindings_model()
      ,  feature:get_bindings_uri()
      ,  value:get_bindings_node() )
end

function Model:sync()
   return bindings_redland_module.model.sync(
         self:get_bindings_model() )
end

function Model:to_string(base_uri, params)
   local name_str
   if params.name
   then
      name_str =  params.name:get_content()
   end
   local mime_type_str
   if params.mime_type
   then
      mime_type_str =  params.mime_type:get_content()
   end
   local bindings_type_uri
   if params.type
   then
      bindings_type_uri =  params.type:get_bindings_uri()
   end

   local raw_result_string =  bindings_redland_module.model.to_string(
         self:get_bindings_model()
      ,  base_uri:get_bindings_uri()
      ,  { name =  name_str, mime_type =  mime_type_str, type =  bindings_type_uri } )
   if raw_result_string
   then
      return String:string_factory(raw_result_string)
   end
end

function Model:transaction_commit()
   return bindings_redland_module.model.transaction_commit(
         self:get_bindings_model() )
end

function Model:transaction_rollback()
   return bindings_redland_module.model.transaction_rollback(
         self:get_bindings_model() )
end

function Model:transaction_start(transaction)
   if transaction
   then
      return bindings_redland_module.model.transaction_start_with_handle(
            self:get_bindings_model()
         ,  transaction:get_bindings_transaction() )
   else
      return bindings_redland_module.model.transaction_start(
            self:get_bindings_model() )
   end
end

function Model:__clone()
   return bindings_redland_module.model.__clone(
      self:get_bindings_model() )
end

function Model:__len()
   return bindings_redland_module.model.size(
      self:get_bindings_model() )
end

function Model:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(
         "(redland.Model)" ))
end

function Model:__diagnose_multiple_line(indentation)
   return self:__diagnose_single_line(indentation)
end

return Model


