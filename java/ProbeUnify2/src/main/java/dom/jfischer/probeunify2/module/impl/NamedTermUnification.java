/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.module.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.IUnification;
import dom.jfischer.probeunify2.basic.impl.BaseUnification;
import dom.jfischer.probeunify2.module.INamedTerm;
import dom.jfischer.probeunify2.pel.ITermNonVariableExtension;

/**
 *
 * @author jfischer
 */
public class NamedTermUnification implements IUnification<INamedTerm> {

    private final IUnification<IBaseExpression<ITermNonVariableExtension>> termExpressionUnification
            = new BaseUnification<>();

    @Override
    public boolean unify(INamedTerm arg1, INamedTerm arg2) {
        boolean retval = this.termExpressionUnification.unify(arg1.getTerm(), arg2.getTerm());
        if (retval) {
            arg1.getTermVariableContext().unify(arg2.getTermVariableContext());
        }
        return retval;
    }

}
