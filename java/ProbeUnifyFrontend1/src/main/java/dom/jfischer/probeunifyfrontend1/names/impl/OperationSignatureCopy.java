/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunifyfrontend1.names.impl;

import dom.jfischer.probeunify3.basic.ICopy;
import dom.jfischer.probeunify3.basic.INonVariableXt;
import dom.jfischer.probeunify3.basic.ITracker;
import dom.jfischer.probeunify3.basic.IXpr;
import dom.jfischer.probeunify3.basic.impl.CXprCopy;
import dom.jfischer.probeunifyfrontend1.names.IOperationSignature;
import java.util.List;
import java.util.stream.Collectors;

/**
 *
 * @author jfischer
 */
public class OperationSignatureCopy implements
        ICopy<IOperationSignature, ITracker<IXpr<INonVariableXt>>> {

    private final ICopy<IXpr<INonVariableXt>, ITracker<IXpr<INonVariableXt>>> cXprCopy
            =  new CXprCopy();
    
    @Override
    public IOperationSignature copy(ITracker<IXpr<INonVariableXt>> tracker, IOperationSignature object) {
        List<IXpr<INonVariableXt>> domainCopy = object.getDomain()
                .parallelStream()
                .map(sort -> this.cXprCopy.copy(tracker, sort))
                .collect(Collectors.toList());
        IXpr<INonVariableXt> rangeCopy
                = this.cXprCopy.copy(tracker, object.getRange());
        return new OperationSignature(
                domainCopy,
                rangeCopy
        );
    }
    
}
