/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunifyfrontend1.names.impl;

import com.google.common.base.Optional;
import com.google.common.collect.BiMap;
import com.google.common.collect.HashBasedTable;
import com.google.common.collect.HashBiMap;
import com.google.common.collect.Table;
import dom.jfischer.probeunify3.basic.ITNonVariableXt;
import dom.jfischer.probeunify3.basic.IVariable;
import dom.jfischer.probeunify3.basic.IVariableContext;
import dom.jfischer.probeunifyfrontend1.names.IBaseSymbolBean;
import dom.jfischer.probeunifyfrontend1.names.IIndexedSymbolBean;
import dom.jfischer.probeunifyfrontend1.names.IVariableInfo;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 *
 * @author jfischer
 */
public class VariableInfo implements IVariableInfo {

    private final IVariableInfo parent;

    BiMap<String, IVariable<ITNonVariableXt>> baseVars
            = HashBiMap.create();
    Table<String, Integer, IVariable<ITNonVariableXt>> indexedVars
            = HashBasedTable.create();
    Map<String, IVariableContext<ITNonVariableXt>> baseCtx
            = new ConcurrentHashMap<>();
    Table<String, Integer, IVariableContext<ITNonVariableXt>> indexedCtx
            = HashBasedTable.create();

    public VariableInfo() {
        this.parent = null;
    }

    public VariableInfo(IVariableInfo parent) {
        this.parent = parent;
    }

    @Override
    public Optional<IVariableInfo> getParent() {
        return Optional.fromNullable(this.parent);
    }

    @Override
    public BiMap<String, IVariable<ITNonVariableXt>> getBaseVars() {
        return this.baseVars;
    }

    @Override
    public Table<String, Integer, IVariable<ITNonVariableXt>> getIndexedVars() {
        return this.indexedVars;
    }

    @Override
    public Map<String, IVariableContext<ITNonVariableXt>> getBaseCtx() {
        return this.baseCtx;
    }

    @Override
    public Table<String, Integer, IVariableContext<ITNonVariableXt>> getIndexedCtx() {
        return this.indexedCtx;
    }

    @Override
    public IVariable<ITNonVariableXt> lookupBaseVars(IBaseSymbolBean symbolBean) {
        IVariable<ITNonVariableXt> retval = null;

        String symbol = symbolBean.getSymbol();
        if (this.baseVars.containsKey(symbol)) {
            retval = this.baseVars.get(symbol);
        } else if (this.parent != null) {
            retval = this.parent.lookupBaseVars(symbolBean);
        }

        return retval;
    }

    @Override
    public IVariable<ITNonVariableXt> lookupIndexedVars(IIndexedSymbolBean symbolBean) {
        IVariable<ITNonVariableXt> retval = null;

        String symbol = symbolBean.getSymbol();
        Integer index = symbolBean.getIndex();
        if (this.indexedVars.contains(symbol, index)) {
            retval = this.indexedVars.get(symbol, index);
        } else if (this.parent != null) {
            retval = this.parent.lookupIndexedVars(symbolBean);
        }

        return retval;
    }

    @Override
    public IVariableContext<ITNonVariableXt> lookupBaseCtx(IBaseSymbolBean symbolBean) {
        IVariableContext<ITNonVariableXt> retval = null;

        String symbol = symbolBean.getSymbol();
        if (this.baseCtx.containsKey(symbol)) {
            retval = this.baseCtx.get(symbol);
        } else if (this.parent != null) {
            retval = this.parent.lookupBaseCtx(symbolBean);
        }

        return retval;
    }

    @Override
    public IVariableContext<ITNonVariableXt> lookupIndexedCtx(IIndexedSymbolBean symbolBean) {
        IVariableContext<ITNonVariableXt> retval = null;

        String symbol = symbolBean.getSymbol();
        Integer index = symbolBean.getIndex();
        if (this.indexedCtx.contains(symbol, index)) {
            retval = this.indexedCtx.get(symbol, index);
        } else if (this.parent != null) {
            retval = this.parent.lookupIndexedCtx(symbolBean);
        }

        return retval;
    }

    @Override
    public IVariable<ITNonVariableXt> createBaseVar(IBaseSymbolBean symbolBean) {
        IVariableContext<ITNonVariableXt> varCtx = this.lookupBaseCtx(symbolBean);
        String symbol = symbolBean.getSymbol();
        this.baseCtx.put(symbol, varCtx);
        IVariable<ITNonVariableXt> retval = varCtx.createVariable();
        this.baseVars.put(symbol, retval);
        return retval;
    }

    @Override
    public IVariable<ITNonVariableXt> createIndexedVar(IIndexedSymbolBean symbolBean) {
        IVariableContext<ITNonVariableXt> varCtx = this.lookupIndexedCtx(symbolBean);
        String symbol = symbolBean.getSymbol();
        Integer index = symbolBean.getIndex();
        this.indexedCtx.put(symbol, index, varCtx);
        IVariable<ITNonVariableXt> retval = varCtx.createVariable();
        this.indexedVars.put(symbol, index, retval);
        return retval;
    }

}
