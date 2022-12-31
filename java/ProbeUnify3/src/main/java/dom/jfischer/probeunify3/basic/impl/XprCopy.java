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
import dom.jfischer.probeunify3.basic.ITracker;
import dom.jfischer.probeunify3.basic.IUnification;
import dom.jfischer.probeunify3.basic.IVariable;
import dom.jfischer.probeunify3.basic.IVariableContext;
import dom.jfischer.probeunify3.basic.IXpr;
import java.util.Optional;

/**
 *
 * @author jfischer
 * @param <NonVariableXt>
 */
public class XprCopy<NonVariableXt extends INonVariableXt>
        implements ICopy<IXpr<NonVariableXt>, ITracker<IXpr<NonVariableXt>>> {

    private final ICheckVariableOccurence<NonVariableXt, NonVariableXt> baseVariableOccurenceChecker;
    private final ICopy<NonVariableXt, ITracker<IXpr<NonVariableXt>>> baseCopier;
    private final ILeafCollecting<NonVariableXt, NonVariableXt> baseLeafCollecting;
    private final IUnification<NonVariableXt> baseNonVariableXtUnification;
    private final IVariableContext<NonVariableXt> variableContext;

    private final ICheckVariableOccurence<NonVariableXt, IXpr<NonVariableXt>> variableOccurenceChecker
            = new XprCheckVariableOccurence<>();

    public XprCopy(ICheckVariableOccurence<NonVariableXt, NonVariableXt> baseVariableOccurenceChecker, ICopy<NonVariableXt, ITracker<IXpr<NonVariableXt>>> baseCopier, ILeafCollecting<NonVariableXt, NonVariableXt> baseLeafCollecting, IUnification<NonVariableXt> baseNonVariableXtUnification) {
        this.baseVariableOccurenceChecker = baseVariableOccurenceChecker;
        this.baseCopier = baseCopier;
        this.baseLeafCollecting = baseLeafCollecting;
        this.baseNonVariableXtUnification = baseNonVariableXtUnification;
        this.variableContext =  new VariableContext<>(this);
    }
    
    public XprCopy(ICheckVariableOccurence<NonVariableXt, NonVariableXt> baseVariableOccurenceChecker, ICopy<NonVariableXt, ITracker<IXpr<NonVariableXt>>> baseCopier, ILeafCollecting<NonVariableXt, NonVariableXt> baseLeafCollecting, IUnification<NonVariableXt> baseNonVariableXtUnification, IVariableContext<NonVariableXt> variableContext) {
        this.baseVariableOccurenceChecker = baseVariableOccurenceChecker;
        this.baseCopier = baseCopier;
        this.baseLeafCollecting = baseLeafCollecting;
        this.baseNonVariableXtUnification = baseNonVariableXtUnification;
        this.variableContext = variableContext;
    }

    public IVariableContext<NonVariableXt> getVariableContext() {
        return variableContext;
    }

    @Override
    public IXpr<NonVariableXt> copy(ITracker<IXpr<NonVariableXt>> tracker, IXpr<NonVariableXt> object) {
        IXpr<NonVariableXt> dereferencedObject = object.dereference();
        IXpr<NonVariableXt> retval = dereferencedObject;

        if (!this.variableOccurenceChecker.isConstant(dereferencedObject, this.variableContext)) {
            Optional<IXpr<NonVariableXt>> optObjectCopy
                    = tracker.get(dereferencedObject);

            if (optObjectCopy.isPresent()) {
                retval = optObjectCopy.get();
            } else {
                {
                    Optional<INonVariable<NonVariableXt>> optNonVariable
                            = dereferencedObject.nonVariable();
                    if (optNonVariable.isPresent()) {
                        INonVariable<NonVariableXt> nonVariable
                                = optNonVariable.get();
                        retval = new NonVariable<>(
                                this.baseVariableOccurenceChecker,
                                this.baseLeafCollecting,
                                this.baseNonVariableXtUnification,
                                this.baseCopier.copy(tracker, nonVariable.getNonVariableXt())
                        );
                    }
                }
                {
                    Optional<IVariable<NonVariableXt>> optVariable
                            = dereferencedObject.variable();
                    if (optVariable.isPresent()) {
                        retval = new Variable<>();
                    }
                }
                tracker.put(dereferencedObject, retval);
            }
        }
        
        return retval;
    }

}
