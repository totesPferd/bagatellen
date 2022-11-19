/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pel.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.ICopy;
import dom.jfischer.probeunify2.basic.ILeafCollector;
import dom.jfischer.probeunify2.basic.ITracker;
import dom.jfischer.probeunify2.pel.IPELLeafCollector;
import dom.jfischer.probeunify2.pel.IPELTracker;
import dom.jfischer.probeunify2.pel.ITermNonVariableExtension;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

/**
 *
 * @author jfischer
 */
public class TermNonVariableExtensionCopy implements ICopy<ITermNonVariableExtension> {

    @Override
    public ITermNonVariableExtension copy(IPELTracker tracker, ITermNonVariableExtension object) {
        ITracker<ITermNonVariableExtension> termTracker
                = tracker.getTermTracker();
        List<IBaseExpression<ITermNonVariableExtension>> argumentCopy
                = Collections.synchronizedList(object.getArguments()
                        .stream()
                        .map(term -> term.copy(termTracker))
                        .collect(Collectors.toList()));
        return new TermNonVariableExtension(object.getOperation(), argumentCopy);
    }

    @Override
    public void collectLeafs(IPELLeafCollector leafCollector, ITermNonVariableExtension object) {
        ILeafCollector<ITermNonVariableExtension> termLeafCollector = leafCollector.getTermLeafCollector();
        object.getArguments()
                .parallelStream()
                .forEach(term -> term.dereference().collectLeafs(termLeafCollector));
    }
}
