/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify3.basic.impl;

import dom.jfischer.probeunify3.basic.IClause;
import dom.jfischer.probeunify3.basic.ICopy;
import dom.jfischer.probeunify3.basic.INonVariableXt;
import dom.jfischer.probeunify3.basic.ITNonVariableXt;
import dom.jfischer.probeunify3.basic.ITracker;
import dom.jfischer.probeunify3.basic.IXpr;
import java.util.List;
import java.util.stream.Collectors;

/**
 *
 * @author jfischer
 */
public class ClauseSignatureCopy implements
        ICopy<IClause, ITracker<IXpr<INonVariableXt>>> {

    private final ICopy<IXpr<ITNonVariableXt>, ITracker<IXpr<INonVariableXt>>> xprSignatureCopier
            = new XprSignatureCopy();

    @Override
    public IClause copy(ITracker<IXpr<INonVariableXt>> tracker, IClause object) {
        List<IClause> premisesCopy
                = object.getPremises()
                        .parallelStream()
                        .map(premis -> this.copy(tracker, premis))
                        .collect(Collectors.toList());
        IXpr<ITNonVariableXt> conclusionCopy
                = this.xprSignatureCopier.copy(tracker, object.getConclusion());
        return new Clause(
                object.getVariableContext(),
                premisesCopy,
                conclusionCopy
        );
    }

}
