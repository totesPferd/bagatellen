/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.basic.impl;

import dom.jfischer.probeunify2.basic.IExtension;
import dom.jfischer.probeunify2.basic.ILeafCollector;
import dom.jfischer.probeunify2.pel.IPELLeafCollector;

/**
 *
 * @author jfischer
 * @param <NonVariableExtension>
 */
public class LeafCollector<NonVariableExtension extends IExtension> extends
        SimpleLeafCollector<NonVariableExtension> implements
        ILeafCollector<NonVariableExtension> {

    private final IPELLeafCollector allLeafCollectors;

    public LeafCollector(IPELLeafCollector allLeafCollects) {
        this.allLeafCollectors = allLeafCollects;
    }

    @Override
    public IPELLeafCollector getAllLeafCollectors() {
        return this.allLeafCollectors;
    }

}
