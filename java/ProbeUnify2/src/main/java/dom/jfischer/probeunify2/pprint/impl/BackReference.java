/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pprint.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.ITrivialExtension;
import dom.jfischer.probeunify2.pprint.IBackReference;
import java.util.Map;
import dom.jfischer.probeunify2.module.IModule;
import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;
import dom.jfischer.probeunify2.pel.IOperationExpression;
import dom.jfischer.probeunify2.pel.IPredicateExpression;
import dom.jfischer.probeunify2.pel.ITermNonVariableExtension;
import dom.jfischer.probeunify2.proof.IClause;
import java.util.concurrent.ConcurrentHashMap;

/**
 *
 * @author jfischer
 */
public class BackReference implements IBackReference {

    private final Map<IModule, String> moduleRef = new ConcurrentHashMap<>();
    private final Map<IClause, String> clauseRef = new ConcurrentHashMap<>();
    private final Map<IOperationExpression, String> operationRef = new ConcurrentHashMap<>();
    private final Map<IPredicateExpression, String> predicateRef = new ConcurrentHashMap<>();
    private final Map<IBaseExpression<ITrivialExtension>, String> sortRef = new ConcurrentHashMap<>();

    @Override
    public Map<IModule, String> getModuleRef() {
        return this.moduleRef;
    }

    @Override
    public Map<IClause, String> getAxiomRef() {
        return this.clauseRef;
    }

    @Override
    public Map<IOperationExpression, String> getOperationRef() {
        return this.operationRef;
    }

    @Override
    public Map<IPredicateExpression, String> getPredicateRef() {
        return this.predicateRef;
    }

    @Override
    public Map<IBaseExpression<ITrivialExtension>, String> getSortRef() {
        return this.sortRef;
    }

}
