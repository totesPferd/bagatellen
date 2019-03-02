use "collections/pointered_type_extended.sig";
use "collections/unit_type.sig";
use "general/eqs.sig";
use "general/type.sig";
use "pointered_types/pointered_singleton.sig";

signature UnitPointeredTypeExtension =
   sig
     structure UnitType: UnitType
     structure PointeredTypeExtended: PointeredTypeExtended
     sharing PointeredTypeExtended.PointerType =  UnitType

     structure PointeredSingleton: PointeredSingleton
     sharing PointeredSingleton.PointeredType =  PointeredTypeExtended
     sharing PointeredSingleton.PointerType =  UnitType

   end;

