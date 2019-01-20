pub trait Selector {
   type selector;
}

impl<L: crate::literal::Literal> Selector for Option<L> { type selector = (); }
impl<L: crate::literal::Literal> Selector for std::collections::BTreeSet<L> { type selector = L; }
impl<L: crate::literal::Literal> Selector for std::collections::HashSet<L> { type selector = L; }
