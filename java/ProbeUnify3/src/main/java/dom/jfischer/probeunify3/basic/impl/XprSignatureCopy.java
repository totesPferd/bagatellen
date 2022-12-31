/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify3.basic.impl;

import dom.jfischer.probeunify3.basic.ICheckVariableOccurence;
import dom.jfischer.probeunify3.basic.ICopy;
import dom.jfischer.probeunify3.basic.ILeafCollecting;
import dom.jfischer.probeunify3.basic.INonVariable;
import dom.jfischer.probeunify3.basic.INonVariableXt;
import dom.jfischer.probeunify3.basic.ITNonVariableXt;
import dom.jfischer.probeunify3.basic.ITracker;
import dom.jfischer.probeunify3.basic.IUnification;
import dom.jfischer.probeunify3.basic.IVariable;
import dom.jfischer.probeunify3.basic.IXpr;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 *
 * @author jfischer
 */
public class XprSignatureCopy implements
        ICopy<IXpr<ITNonVariableXt>, ITracker<IXpr<INonVariableXt>>> {

    private final ICheckVariableOccurence<ITNonVariableXt, ITNonVariableXt> variableOccurenceChecker
            =  new TNonVariableXtCheckVariableOccurence();
    private final ILeafCollecting<ITNonVariableXt, ITNonVariableXt> leafCollector
            =  new TNonVariableXtLeafCollecting();
    private final IUnification<ITNonVariableXt> nonVariableXtUnification
            =  new TNonVariableXtUnification();
    private final ICopy<IXpr<INonVariableXt>, ITracker<IXpr<INonVariableXt>>> cXprCopier
            = new CXprCopy();

    @Override
    public IXpr<ITNonVariableXt> copy(ITracker<IXpr<INonVariableXt>> tracker, IXpr<ITNonVariableXt> object) {
        IXpr<ITNonVariableXt> dereferencedObject = object.dereference();
        IXpr<ITNonVariableXt> retval =  null;
        
        {
            Optional<INonVariable<ITNonVariableXt>> optNonVariable
                    = dereferencedObject.nonVariable();
            if (optNonVariable.isPresent()) {
                INonVariable<ITNonVariableXt> nonVariable = optNonVariable.get();
                ITNonVariableXt tNonVariableXtSignatureCopy
                        = this.xtCopy(tracker, nonVariable.getNonVariableXt());
                retval =  new NonVariable<>(
                        this.variableOccurenceChecker,
                        this.leafCollector,
                        this.nonVariableXtUnification,
                        tNonVariableXtSignatureCopy
                );
            }
        }
        {
            Optional<IVariable<ITNonVariableXt>> optVariable
                    = dereferencedObject.variable();
            if (optVariable.isPresent()) {
                retval =  optVariable.get();
            }
        }
        
        return retval;
    }
    
    private ITNonVariableXt xtCopy(ITracker<IXpr<INonVariableXt>> tracker, ITNonVariableXt object) {
        List<IXpr<ITNonVariableXt>> argumentsCopy
                = object.getArguments()
                        .parallelStream()
                        .map(arg -> this.copy(tracker, arg))
                        .collect(Collectors.toList());
        IXpr<INonVariableXt> opCopy
                = this.cXprCopier.copy(tracker, object.getSymbol());
        return new TNonVariableXt(
                opCopy,
                argumentsCopy);
    }

}
