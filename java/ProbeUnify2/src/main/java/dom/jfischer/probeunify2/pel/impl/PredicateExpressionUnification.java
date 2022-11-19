/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pel.impl;

import dom.jfischer.probeunify2.basic.IExpression;
import dom.jfischer.probeunify2.basic.IUnification;
import dom.jfischer.probeunify2.basic.impl.Unification;
import dom.jfischer.probeunify2.pel.IPredicate;
import dom.jfischer.probeunify2.pel.IPredicateExpression;
import dom.jfischer.probeunify2.basic.ITrivialExtension;

/**
 *
 * @author jfischer
 */
public class PredicateExpressionUnification implements IUnification<IPredicateExpression> {

    private final IUnification<IExpression<IPredicate, ITrivialExtension>> baseUnification;

    public PredicateExpressionUnification() {
        IUnification<IPredicate> extensionUnification = new PredicateUnification();
        this.baseUnification = new Unification<>(extensionUnification);
    }

    @Override
    public boolean unify(IPredicateExpression arg1, IPredicateExpression arg2) {
        return this.baseUnification.unify(arg1, arg2);
    }

}
