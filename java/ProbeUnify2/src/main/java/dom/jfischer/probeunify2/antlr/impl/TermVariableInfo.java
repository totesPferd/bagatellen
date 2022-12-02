/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.antlr.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.ITrivialExtension;
import dom.jfischer.probeunify2.basic.IVariable;
import dom.jfischer.probeunify2.basic.IVariableContext;
import dom.jfischer.probeunify2.pel.ITermNonVariableExtension;
import java.io.Serializable;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 *
 * @author jfischer
 */
public class TermVariableInfo implements Serializable {

    private final TermVariableInfo parent;

    private final Map<String, IVariable<ITermNonVariableExtension>> termBaseVars
            = new ConcurrentHashMap<>();
    private final Map<String, Map<Integer, IVariable<ITermNonVariableExtension>>> termIndexedVars
            = new ConcurrentHashMap<>();
    private final Map<String, IVariableContext<IBaseExpression<ITrivialExtension>, ITermNonVariableExtension>> termBaseCtx
            = new ConcurrentHashMap<>();
    private final Map<String, Map<Integer, IVariableContext<IBaseExpression<ITrivialExtension>, ITermNonVariableExtension>>> termIndexedCtx
            = new ConcurrentHashMap<>();

    public TermVariableInfo() {
        this.parent = null;
    }

    public TermVariableInfo(TermVariableInfo parent) {
        this.parent = parent;
    }

    public TermVariableInfo getParent() {
        return parent;
    }

    public Map<String, IVariable<ITermNonVariableExtension>> getTermBaseVars() {
        return termBaseVars;
    }

    public Map<String, Map<Integer, IVariable<ITermNonVariableExtension>>> getTermIndexedVars() {
        return termIndexedVars;
    }

    public Map<String, IVariableContext<IBaseExpression<ITrivialExtension>, ITermNonVariableExtension>> getTermBaseCtx() {
        return termBaseCtx;
    }

    public Map<String, Map<Integer, IVariableContext<IBaseExpression<ITrivialExtension>, ITermNonVariableExtension>>> getTermIndexedCtx() {
        return termIndexedCtx;
    }

    public IVariableContext<IBaseExpression<ITrivialExtension>, ITermNonVariableExtension> lookupVariableContextForBaseTerms(
            SymbolBean symbolBean
    ) {
        IVariableContext<IBaseExpression<ITrivialExtension>, ITermNonVariableExtension> retval = null;
        Map<String, IVariableContext<IBaseExpression<ITrivialExtension>, ITermNonVariableExtension>> ctxMap
                = this.getTermBaseCtx();
        if (ctxMap.containsKey(symbolBean.getSymbol())) {
            retval = ctxMap.get(symbolBean.getSymbol());
        }

        if (parent != null && retval == null) {
            retval = parent.lookupVariableContextForBaseTerms(symbolBean);
        }

        return retval;
    }

    public IVariableContext<IBaseExpression<ITrivialExtension>, ITermNonVariableExtension> lookupVariableContextForIndexedTerms(
            IndexedSymbolBean indexedSymbolBean
    ) {
        IVariableContext<IBaseExpression<ITrivialExtension>, ITermNonVariableExtension> retval = null;
        Map<String, Map<Integer, IVariableContext<IBaseExpression<ITrivialExtension>, ITermNonVariableExtension>>> ctxMap
                = this.getTermIndexedCtx();
        if (ctxMap.containsKey(indexedSymbolBean.getSymbol())) {
            Map<Integer, IVariableContext<IBaseExpression<ITrivialExtension>, ITermNonVariableExtension>> innerMap
                    = ctxMap.get(indexedSymbolBean.getSymbol());
            if (innerMap.containsKey(indexedSymbolBean.getIndex())) {
                retval = innerMap.get(indexedSymbolBean.getIndex());
            }
        }

        if (parent != null && retval == null) {
            retval = parent.lookupVariableContextForIndexedTerms(indexedSymbolBean);
        }

        return retval;
    }

}
