/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunifyfrontend1.names.impl;

import com.google.common.collect.BiMap;
import com.google.common.collect.HashBiMap;
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
public class PELXt implements IPELXt {

    private final BiMap<String, IObject> sorts;
    private final BiMap<String, IObject> operations;
    private final BiMap<String, IObject> predicates;
    private final BiMap<String, IObject> axioms;
    private final BiMap<String, IObject> quals;
    private final Map<IObject, IOperationSignature> operationSignatures;
    private final Map<IObject, IPredicateSignature> predicateSignatures;

    public PELXt() {
        this.sorts =  HashBiMap.create();
        this.operations =  HashBiMap.create();
        this.predicates =  HashBiMap.create();
        this.axioms =  HashBiMap.create();
        this.quals =  HashBiMap.create();
        this.operationSignatures =  new ConcurrentHashMap<>();
        this.predicateSignatures =  new ConcurrentHashMap<>();
    }

    public PELXt(BiMap<String, IObject> sorts, BiMap<String, IObject> operations, BiMap<String, IObject> predicates, BiMap<String, IObject> axioms, BiMap<String, IObject> quals, Map<IObject, IOperationSignature> operationSignatures, Map<IObject, IPredicateSignature> predicateSignatures) {
        this.sorts = sorts;
        this.operations = operations;
        this.predicates = predicates;
        this.axioms = axioms;
        this.quals = quals;
        this.operationSignatures = operationSignatures;
        this.predicateSignatures = predicateSignatures;
    }
    
    @Override
    public BiMap<String, IObject> getSorts() {
        return this.sorts;
    }

    @Override
    public BiMap<String, IObject> getOperations() {
        return this.operations;
    }

    @Override
    public BiMap<String, IObject> getPredicates() {
        return this.predicates;
    }

    @Override
    public BiMap<String, IObject> getAxioms() {
        return this.axioms;
    }

    @Override
    public BiMap<String, IObject> getQuals() {
        return this.quals;
    }

    @Override
    public Map<IObject, IOperationSignature> getOperationSignatures() {
        return this.operationSignatures;
    }

    @Override
    public Map<IObject, IPredicateSignature> getPredicateSignatures() {
        return this.predicateSignatures;
    }

    @Override
    public void commit() {
    }

    @Override
    public void reset() {
    }

}
