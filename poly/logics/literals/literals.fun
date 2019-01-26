use "logics/constructors.sig";
use "logics/literals.sig";
use "logics/variables/variables.str";

functor Literals(C: Constructors): Literals =
   struct
      structure Constructors =  C
      structure Variables = Variables

      datatype T =  Construction of Constructors.Constructor * T list |  Variable of T Variables.Variable
      type MultiLiteral =  T list

      fun get_val (p as Construction(c, xi)) =  p
        | get_val (p as Variable x)
        = case (Variables.get_val x) of
             Option.NONE => p
          |  Option.SOME k => get_val k

      fun eq(k, l)
        = case (get_val k, get_val l) of
             (Construction(c, xi), Construction(d, ypsilon))
                => Constructors.eq(c, d) andalso multi_eq(xi, ypsilon)
          |  (Construction(c, xi), Variable y) => false
          |  (Variable x, Construction(d, ypsilon)) => false
          |  (Variable x, Variable y) =>  Variables.eq(x, y)

      and multi_eq(xi, ypsilon) =  List.all (eq) (ListPair.zip(xi, ypsilon))

      fun equate(k, l)
        = case (get_val k, get_val l) of
             (Construction(c, xi), Construction(d, ypsilon))
          => if Constructors.eq(c, d)
             then
               multi_equate(xi, ypsilon)
            else
               false
          |  (Construction(c, xi), Variable y) =>  false
          |  (Variable x, l)
          => Variables.set_val l x

      and multi_equate(xi, ypsilon) =  ListPair.all (equate) (xi, ypsilon)

      fun pmap f (Construction(c, xi))
        = (
             case (multi_pmap f xi) of
                Option.NONE => Option.NONE
             |  Option.SOME ypsilon =>  Option.SOME (Construction(c, ypsilon)) )
        | pmap f (Variable x)
        = (
             case (f x) of
                Option.NONE =>  Option.NONE
             |  Option.SOME y =>  Option.SOME (Variable y) )
      and multi_pmap f nil =  Option.SOME nil
        | multi_pmap f (x :: xi)
        = (
             case (pmap f x) of
                Option.NONE =>  Option.NONE
             |  Option.SOME y =>
                   case (multi_pmap f xi) of
                      Option.NONE =>  Option.NONE
                   |  Option.SOME ypsilon =>  Option.SOME (y :: ypsilon) )
   end;
