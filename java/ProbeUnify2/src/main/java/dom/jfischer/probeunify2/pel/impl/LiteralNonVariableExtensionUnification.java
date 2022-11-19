/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pel.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.IUnification;
import dom.jfischer.probeunify2.basic.impl.BaseUnification;
import dom.jfischer.probeunify2.basic.impl.MultiUnification;
import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;
import dom.jfischer.probeunify2.pel.ITermNonVariableExtension;
import java.util.List;

/**
 *
 * @author jfischer
 */
public class LiteralNonVariableExtensionUnification implements IUnification<ILiteralNonVariableExtension> {

    private final IUnification<List<IBaseExpression<ITermNonVariableExtension>>> unification;

    public LiteralNonVariableExtensionUnification() {
        IUnification<IBaseExpression<ITermNonVariableExtension>> termUnification
                = new BaseUnification<>();
        this.unification = new MultiUnification<>(termUnification);
    }

    @Override
    public boolean unify(ILiteralNonVariableExtension arg1, ILiteralNonVariableExtension arg2) {
        return arg1.getPredicate().eq(arg2.getPredicate())
                && this.unification.unify(arg1.getArguments(), arg2.getArguments());
    }

}
