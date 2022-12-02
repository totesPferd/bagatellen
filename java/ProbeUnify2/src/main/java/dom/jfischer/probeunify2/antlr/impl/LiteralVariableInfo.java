/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.antlr.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.ITrivialExtension;
import dom.jfischer.probeunify2.basic.IVariable;
import dom.jfischer.probeunify2.basic.IVariableContext;
import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;
import dom.jfischer.probeunify2.pel.ITermNonVariableExtension;
import java.io.Serializable;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 *
 * @author jfischer
 */
public class LiteralVariableInfo implements Serializable {

    private final LiteralVariableInfo parent;

    private final TermVariableInfo termVariableInfo;
    private final Map<String, IVariable<ILiteralNonVariableExtension>> literalBaseVars
            = new ConcurrentHashMap<>();
    private final Map<String, Map<Integer, IVariable<ILiteralNonVariableExtension>>> literalIndexedVars
            = new ConcurrentHashMap<>();
    private final Map<String, IVariableContext<ITrivialExtension, ILiteralNonVariableExtension>> literalBaseCtx
            = new ConcurrentHashMap<>();
    private final Map<String, Map<Integer, IVariableContext<ITrivialExtension, ILiteralNonVariableExtension>>> literalIndexedCtx
            = new ConcurrentHashMap<>();

    public LiteralVariableInfo() {
        this.parent = null;
        this.termVariableInfo
                = new TermVariableInfo();
    }

    public LiteralVariableInfo(LiteralVariableInfo parent) {
        this.parent = parent;
        this.termVariableInfo
                = new TermVariableInfo(parent.getTermVariableInfo());
    }

    public LiteralVariableInfo getParent() {
        return parent;
    }

    public TermVariableInfo getTermVariableInfo() {
        return this.termVariableInfo;
    }

    public Map<String, IVariable<ILiteralNonVariableExtension>> getLiteralBaseVars() {
        return literalBaseVars;
    }

    public Map<String, Map<Integer, IVariable<ILiteralNonVariableExtension>>> getLiteralIndexedVars() {
        return literalIndexedVars;
    }

    public Map<String, IVariableContext<ITrivialExtension, ILiteralNonVariableExtension>> getLiteralBaseCtx() {
        return literalBaseCtx;
    }

    public Map<String, Map<Integer, IVariableContext<ITrivialExtension, ILiteralNonVariableExtension>>> getLiteralIndexedCtx() {
        return literalIndexedCtx;
    }

    public Map<String, IVariableContext<IBaseExpression<ITrivialExtension>, ITermNonVariableExtension>> getTermBaseCtx() {
        return this.termVariableInfo.getTermBaseCtx();
    }

    public Map<String, Map<Integer, IVariableContext<IBaseExpression<ITrivialExtension>, ITermNonVariableExtension>>> getTermIndexedCtx() {
        return this.termVariableInfo.getTermIndexedCtx();
    }

    public IVariableContext<ITrivialExtension, ILiteralNonVariableExtension> lookupVariableContextForBaseLiterals(
            SymbolBean symbolBean
    ) {
        IVariableContext<ITrivialExtension, ILiteralNonVariableExtension> retval = null;
        Map<String, IVariableContext<ITrivialExtension, ILiteralNonVariableExtension>> ctxMap
                = this.getLiteralBaseCtx();
        if (ctxMap.containsKey(symbolBean.getSymbol())) {
            retval = ctxMap.get(symbolBean.getSymbol());
        }

        if (parent != null && retval == null) {
            retval = parent.lookupVariableContextForBaseLiterals(symbolBean);
        }

        return retval;
    }

    public IVariableContext<ITrivialExtension, ILiteralNonVariableExtension> lookupVariableContextForIndexedLiterals(
            IndexedSymbolBean indexedSymbolBean
    ) {
        IVariableContext<ITrivialExtension, ILiteralNonVariableExtension> retval = null;
        Map<String, Map<Integer, IVariableContext<ITrivialExtension, ILiteralNonVariableExtension>>> ctxMap
                = this.getLiteralIndexedCtx();
        if (ctxMap.containsKey(indexedSymbolBean.getSymbol())) {
            Map<Integer, IVariableContext<ITrivialExtension, ILiteralNonVariableExtension>> innerMap
                    = ctxMap.get(indexedSymbolBean.getSymbol());
            if (innerMap.containsKey(indexedSymbolBean.getIndex())) {
                retval = innerMap.get(indexedSymbolBean.getIndex());
            }
        }

        if (parent != null && retval == null) {
            retval = parent.lookupVariableContextForIndexedLiterals(indexedSymbolBean);
        }

        return retval;
    }

}
