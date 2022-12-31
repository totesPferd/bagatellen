/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunifyfrontend1.pph;

import dom.jfischer.probeunify3.basic.IClause;
import dom.jfischer.probeunify3.basic.INonVariableXt;
import dom.jfischer.probeunify3.basic.IXpr;
import dom.jfischer.probeunify3.module.IModule;
import dom.jfischer.probeunifyfrontend1.names.IPELXt;
import java.io.Serializable;
import java.util.Map;

/**
 *
 * @author jfischer
 */
public interface IBackReference extends Serializable {

    Map<IModule<IPELXt>, String> getModuleRef();

    Map<IClause, String> getAxiomRef();

    Map<IXpr<INonVariableXt>, String> getSymbolRef();

    Map<IXpr<INonVariableXt>, String> getSortRef();

    void put(IModule<IPELXt> module);

}
