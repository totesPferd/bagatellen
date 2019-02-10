use "logics/constructors.sig";
use "logics/ql/modules.sig";
use "logics/ql/qualifier.sig";

signature QLConstructors =
   sig
      include Constructors
      structure Modules: Modules
      structure Qualifier: Qualifier
   end;
