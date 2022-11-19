/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pel.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.IUnification;
import dom.jfischer.probeunify2.basic.impl.BaseUnification;
import dom.jfischer.probeunify2.basic.impl.MultiUnification;
import dom.jfischer.probeunify2.pel.ITermNonVariableExtension;
import java.util.List;

/**
 *
 * @author jfischer
 */
public class TermNonVariableExtensionUnification implements IUnification<ITermNonVariableExtension> {

    private final IUnification<List<IBaseExpression<ITermNonVariableExtension>>> unification;

    public TermNonVariableExtensionUnification() {
        IUnification<IBaseExpression<ITermNonVariableExtension>> termUnification
                = new BaseUnification<>();
        this.unification = new MultiUnification<>(termUnification);
    }

    @Override
    public boolean unify(ITermNonVariableExtension arg1, ITermNonVariableExtension arg2) {
        return arg1.getOperation().eq(arg2.getOperation())
                && this.unification.unify(arg1.getArguments(), arg2.getArguments());
    }

}
