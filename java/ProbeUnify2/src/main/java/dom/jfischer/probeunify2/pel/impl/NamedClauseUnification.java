/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pel.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.IUnification;
import dom.jfischer.probeunify2.pel.INamedClause;
import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;
import dom.jfischer.probeunify2.pel.IPELVariableContext;
import dom.jfischer.probeunify2.proof.IClause;
import dom.jfischer.probeunify2.proof.impl.ClauseUnification;

/**
 *
 * @author jfischer
 */
public class NamedClauseUnification implements IUnification<INamedClause> {

    private final IUnification<IClause> clauseUnification;
    private final IUnification<IPELVariableContext> pelVariableContextUnification
            = new PELVariableContextUnification();

    public NamedClauseUnification(IUnification<IBaseExpression<ILiteralNonVariableExtension>> goalUnification) {
        this.clauseUnification = new ClauseUnification(goalUnification);
    }

    @Override
    public boolean unify(INamedClause arg1, INamedClause arg2) {
        return this.clauseUnification.unify(arg1.getClause(), arg2.getClause())
                && this.pelVariableContextUnification.unify(
                        arg1.getPelVariableContext(),
                        arg2.getPelVariableContext()
                );
    }

}
