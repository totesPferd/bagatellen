use "general/string_utils.sml";
use "general/transition_type_by_list.fun";
use "pprint/able_by_construction_a.fun";
use "pprint/base.fun";
use "pprint/config.sig";
use "pprint/construction_a_for_string.fun";
use "pprint/construction_a_for_transition_type.fun";

structure MyCfg:PPrintConfig =
   struct
      val indent =  3
      val page_width = 96 
   end;

structure MyBase =  PPrintBase(
   struct
      structure StringUtils =  StringUtils
      structure Config =  MyCfg
   end );

structure MyTTBL =  TransitionTypeByList(
   struct
      type base_t =  string
   end );

structure MyCAFS =  PPrintConstructionAForString(
   struct
      type context_t = unit
      structure Base =  MyBase
   end );

structure MyASimple =  PPrintAbleByConstructionA(
   struct
      structure Base = MyBase
      structure ConstructionA = MyCAFS
   end );

structure MyCAFTT =  PPrintConstructionAForTransitionType(
   struct
      val delim =  ","
      structure Able = MyASimple
      structure Base = MyBase
      structure ConstructionA = MyCAFS
      structure TransitionType = MyTTBL
   end );

structure MyAList =  PPrintAbleByConstructionA(
   struct
      structure Base = MyBase
      structure ConstructionA = MyCAFTT
   end );

val state =  MyBase.init;

fun print_list l state =  (
      MyBase.print_open_par(TextIO.stdOut, "[") state
   ;  MyAList.pprint(TextIO.stdOut, (), l) state
   ;  MyBase.print_close_par(TextIO.stdOut, "]") state );

(
   MyBase.print_tok(TextIO.stdOut, "erster Versuch") state;
   MyBase.print_nl(TextIO.stdOut) state;
   print_list nil state;
   MyBase.print_nl(TextIO.stdOut) state;

   MyBase.print_nl(TextIO.stdOut) state;
   MyBase.print_tok(TextIO.stdOut, "zweiter Versuch") state;
   MyBase.print_nl(TextIO.stdOut) state;
   print_list [ "eins" ] state;
   MyBase.print_nl(TextIO.stdOut) state;

   MyBase.print_nl(TextIO.stdOut) state;
   MyBase.print_tok(TextIO.stdOut, "dritter Versuch") state;
   MyBase.print_nl(TextIO.stdOut) state;
   print_list [ "eins", "zwei" ] state;
   MyBase.print_nl(TextIO.stdOut) state;

   MyBase.print_nl(TextIO.stdOut) state;
   MyBase.print_tok(TextIO.stdOut, "dritter Versuch") state;
   MyBase.print_nl(TextIO.stdOut) state;
   print_list [ "superkalifragilistische-expiallegorisch", "Isopropylprophenylbarbitursaures Phenyldimethyldimethyldiaminopyrazenon" ] state;
   MyBase.print_nl(TextIO.stdOut) state;

   MyBase.print_nl(TextIO.stdOut) state;
   MyBase.print_tok(TextIO.stdOut, "Ende der Vorstellung") state;
   MyBase.print_nl(TextIO.stdOut) state )
