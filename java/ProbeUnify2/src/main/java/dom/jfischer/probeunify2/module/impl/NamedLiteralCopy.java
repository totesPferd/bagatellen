/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.module.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.ICopy;
import dom.jfischer.probeunify2.basic.ILeafCollector;
import dom.jfischer.probeunify2.basic.ITracker;
import dom.jfischer.probeunify2.module.INamedLiteral;
import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;
import dom.jfischer.probeunify2.pel.IPELLeafCollector;
import dom.jfischer.probeunify2.pel.IPELTracker;
import dom.jfischer.probeunify2.pprint.ITermVariableContext;
import dom.jfischer.probeunify2.pprint.impl.TermVariableContextCopy;

/**
 *
 * @author jfischer
 */
public class NamedLiteralCopy implements ICopy<INamedLiteral> {

    private final ICopy<ITermVariableContext> termVariableContextCopier
            = new TermVariableContextCopy();

    @Override
    public INamedLiteral copy(IPELTracker tracker, INamedLiteral object) {
        ITracker<ILiteralNonVariableExtension> literalTracker
                = tracker.getLiteralTracker();
        IBaseExpression<ILiteralNonVariableExtension> literalCopy = object.getLiteral().copy(literalTracker);
        ITermVariableContext termVariableContextCopy
                = this.termVariableContextCopier.copy(tracker, object.getTermVariableContext());
        return new NamedLiteral(literalCopy, termVariableContextCopy);
    }

    @Override
    public void collectLeafs(IPELLeafCollector leafCollector, INamedLiteral object) {
        ILeafCollector<ILiteralNonVariableExtension> literalLeafCollector
                = leafCollector.getLiteralLeafCollector();
        object.getLiteral().collectLeafs(literalLeafCollector);
        this.termVariableContextCopier.collectLeafs(leafCollector, object.getTermVariableContext());
    }

}
