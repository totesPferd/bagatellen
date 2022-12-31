/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify3.basic.impl;

import dom.jfischer.probeunify3.basic.IClause;
import dom.jfischer.probeunify3.basic.ICopy;
import dom.jfischer.probeunify3.basic.ITNonVariableXt;
import dom.jfischer.probeunify3.basic.ITracker;
import dom.jfischer.probeunify3.basic.IVariableContext;
import dom.jfischer.probeunify3.basic.IXpr;
import java.util.List;
import java.util.stream.Collectors;

/**
 *
 * @author jfischer
 */
public class ClauseCopy implements
        ICopy<IClause, ITracker<IXpr<ITNonVariableXt>>> {

    @Override
    public IClause copy(ITracker<IXpr<ITNonVariableXt>> tracker, IClause object) {
        IVariableContext<ITNonVariableXt> baseVarCtx
                = object.getVariableContext();
        IVariableContext<ITNonVariableXt> varCtxCopy
                = baseVarCtx.copy(tracker);
        return this.copy(tracker, object, baseVarCtx, varCtxCopy);
    }
    
    private IClause copy(ITracker<IXpr<ITNonVariableXt>> tracker, IClause object, IVariableContext<ITNonVariableXt> baseVarCtx, IVariableContext<ITNonVariableXt> varCtxCopy) {
        TNonVariableXtCopy nonVariableXtCopy
                = new TNonVariableXtCopy(baseVarCtx);
        ICopy<IXpr<ITNonVariableXt>, ITracker<IXpr<ITNonVariableXt>>> literalCopier
                = nonVariableXtCopy.getBaseCopier();
        List<IClause> premisesCopy
                = object.getPremises()
                        .parallelStream()
                        .map(clause -> this.copy(tracker, clause, baseVarCtx, clause.getVariableContext()))
                        .collect(Collectors.toList());
        IXpr<ITNonVariableXt> conclusionCopy
                = literalCopier.copy(tracker, object.getConclusion());
        return new Clause(
                varCtxCopy,
                premisesCopy,
                conclusionCopy
        );
    }

}
