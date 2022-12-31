/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify3.basic.impl;

import dom.jfischer.probeunify3.basic.ICopy;
import dom.jfischer.probeunify3.basic.INonVariableXt;
import dom.jfischer.probeunify3.basic.ITracker;
import dom.jfischer.probeunify3.basic.IVariable;
import dom.jfischer.probeunify3.basic.IXpr;
import java.util.Optional;

/**
 *
 * @author jfischer
 * @param <NonVariableXt>
 */
public class VariableCopy<NonVariableXt extends INonVariableXt> implements
        ICopy<IVariable<NonVariableXt>, ITracker<IXpr<NonVariableXt>>> {

    private final ICopy<IXpr<NonVariableXt>, ITracker<IXpr<NonVariableXt>>> baseCopier;

    public VariableCopy(ICopy<IXpr<NonVariableXt>, ITracker<IXpr<NonVariableXt>>> baseCopier) {
        this.baseCopier = baseCopier;
    }
    
    @Override
    public IVariable<NonVariableXt> copy(ITracker<IXpr<NonVariableXt>> tracker, IVariable<NonVariableXt> object) {
        IXpr<NonVariableXt> objectCopy
                = this.baseCopier.copy(tracker, object);
        Optional<IVariable<NonVariableXt>> optVariableCopy
                = objectCopy.variable();

        IVariable<NonVariableXt> retval = null;

        if (optVariableCopy.isPresent()) {
            retval = optVariableCopy.get();
        } else {
            retval = new Variable<>();
            retval.setValue(objectCopy.dereference());
        }

        return retval;
    }

}
