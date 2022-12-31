/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunifyfrontend1.names.impl;

import dom.jfischer.probeunify3.basic.INonVariableXt;
import dom.jfischer.probeunify3.basic.ITNonVariableXt;
import dom.jfischer.probeunify3.basic.IVariable;
import dom.jfischer.probeunify3.basic.IXpr;
import dom.jfischer.probeunifyfrontend1.names.ITermVariableInfo;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

/**
 *
 * @author jfischer
 */
public class TermVariableInfo implements ITermVariableInfo {

    Map<IVariable<ITNonVariableXt>, IXpr<INonVariableXt>> sorts
            = new ConcurrentHashMap<>();

    @Override
    public Map<IVariable<ITNonVariableXt>, IXpr<INonVariableXt>> getSorts() {
        return this.sorts;
    }

    @Override
    public void retainAll(Set<IVariable<ITNonVariableXt>> variables) {
        this.sorts.keySet().retainAll(variables);
    }

}
