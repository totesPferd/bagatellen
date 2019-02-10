use "collections/eqs.sig";
use "collections/pointered_type.sig";
use "collections/type.sig";
use "collections/unit_type.sig";

signature UnitPointeredType =
   sig
     structure UnitType: UnitType
     structure PointeredType: PointeredType
     sharing PointeredType.PointerType =  UnitType

   end;

