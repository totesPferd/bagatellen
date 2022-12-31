/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify3.module;

import dom.jfischer.probeunify3.basic.IClause;
import dom.jfischer.probeunify3.basic.INonVariableXt;
import dom.jfischer.probeunify3.basic.IResettable;
import dom.jfischer.probeunify3.basic.IXpr;
import java.util.Map;

/**
 *
 * @author jfischer
 * @param <Xt>
 */
public interface IModule<Xt extends IModuleXt> extends IResettable {
    
    Xt getXt();
    
    Map<IObject, IClause> getAxioms();
    
    Map<IObject, IModule<Xt>> getImports();
    
    Map<IObject, IXpr<INonVariableXt>> getCs();
    
}
