/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.module.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.ICopy;
import dom.jfischer.probeunify2.basic.ILeafCollector;
import dom.jfischer.probeunify2.basic.ITracker;
import dom.jfischer.probeunify2.module.INamedTerm;
import dom.jfischer.probeunify2.pel.IPELLeafCollector;
import dom.jfischer.probeunify2.pel.IPELTracker;
import dom.jfischer.probeunify2.pel.ITermNonVariableExtension;
import dom.jfischer.probeunify2.pprint.ITermVariableContext;
import dom.jfischer.probeunify2.pprint.impl.TermVariableContextCopy;

/**
 *
 * @author jfischer
 */
public class NamedTermCopy implements ICopy<INamedTerm> {

    private final ICopy<ITermVariableContext> termVariableContextCopier
            = new TermVariableContextCopy();

    @Override
    public INamedTerm copy(IPELTracker tracker, INamedTerm object) {
        ITracker<ITermNonVariableExtension> termTracker
                = tracker.getTermTracker();
        IBaseExpression<ITermNonVariableExtension> termCopy
                = object.getTerm().copy(termTracker);
        ITermVariableContext termVariableContextCopy
                = this.termVariableContextCopier.copy(tracker, object.getTermVariableContext());
        return new NamedTerm(termCopy, termVariableContextCopy);
    }

    @Override
    public void collectLeafs(IPELLeafCollector leafCollector, INamedTerm object) {
        ILeafCollector<ITermNonVariableExtension> termLeafCollector
                = leafCollector.getTermLeafCollector();
        object.getTerm().collectLeafs(termLeafCollector);
        this.termVariableContextCopier.collectLeafs(leafCollector, object.getTermVariableContext());
    }

}
