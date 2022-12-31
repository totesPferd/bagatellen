/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunifyfrontend1.names.impl;

import dom.jfischer.probeunify3.basic.ICopy;
import dom.jfischer.probeunify3.basic.INonVariableXt;
import dom.jfischer.probeunify3.basic.ITracker;
import dom.jfischer.probeunify3.basic.IXpr;
import dom.jfischer.probeunify3.module.IObject;
import dom.jfischer.probeunifyfrontend1.names.IOperationSignature;
import dom.jfischer.probeunifyfrontend1.names.IPELXt;
import dom.jfischer.probeunifyfrontend1.names.IPredicateSignature;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 *
 * @author jfischer
 */
public class PELXtCopy implements
        ICopy<IPELXt, ITracker<IXpr<INonVariableXt>>> {

    private final ICopy<IOperationSignature, ITracker<IXpr<INonVariableXt>>> operationSignatureCopier
            =  new OperationSignatureCopy();
    private final ICopy<IPredicateSignature, ITracker<IXpr<INonVariableXt>>> predicateSignatureCopier
            =  new PredicateSignatureCopy();
    
    @Override
    public IPELXt copy(ITracker<IXpr<INonVariableXt>> tracker, IPELXt object) {
        Map<IObject, IOperationSignature> operationSignatureCopy
                =  new ConcurrentHashMap<>();
        object.getOperationSignatures().entrySet()
                .parallelStream()
                .forEach(entry -> operationSignatureCopy.put(entry.getKey(), this.operationSignatureCopier.copy(tracker, entry.getValue())));
        Map<IObject, IPredicateSignature> predicateSignatureCopy
                =  new ConcurrentHashMap<>();
        object.getPredicateSignatures().entrySet()
                .parallelStream()
                .forEach(entry -> predicateSignatureCopy.put(entry.getKey(), this.predicateSignatureCopier.copy(tracker, entry.getValue())));
        return new PELXt(
                object.getSorts(),
                object.getOperations(),
                object.getPredicates(),
                object.getAxioms(),
                object.getQuals(),
                operationSignatureCopy,
                predicateSignatureCopy
        );
    }
    
}
