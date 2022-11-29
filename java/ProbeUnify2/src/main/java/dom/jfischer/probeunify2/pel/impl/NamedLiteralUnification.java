/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pel.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.IUnification;
import dom.jfischer.probeunify2.basic.impl.BaseUnification;
import dom.jfischer.probeunify2.pel.INamedLiteral;
import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;
import dom.jfischer.probeunify2.pel.IPELVariableContext;

/**
 *
 * @author jfischer
 */
public class NamedLiteralUnification implements IUnification<INamedLiteral> {

    private final IUnification<IBaseExpression<ILiteralNonVariableExtension>> literalExpressionUnification
            = new BaseUnification<>();
    private final IUnification<IPELVariableContext> pelVariableContextUnification
            = new PELVariableContextUnification();

    @Override
    public boolean unify(INamedLiteral arg1, INamedLiteral arg2) {
        return this.literalExpressionUnification.unify(arg1.getLiteral(), arg2.getLiteral())
                && this.pelVariableContextUnification.unify(
                        arg1.getPelVariableContext(),
                        arg2.getPelVariableContext());
    }

}
