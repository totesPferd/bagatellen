structure Probe_init =
   struct

      type constructor_t =  string
      type 'a polymorphic_container_t =  'a list
      type 'a polymorphic_variable_t =  'a ref

      datatype construction_dt =
            Construction of constructor_t * construction_dt polymorphic_container_t
         |  Variable of construction_dt polymorphic_variable_t

      type literal_t =  construction_dt polymorphic_container_t

   end;

structure Probe_rec =
   struct

      type constructor_t =  string
      type 'a polymorphic_container_t =  'a list
      type 'a polymorphic_variable_t =  'a ref

      datatype construction_dt =
            Construction of constructor_t * Probe_init.literal_t * construction_dt polymorphic_container_t
         |  Variable of construction_dt polymorphic_variable_t

   end;
