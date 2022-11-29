/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pel.impl;

import dom.jfischer.probeunify2.basic.ITracker;
import dom.jfischer.probeunify2.basic.impl.Tracker;
import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;
import dom.jfischer.probeunify2.pel.IPELTracker;
import dom.jfischer.probeunify2.pel.ITermNonVariableExtension;
import dom.jfischer.probeunify2.basic.ITrivialExtension;

/**
 *
 * @author jfischer
 */
public class PELTracker implements IPELTracker {

    private final ITracker<ITermNonVariableExtension> termTracker
            = new Tracker<>(this);
    private final ITracker<ILiteralNonVariableExtension> literalTracker
            = new Tracker<>(this);
    private final ITracker<ITrivialExtension> sortTracker
            = new Tracker<>(this);
    private final ITracker<ITrivialExtension> predicateTracker
            = new Tracker<>(this);
    private final ITracker<ITrivialExtension> operationTraccker
            = new Tracker<>(this);

    @Override
    public ITracker<ITermNonVariableExtension> getTermTracker() {
        return this.termTracker;
    }

    @Override
    public ITracker<ILiteralNonVariableExtension> getLiteralTracker() {
        return this.literalTracker;
    }

    @Override
    public ITracker<ITrivialExtension> getSortTracker() {
        return this.sortTracker;
    }

    @Override
    public ITracker<ITrivialExtension> getPredicateTracker() {
        return this.predicateTracker;
    }

    @Override
    public ITracker<ITrivialExtension> getOperationTracker() {
        return this.operationTraccker;
    }

}
