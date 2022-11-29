/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.basic.impl;

import dom.jfischer.probeunify2.basic.IExtension;
import dom.jfischer.probeunify2.basic.ITracker;
import dom.jfischer.probeunify2.pel.IPELTracker;

/**
 *
 * @author jfischer
 * @param <NonVariableExtension>
 */
public class Tracker<
        NonVariableExtension extends IExtension> extends
        SimpleTracker<NonVariableExtension> implements
        ITracker<NonVariableExtension> {

    private final IPELTracker allTrackers;

    public Tracker(IPELTracker allTrackers) {
        this.allTrackers = allTrackers;
    }

    @Override
    public IPELTracker getAllTrackers() {
        return this.allTrackers;
    }

}
