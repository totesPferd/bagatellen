use "collections/combi_type.sig";
use "collections/naming_pointered_type_extension.sig";
use "collections/pointered_type_extended.sig";
use "general/sum_type.sig";
use "collections/unit_pointered_type_extension.sig";

functor CombiPointeredTypeExtended(X:
   sig
      structure NPT: NamingPointeredTypeExtension
      structure UPT: UnitPointeredTypeExtension
      structure PointerType: CombiType
      structure BaseType: SumType
      sharing BaseType.FstType =  NPT.PointeredTypeExtended.BaseType
      sharing BaseType.SndType =  UPT.PointeredTypeExtended.BaseType
   end ): PointeredTypeExtended =
   struct
      structure BaseType =  X.BaseType
      structure ContainerType =
         struct
            type T =  X.NPT.PointeredTypeExtended.ContainerType.T * X.UPT.PointeredTypeExtended.ContainerType.T
         end
      structure PointerType =  X.PointerType

      fun select (pointer, (m_n, m_u))
         =  PointerType.traverse (
                  (fn s => Option.map BaseType.fst_inj (X.NPT.PointeredTypeExtended.select(X.NPT.StringType.point s, m_n)))
               ,  (fn () => Option.map BaseType.snd_inj (X.UPT.PointeredTypeExtended.select(X.UPT.UnitType.point, m_u))) )
               pointer

      val empty =  (X.NPT.PointeredTypeExtended.empty, X.UPT.PointeredTypeExtended.empty)

      fun is_empty (m_n, m_u) =  (X.NPT.PointeredTypeExtended.is_empty m_n) andalso (X.UPT.PointeredTypeExtended.is_empty m_u)

      fun all phi (m_n, m_u)
         =   (X.NPT.PointeredTypeExtended.all (fn (x) => phi(BaseType.fst_inj x)) m_n)
            andalso
             (X.UPT.PointeredTypeExtended.all (fn (x) => phi(BaseType.snd_inj x)) m_u)

      fun all_zip phi ((m_n_1, m_u_1), (m_n_2, m_u_2))
         =   (X.NPT.PointeredTypeExtended.all_zip (fn (x, y) => phi(BaseType.fst_inj x, BaseType.fst_inj y)) (m_n_1, m_n_2))
            andalso
             (X.UPT.PointeredTypeExtended.all_zip (fn (x, y) => phi(BaseType.snd_inj x, BaseType.snd_inj y)) (m_u_1, m_u_2))

      fun fe b
         =  BaseType.traverse ((fn x => (X.NPT.PointeredTypeExtended.fe x, X.UPT.PointeredTypeExtended.empty)), (fn x => (X.NPT.PointeredTypeExtended.empty, X.UPT.PointeredTypeExtended.fe x))) b

      fun fop phi (m_n, m_u)
         =  let
               fun fn_a phi x =  case (phi(BaseType.fst_inj x)) of
                  (a, b) => a
               fun fn_b phi y =  case (phi(BaseType.snd_inj y)) of
                  (a, b) => b
               val m_n_1 =  X.NPT.PointeredTypeExtended.fop (fn_a phi) m_n
               val m_u_1 =  X.UPT.PointeredTypeExtended.fop (fn_b phi) m_u
            in (m_n_1, m_u_1)
            end

      fun is_in (b, (m_n, m_u))
         =  BaseType.traverse ((fn x => X.NPT.PointeredTypeExtended.is_in(x, m_n)), (fn x => X.UPT.PointeredTypeExtended.is_in(x, m_u))) b

      fun subeq ((m_n_1, m_u_1), (m_n_2, m_u_2))
         =  X.NPT.PointeredTypeExtended.subeq(m_n_1, m_n_2) andalso X.UPT.PointeredTypeExtended.subeq(m_u_1, m_u_2)

      fun filter phi (m_n, m_u)
         =  let
               val m_n_1 =  X.NPT.PointeredTypeExtended.filter (fn x => phi(BaseType.fst_inj x)) m_n
               val m_u_1 =  X.UPT.PointeredTypeExtended.filter (fn x => phi(BaseType.snd_inj x)) m_u
            in (m_n_1, m_u_1)
            end

      fun transition phi (m_n, m_u) b
         =  let
               val b_1 =  X.NPT.PointeredTypeExtended.transition (fn (x, b') => phi(BaseType.fst_inj x, b')) m_n b
               val b_2 =  X.UPT.PointeredTypeExtended.transition (fn (x, b') => phi(BaseType.snd_inj x, b')) m_u b_1
            in
               b_2
            end

   end;
