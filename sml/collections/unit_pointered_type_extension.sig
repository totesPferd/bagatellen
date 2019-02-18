use "collections/eqs.sig";
use "collections/pointered_type.sig";
use "collections/type.sig";
use "collections/unit_type.sig";

signature UnitPointeredTypeExtension =
   sig
     structure UnitType: UnitType
     structure PointeredType: PointeredType
     sharing PointeredType.PointerType =  UnitType

   end;

