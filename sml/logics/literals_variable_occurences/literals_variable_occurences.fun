use "collections/dictset.sig";
use "collections/occurences.sig";
use "collections/pointered_type.sig";
use "logics/constructors.sig";
use "logics/literals.sig";
use "logics/literals_variable_occurences.sig";

functor LiteralsVariableOccurences(X:
   sig
      structure DS: DictSet
      structure Lit: Literals
      structure Occ: Occurences
      structure PT: PointeredType
      sharing DS.Eqs = Lit.Variables
      sharing Occ.DictSet = DS
      sharing PT.BaseType = Lit.Single
      sharing PT.ContainerType = Lit.Multi
      sharing PT.PointerType = Lit.PointerType
   end ): LiteralsVariableOccurences =
   struct
      structure Constructors =  X.Lit.Constructors
      structure Literals =  X.Lit
      structure Occurences =  X.Occ
      structure Variables =  X.Lit.Variables

      datatype Construction =  Construction of Constructors.T * MultiConstruction | Variable of Variables.T
      and      MultiConstruction =  MultiConstruction of Construction list

      val mc_nil =  MultiConstruction nil
      fun mc_cons (x, (MultiConstruction l)) =  MultiConstruction (x::l)

      val reconstruct
         =  X.Lit.Single.traverse (
               Construction
            ,  Variable
            ,  (Option.SOME o mc_cons)
            ,  mc_nil )
      val multi_reconstruct
         =  X.Lit.Multi.traverse (
               Construction
            ,  Variable
            ,  (Option.SOME o mc_cons)
            ,  mc_nil )

      fun this_get_occurences (Construction(c, xi)) =  this_multi_get_occurences xi
      |   this_get_occurences (Variable x) =  X.Occ.singleton(x)
      and this_multi_get_occurences (MultiConstruction xi)
         =  List.foldl
              (  fn (t, occ) => X.Occ.unif_occurences (this_get_occurences t, occ))
              X.Occ.empty
              xi

      val get_occurences =  this_get_occurences o reconstruct
      val multi_get_occurences =  this_multi_get_occurences o multi_reconstruct

   end;
