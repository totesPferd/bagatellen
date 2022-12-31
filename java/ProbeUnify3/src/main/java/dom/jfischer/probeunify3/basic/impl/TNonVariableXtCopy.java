/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify3.basic.impl;

import dom.jfischer.probeunify3.basic.ICheckVariableOccurence;
import dom.jfischer.probeunify3.basic.ICopy;
import dom.jfischer.probeunify3.basic.ILeafCollecting;
import dom.jfischer.probeunify3.basic.ITNonVariableXt;
import dom.jfischer.probeunify3.basic.ITracker;
import dom.jfischer.probeunify3.basic.IUnification;
import dom.jfischer.probeunify3.basic.IVariableContext;
import dom.jfischer.probeunify3.basic.IXpr;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

/**
 *
 * @author jfischer
 */
public class TNonVariableXtCopy implements
        ICopy<ITNonVariableXt, ITracker<IXpr<ITNonVariableXt>>> {

    private final ICheckVariableOccurence<ITNonVariableXt, ITNonVariableXt> baseVariableOccurenceChecker;
    private final ILeafCollecting<ITNonVariableXt, ITNonVariableXt> baseLeafCollecting;
    private final IUnification<ITNonVariableXt> baseUnification;
    private final ICopy<IXpr<ITNonVariableXt>, ITracker<IXpr<ITNonVariableXt>>> baseCopier;
    private final IVariableContext<ITNonVariableXt> variableContext;

    public TNonVariableXtCopy() {
        this.baseVariableOccurenceChecker
                = new TNonVariableXtCheckVariableOccurence();
        this.baseLeafCollecting
                = new TNonVariableXtLeafCollecting();
        this.baseUnification
                = new TNonVariableXtUnification();
        XprCopy<ITNonVariableXt> copier
                = new XprCopy<>(
                        baseVariableOccurenceChecker,
                        this,
                        baseLeafCollecting,
                        baseUnification
                );
        this.baseCopier =  copier;
        this.variableContext =  copier.getVariableContext();
    }

    public TNonVariableXtCopy(IVariableContext<ITNonVariableXt> variableContext) {
        this.baseVariableOccurenceChecker
                = new TNonVariableXtCheckVariableOccurence();
        this.baseLeafCollecting
                = new TNonVariableXtLeafCollecting();
        this.baseUnification
                = new TNonVariableXtUnification();
        XprCopy<ITNonVariableXt> copier
                = new XprCopy<>(
                        baseVariableOccurenceChecker,
                        this,
                        baseLeafCollecting,
                        baseUnification,
                        variableContext
                );
        this.baseCopier =  copier;
        this.variableContext =  variableContext;
    }

    public ICheckVariableOccurence<ITNonVariableXt, ITNonVariableXt> getBaseVariableOccurenceChecker() {
        return baseVariableOccurenceChecker;
    }

    public ILeafCollecting<ITNonVariableXt, ITNonVariableXt> getBaseLeafCollecting() {
        return baseLeafCollecting;
    }

    public IUnification<ITNonVariableXt> getBaseUnification() {
        return baseUnification;
    }

    public ICopy<IXpr<ITNonVariableXt>, ITracker<IXpr<ITNonVariableXt>>> getBaseCopier() {
        return this.baseCopier;
    }

    public IVariableContext<ITNonVariableXt> getVariableContext() {
        return this.variableContext;
    }

    @Override
    public ITNonVariableXt copy(ITracker<IXpr<ITNonVariableXt>> tracker, ITNonVariableXt object) {
        List<IXpr<ITNonVariableXt>> argumentsCopy
                = Collections.synchronizedList(object.getArguments()
                        .parallelStream()
                        .map(arg -> this.baseCopier.copy(tracker, arg))
                        .collect(Collectors.toList()));
        return new TNonVariableXt(
                object.getSymbol(),
                argumentsCopy
        );
    }

}
