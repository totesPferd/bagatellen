/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify3.basic.impl;

import dom.jfischer.probeunify3.basic.ILeafCollector;
import dom.jfischer.probeunify3.basic.INonVariableXt;
import dom.jfischer.probeunify3.basic.IVariable;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

/**
 *
 * @author jfischer
 * @param <NonVariableXt>
 */
public class LeafCollector<NonVariableXt extends INonVariableXt> implements
        ILeafCollector<NonVariableXt> {
    
    private final Set<IVariable<NonVariableXt>> leafs
            = Collections.synchronizedSet(new HashSet<>());

    @Override
    public Set<IVariable<NonVariableXt>> getLeafs() {
        return this.leafs;
    }

    @Override
    public void undo() {
        this.leafs
                .parallelStream()
                .forEach(v -> v.clear());
    }

}
