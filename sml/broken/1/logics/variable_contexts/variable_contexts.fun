use "collections/all_zip.sig";
use "collections/dict_map.sig";
use "collections/dictset.sig";
use "collections/pointered_type_extended.sig";
use "general/base_map.sig";
use "logics/literals.sig";
use "logics/variable_contexts.sig";
use "logics/variables.sig";
use "pointered_types/pointered_functor.sig";

functor VariableContexts(X:
   sig
      structure AZ: AllZip
      structure PF: PointeredFunctor
      structure PT: PointeredTypeExtended
      structure DM: DictMap
      structure DS: DictSet
      structure VM: BaseMap
      structure VarStruct: VariableStructure
      sharing AZ.BinaryRelation = VarStruct.BinaryRelation
      sharing AZ.PointeredType =  PT
      sharing PT.BaseStructure = VarStruct
      sharing PT.BaseStructureMap = VarStruct.Map
      sharing DM.DictSet = DS
      sharing DM.Start = PT.BaseType
      sharing DM.End = PT.BaseType
      sharing DS.Eqs = PT.BaseType
      sharing PF.Start = PT
      sharing PF.End = PT
      sharing PF.Map = VM
      sharing VM.Start = DM.Start
      sharing VM.End = DM.End
   end): VariableContexts =
   struct
      structure Dicts =  X.DS.Dicts
      structure DictMap = X.DM

      structure Map = X.VM

      structure VariableStructure =  X.VarStruct
      structure PointeredTypeExtended =  X.PT

      structure VariableContext =
         struct
            structure Map =  Map
            type T =  X.PT.ContainerType.T
            val eq =  X.AZ.result (X.VarStruct.eq)
            val vmap =  X.PF.map
         end;

      type AlphaConverter = { ctxt: VariableContext.T, alpha: X.PT.BaseType.T Dicts.dict }

      val get_variable_context: AlphaConverter -> VariableContext.T =  #ctxt

      fun alpha_convert (vc: VariableContext.T)
        = let
             val vcopy: X.VM.End.T -> X.VM.End.T =  X.PT.base_map VariableStructure.copy
             val var_dict: X.VM.End.T Dicts.dict
                =  X.PT.transition
                      (fn (v, d) => Option.SOME (Dicts.set(v, vcopy v, d)))
                      vc
                      Dicts.empty
             val dict_map: DictMap.Map.T =  DictMap.get_map var_dict
             val fun_map: X.PT.BaseType.T -> X.PT.BaseType.T =  DictMap.apply dict_map
             val vm_map =  X.VM.get_map fun_map
             val ctxt_map =  X.PF.map vm_map
             val vc' =  ctxt_map vc
          in
             { ctxt = vc', alpha = var_dict }: AlphaConverter
          end

      fun apply_alpha_converter (alpha: AlphaConverter) =  X.VM.get_map(X.DM.apply(X.DM.get_map(#alpha alpha)))

   end;
