/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunifyfrontend1.names;

import com.google.common.base.Optional;
import com.google.common.collect.BiMap;
import com.google.common.collect.Table;
import dom.jfischer.probeunify3.basic.ITNonVariableXt;
import dom.jfischer.probeunify3.basic.IVariable;
import dom.jfischer.probeunify3.basic.IVariableContext;
import java.io.Serializable;
import java.util.Map;

/**
 *
 * @author jfischer
 */
public interface IVariableInfo extends Serializable {

    Optional<IVariableInfo> getParent();

    IVariable<ITNonVariableXt> createBaseVar(IBaseSymbolBean symbolBean);
    
    IVariable<ITNonVariableXt> createIndexedVar(IIndexedSymbolBean symbolBean);
    
    BiMap<String, IVariable<ITNonVariableXt>> getBaseVars();

    Table<String, Integer, IVariable<ITNonVariableXt>> getIndexedVars();

    Map<String, IVariableContext<ITNonVariableXt>> getBaseCtx();

    Table<String, Integer, IVariableContext<ITNonVariableXt>> getIndexedCtx();

    IVariable<ITNonVariableXt> lookupBaseVars(IBaseSymbolBean symbolBean);

    IVariable<ITNonVariableXt> lookupIndexedVars(IIndexedSymbolBean symbolBean);

    IVariableContext<ITNonVariableXt> lookupBaseCtx(IBaseSymbolBean symbolBean);

    IVariableContext<ITNonVariableXt> lookupIndexedCtx(IIndexedSymbolBean symbolBean);

}
