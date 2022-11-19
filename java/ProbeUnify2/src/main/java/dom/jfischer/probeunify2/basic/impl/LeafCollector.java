/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.basic.impl;

import dom.jfischer.probeunify2.basic.IExtension;
import dom.jfischer.probeunify2.basic.ILeafCollector;
import dom.jfischer.probeunify2.basic.IVariable;
import dom.jfischer.probeunify2.pel.IPELLeafCollector;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;

/**
 *
 * @author jfischer
 * @param <NonVariableExtension>
 */
public class LeafCollector<
                NonVariableExtension extends IExtension> implements
        ILeafCollector<NonVariableExtension> {

    private final IPELLeafCollector allLeafCollectors;
    private final Set<IVariable<NonVariableExtension>> leafs
            = Collections.synchronizedSet(new HashSet<>());

    public LeafCollector(IPELLeafCollector allLeafCollects) {
        this.allLeafCollectors = allLeafCollects;
    }

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

    @Override
    public IPELLeafCollector getAllLeafCollectors() {
        return this.allLeafCollectors;
    }

    @Override
    public String toString() {
        return "LeafCollector{" + "leafs="
                + this.leafs
                        .parallelStream()
                        .map(v -> v.dereference())
                        .collect(Collectors.toSet())
                + '}';
    }

}
