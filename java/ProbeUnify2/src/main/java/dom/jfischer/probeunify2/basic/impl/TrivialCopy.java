/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.basic.impl;

import dom.jfischer.probeunify2.basic.ICopy;
import dom.jfischer.probeunify2.basic.ITrivialExtension;
import dom.jfischer.probeunify2.pel.IPELLeafCollector;
import dom.jfischer.probeunify2.pel.IPELTracker;

/**
 *
 * @author jfischer
 */
public class TrivialCopy implements ICopy<ITrivialExtension> {

    @Override
    public ITrivialExtension copy(IPELTracker tracker, ITrivialExtension object) {
        return object;
    }

    @Override
    public void collectLeafs(IPELLeafCollector leafCollector, ITrivialExtension object) {
    }
    
}
