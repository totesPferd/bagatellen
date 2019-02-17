use "logics/constructors.sig";
use "logics/ql/modules.sig";
use "logics/ql/qualifier.sig";

signature QLConstructors =
   sig
      include Constructors
      structure Modules: Modules
      structure Qualifier: Qualifier

      val module: Modules.T -> T
      val qualifier: Qualifier.T -> T

      val traverse: (Modules.T -> 'a) * (Qualifier.T -> 'a) -> T -> 'a
   end
