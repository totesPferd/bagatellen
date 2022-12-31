/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify3.basic.impl;

import dom.jfischer.probeunify3.basic.ICopy;
import dom.jfischer.probeunify3.basic.INonVariableXt;
import dom.jfischer.probeunify3.basic.ITracker;
import dom.jfischer.probeunify3.basic.IXpr;
import java.util.Optional;

/**
 *
 * @author jfischer
 */
public class CXprCopy implements
        ICopy<IXpr<INonVariableXt>, ITracker<IXpr<INonVariableXt>>> {

    @Override
    public IXpr<INonVariableXt> copy(ITracker<IXpr<INonVariableXt>> tracker, IXpr<INonVariableXt> object) {
        IXpr<INonVariableXt> dereferencedObject
                = object.dereference();
        Optional<IXpr<INonVariableXt>> optObjectCopy
                = tracker.get(dereferencedObject);
        IXpr<INonVariableXt> retval =  null;
        
        if (optObjectCopy.isPresent()) {
            retval =  optObjectCopy.get();
        } else {
            retval =  new Variable<>();
            tracker.put(dereferencedObject, retval);
        }
        
        return retval;
    }
    
}
