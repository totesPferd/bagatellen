/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.proof.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.ICopy;
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

    private final ICopy<IBaseExpression<ILiteralNonVariableExtension>> copier;

    public ClauseCopy(ICopy<IBaseExpression<ILiteralNonVariableExtension>> copier) {
        this.copier = copier;
    }

    @Override
    public IClause copy(IPELTracker tracker, IClause object) {
        IBaseExpression<ILiteralNonVariableExtension> conclusionCopy
                = this.copier.copy(tracker, object.getConclusion());
        List<IBaseExpression<ILiteralNonVariableExtension>> premisesCopy
                = Collections.synchronizedList(object.getPremises()
                        .stream()
                        .map(back -> this.copier.copy(tracker, back))
                        .collect(Collectors.toList()));
        return new Clause(conclusionCopy, premisesCopy);
    }

    @Override
    public void collectLeafs(IPELLeafCollector leafCollector, IClause object) {
        this.copier.collectLeafs(leafCollector, object.getConclusion());
        object.getPremises()
                .parallelStream()
                .forEach(back -> this.copier.collectLeafs(leafCollector, back));
    }

}
