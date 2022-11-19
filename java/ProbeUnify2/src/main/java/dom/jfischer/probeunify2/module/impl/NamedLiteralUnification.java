/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.module.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.IUnification;
import dom.jfischer.probeunify2.basic.impl.BaseUnification;
import dom.jfischer.probeunify2.module.INamedLiteral;
import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;

/**
 *
 * @author jfischer
 */
public class NamedLiteralUnification implements IUnification<INamedLiteral> {

    private final IUnification<IBaseExpression<ILiteralNonVariableExtension>> literalExpressionUnification
            = new BaseUnification<>();

    @Override
    public boolean unify(INamedLiteral arg1, INamedLiteral arg2) {
        boolean retval = this.literalExpressionUnification.unify(arg1.getLiteral(), arg2.getLiteral());
        if (retval) {
            arg1.getTermVariableContext().unify(arg2.getTermVariableContext());
        }
        return retval;
    }

}
