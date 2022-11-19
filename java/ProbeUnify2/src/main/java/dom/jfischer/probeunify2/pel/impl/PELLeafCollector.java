/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pel.impl;

import dom.jfischer.probeunify2.basic.ILeafCollector;
import dom.jfischer.probeunify2.basic.impl.LeafCollector;
import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;
import dom.jfischer.probeunify2.pel.IPELLeafCollector;
import dom.jfischer.probeunify2.pel.ITermNonVariableExtension;
import dom.jfischer.probeunify2.proof.IGoalNonVariableExtension;

/**
 *
 * @author jfischer
 */
public class PELLeafCollector implements IPELLeafCollector {

    private final ILeafCollector<ITermNonVariableExtension> termLeafCollector
            = new LeafCollector<>(this);
    private final ILeafCollector<ILiteralNonVariableExtension> literalLeafCollector
            = new LeafCollector<>(this);
    private final ILeafCollector<IGoalNonVariableExtension> goalLeafCollector
            = new LeafCollector<>(this);

    @Override
    public ILeafCollector<ITermNonVariableExtension> getTermLeafCollector() {
        return this.termLeafCollector;
    }

    @Override
    public ILeafCollector<ILiteralNonVariableExtension> getLiteralLeafCollector() {
        return this.literalLeafCollector;
    }

    @Override
    public ILeafCollector<IGoalNonVariableExtension> getGoalLeafCollector() {
        return this.goalLeafCollector;
    }

    @Override
    public void undo() {
        this.termLeafCollector.undo();
        this.literalLeafCollector.undo();
        this.goalLeafCollector.undo();
    }

}
