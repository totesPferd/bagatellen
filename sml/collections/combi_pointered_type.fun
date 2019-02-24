use "collections/combi_type.sig";
use "collections/naming_pointered_type_extension.sig";
use "collections/pointered_type.sig";
use "general/sum_type.sig";
use "collections/unit_pointered_type_extension.sig";

functor CombiPointeredType2(X:
   sig
      structure NPT: NamingPointeredTypeExtension
      structure UPT: UnitPointeredTypeExtension
      structure PointerType: CombiType
      structure BaseType: SumType
      sharing BaseType.FstType =  NPT.PointeredType2.BaseType
      sharing BaseType.SndType =  UPT.PointeredType2.BaseType
   end ): PointeredType2 =
   struct
      structure BaseType =  X.BaseType
      structure ContainerType =
         struct
            type T =  X.NPT.PointeredType2.ContainerType.T * X.UPT.PointeredType2.ContainerType.T
         end
      structure PointerType =  X.PointerType

      fun select (pointer, (m_n, m_u))
         =  PointerType.traverse (
                  (fn s => Option.map BaseType.fst_inj (X.NPT.PointeredType2.select(X.NPT.StringType.point s, m_n)))
               ,  (fn () => Option.map BaseType.snd_inj (X.UPT.PointeredType2.select(X.UPT.UnitType.point, m_u))) )
               pointer

      exception NonFunctorial
      fun non_functorial_a x
         =  BaseType.traverse ((fn x => x), (fn y => raise NonFunctorial)) x
      fun non_functorial_b y
         =  BaseType.traverse ((fn x => raise NonFunctorial), (fn y => y)) y
      fun map phi (m_n, m_u)
         =  let
               val m'_n =  X.NPT.PointeredType2.map (fn (x) => non_functorial_a(phi(BaseType.fst_inj x))) m_n
               val m'_u =  X.UPT.PointeredType2.map (fn (x) => non_functorial_b(phi(BaseType.snd_inj x))) m_u
            in
               (m'_n, m'_u)
            end

      val empty =  (X.NPT.PointeredType2.empty, X.UPT.PointeredType2.empty)

      fun is_empty (m_n, m_u) =  (X.NPT.PointeredType2.is_empty m_n) andalso (X.UPT.PointeredType2.is_empty m_u)

      fun all phi (m_n, m_u)
         =   (X.NPT.PointeredType2.all (fn (x) => phi(BaseType.fst_inj x)) m_n)
            andalso
             (X.UPT.PointeredType2.all (fn (x) => phi(BaseType.snd_inj x)) m_u)

      fun all_zip phi ((m_n_1, m_u_1), (m_n_2, m_u_2))
         =   (X.NPT.PointeredType2.all_zip (fn (x, y) => phi(BaseType.fst_inj x, BaseType.fst_inj y)) (m_n_1, m_n_2))
            andalso
             (X.UPT.PointeredType2.all_zip (fn (x, y) => phi(BaseType.snd_inj x, BaseType.snd_inj y)) (m_u_1, m_u_2))

      fun fe b
         =  BaseType.traverse ((fn x => (X.NPT.PointeredType2.fe x, X.UPT.PointeredType2.empty)), (fn x => (X.NPT.PointeredType2.empty, X.UPT.PointeredType2.fe x))) b

      fun fop phi (m_n, m_u)
         =  let
               fun fn_a phi x =  case (phi(BaseType.fst_inj x)) of
                  (a, b) => a
               fun fn_b phi y =  case (phi(BaseType.snd_inj y)) of
                  (a, b) => b
               val m_n_1 =  X.NPT.PointeredType2.fop (fn_a phi) m_n
               val m_u_1 =  X.UPT.PointeredType2.fop (fn_b phi) m_u
            in (m_n_1, m_u_1)
            end

      fun is_in (b, (m_n, m_u))
         =  BaseType.traverse ((fn x => X.NPT.PointeredType2.is_in(x, m_n)), (fn x => X.UPT.PointeredType2.is_in(x, m_u))) b

      fun subeq ((m_n_1, m_u_1), (m_n_2, m_u_2))
         =  X.NPT.PointeredType2.subeq(m_n_1, m_n_2) andalso X.UPT.PointeredType2.subeq(m_u_1, m_u_2)

      fun filter phi (m_n, m_u)
         =  let
               val m_n_1 =  X.NPT.PointeredType2.filter (fn x => phi(BaseType.fst_inj x)) m_n
               val m_u_1 =  X.UPT.PointeredType2.filter (fn x => phi(BaseType.snd_inj x)) m_u
            in (m_n_1, m_u_1)
            end

      fun transition phi (m_n, m_u) b
         =  let
               val b_1 =  X.NPT.PointeredType2.transition (fn (x, b') => phi(BaseType.fst_inj x, b')) m_n b
               val b_2 =  X.UPT.PointeredType2.transition (fn (x, b') => phi(BaseType.snd_inj x, b')) m_u b_1
            in
               b_2
            end

   end;
