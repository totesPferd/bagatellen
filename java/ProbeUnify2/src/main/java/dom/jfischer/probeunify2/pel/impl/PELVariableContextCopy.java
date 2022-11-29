/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pel.impl;

import dom.jfischer.probeunify2.basic.ICopy;
import dom.jfischer.probeunify2.basic.ILeafCollector;
import dom.jfischer.probeunify2.basic.ITracker;
import dom.jfischer.probeunify2.basic.ITrivialExtension;
import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;
import dom.jfischer.probeunify2.pel.IPELLeafCollector;
import dom.jfischer.probeunify2.pel.IPELTracker;
import dom.jfischer.probeunify2.pel.IPELVariableContext;
import dom.jfischer.probeunify2.pel.ITermExtension;
import dom.jfischer.probeunify2.pel.ITermNonVariableExtension;
import dom.jfischer.probeunify2.basic.IVariableContext;

/**
 *
 * @author jfischer
 */
public class PELVariableContextCopy implements ICopy<IPELVariableContext> {

    @Override
    public IPELVariableContext copy(IPELTracker tracker, IPELVariableContext object) {
        ITracker<ILiteralNonVariableExtension> literalTracker = tracker.getLiteralTracker();
        IVariableContext<ITrivialExtension, ILiteralNonVariableExtension> literalVariableContextCopy
                = object.getLiteralVariableContext().copy(literalTracker);
        ITracker<ITermNonVariableExtension> termTracker
                = tracker.getTermTracker();
        IVariableContext<ITermExtension, ITermNonVariableExtension> termVariableContextCopy
                = object.getTermVariableContext().copy(termTracker);

        return new PELVariableContext(literalVariableContextCopy, termVariableContextCopy);
    }

    @Override
    public void collectLeafs(IPELLeafCollector leafCollector, IPELVariableContext object) {
        ILeafCollector<ILiteralNonVariableExtension> literalLeafCollector
                = leafCollector.getLiteralLeafCollector();
        object.getLiteralVariableContext().collectLeafs(literalLeafCollector);

        ILeafCollector<ITermNonVariableExtension> termLeafCollector
                = leafCollector.getTermLeafCollector();
        object.getTermVariableContext().collectLeafs(termLeafCollector);
    }

}
