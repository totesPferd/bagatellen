/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.proof.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.ICopy;
import dom.jfischer.probeunify2.basic.ILeafCollector;
import dom.jfischer.probeunify2.basic.ITracker;
import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;
import dom.jfischer.probeunify2.pel.IPELLeafCollector;
import dom.jfischer.probeunify2.pel.IPELTracker;
import dom.jfischer.probeunify2.proof.IClause;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

/**
 *
 * @author jfischer
 */
public class ClauseCopy implements ICopy<IClause> {

    @Override
    public IClause copy(IPELTracker tracker, IClause object) {
        ITracker<ILiteralNonVariableExtension> literalTracker
                = tracker.getLiteralTracker();
        IBaseExpression<ILiteralNonVariableExtension> conclusionCopy
                = object.getConclusion().copy(literalTracker);
        List<IBaseExpression<ILiteralNonVariableExtension>> premisesCopy
                = Collections.synchronizedList(object.getPremises()
                        .stream()
                        .map(literal -> literal.copy(literalTracker))
                        .collect(Collectors.toList()));
        return new Clause(conclusionCopy, premisesCopy);
    }

    @Override
    public void collectLeafs(IPELLeafCollector leafCollector, IClause object) {
        ILeafCollector<ILiteralNonVariableExtension> literalLeafCollector
                = leafCollector.getLiteralLeafCollector();
        object.getConclusion().collectLeafs(literalLeafCollector);
        object.getPremises()
                .parallelStream()
                .forEach(literal -> literal.collectLeafs(literalLeafCollector));
    }

}
