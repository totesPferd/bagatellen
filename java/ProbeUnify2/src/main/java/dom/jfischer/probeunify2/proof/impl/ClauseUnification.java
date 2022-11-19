/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.proof.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.IUnification;
import dom.jfischer.probeunify2.basic.impl.BaseUnification;
import dom.jfischer.probeunify2.basic.impl.MultiUnification;
import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;
import dom.jfischer.probeunify2.proof.IClause;
import java.util.List;

/**
 *
 * @author jfischer
 */
public class ClauseUnification implements IUnification<IClause> {

    private final IUnification<IBaseExpression<ILiteralNonVariableExtension>> unification;
    private final IUnification<List<IBaseExpression<ILiteralNonVariableExtension>>> multiUnification;

    public ClauseUnification() {
        this.unification = new BaseUnification<>();
        this.multiUnification = new MultiUnification<>(this.unification);
    }

    @Override
    public boolean unify(IClause arg1, IClause arg2) {
        return this.multiUnification.unify(arg1.getPremises(), arg2.getPremises())
                && this.unification.unify(arg1.getConclusion(), arg2.getConclusion());
    }

}
