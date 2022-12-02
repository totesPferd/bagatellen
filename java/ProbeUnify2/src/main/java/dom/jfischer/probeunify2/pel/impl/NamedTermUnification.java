/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pel.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.ITrivialExtension;
import dom.jfischer.probeunify2.basic.IUnification;
import dom.jfischer.probeunify2.basic.impl.BaseUnification;
import dom.jfischer.probeunify2.pel.INamedTerm;
import dom.jfischer.probeunify2.pel.ITermNonVariableExtension;
import dom.jfischer.probeunify2.basic.impl.VariableContextUnification;
import dom.jfischer.probeunify2.basic.IVariableContext;

/**
 *
 * @author jfischer
 */
public class NamedTermUnification implements IUnification<INamedTerm> {

    private final IUnification<IBaseExpression<ITermNonVariableExtension>> termExpressionUnification
            = new BaseUnification<>();
    private final IUnification<IVariableContext<IBaseExpression<ITrivialExtension>, ITermNonVariableExtension>> termVariableContextUnification
            = new VariableContextUnification<>();

    @Override
    public boolean unify(INamedTerm arg1, INamedTerm arg2) {
        return this.termExpressionUnification.unify(arg1.getTerm(), arg2.getTerm())
                && this.termVariableContextUnification.unify(
                        arg1.getTermVariableContext(),
                        arg2.getTermVariableContext());
    }

}
