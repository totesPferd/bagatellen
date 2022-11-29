/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.basic.impl;

import dom.jfischer.probeunify2.basic.IExtension;
import dom.jfischer.probeunify2.basic.ISimpleLeafCollector;
import dom.jfischer.probeunify2.basic.IVariable;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

/**
 *
 * @author jfischer
 * @param <NonVariableExtension>
 */
public class SimpleLeafCollector<NonVariableExtension extends IExtension> implements
        ISimpleLeafCollector<NonVariableExtension> {

    private final Set<IVariable<NonVariableExtension>> leafs
            = Collections.synchronizedSet(new HashSet<>());

    @Override
    public Set<IVariable<NonVariableExtension>> getLeafs() {
        return this.leafs;
    }

    @Override
    public void undo() {
        this.leafs
                .parallelStream()
                .forEach(v -> v.clear());
    }

}
