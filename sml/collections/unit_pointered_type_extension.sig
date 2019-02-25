use "collections/pointered_type.sig";
use "collections/unit_type.sig";
use "general/eqs.sig";
use "general/type.sig";
use "pointered_types/pointered_singleton.sig";

signature UnitPointeredTypeExtension =
   sig
     structure UnitType: UnitType
     structure PointeredType2: PointeredType2
     sharing PointeredType2.PointerType =  UnitType

     structure PointeredSingleton: PointeredSingleton
     sharing PointeredSingleton.PointeredType =  PointeredType2
     sharing PointeredSingleton.PointerType =  UnitType

   end;

