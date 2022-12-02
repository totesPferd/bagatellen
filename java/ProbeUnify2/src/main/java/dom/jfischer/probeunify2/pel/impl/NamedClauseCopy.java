/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pel.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.ICopy;
import dom.jfischer.probeunify2.pel.INamedClause;
import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;
import dom.jfischer.probeunify2.pel.IPELLeafCollector;
import dom.jfischer.probeunify2.pel.IPELTracker;
import dom.jfischer.probeunify2.pel.IPELVariableContext;
import dom.jfischer.probeunify2.proof.IClause;
import dom.jfischer.probeunify2.proof.impl.ClauseCopy;

/**
 *
 * @author jfischer
 */
public class NamedClauseCopy implements ICopy<INamedClause> {

    private final ICopy<IPELVariableContext> pelVariableContextCopier
            = new PELVariableContextCopy();
    private final ICopy<IClause> clauseCopier;

    public NamedClauseCopy(ICopy<IBaseExpression<ILiteralNonVariableExtension>> copier) {
        this.clauseCopier = new ClauseCopy(copier);
    }

    @Override
    public INamedClause copy(IPELTracker tracker, INamedClause object) {
        INamedClause retval = object;
        if (!object.isFree()) {
            IClause clauseCopy
                    = this.clauseCopier.copy(tracker, object.getClause());
            IPELVariableContext pelVariableContextCopy
                    = this.pelVariableContextCopier.copy(tracker, object.getPelVariableContext());
            retval = new NamedClause(clauseCopy, pelVariableContextCopy);
        }
        return retval;
    }

    @Override
    public void collectLeafs(IPELLeafCollector leafCollector, INamedClause object) {
        this.clauseCopier.collectLeafs(leafCollector, object.getClause());
        this.pelVariableContextCopier.collectLeafs(leafCollector, object.getPelVariableContext());
    }

}
