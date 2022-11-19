/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify2.pel;

import dom.jfischer.probeunify2.basic.ITracker;
import dom.jfischer.probeunify2.proof.IGoalNonVariableExtension;
import dom.jfischer.probeunify2.basic.ITrivialExtension;

/**
 *
 * @author jfischer
 */
public interface IPELTracker {

    ITracker<ITermNonVariableExtension> getTermTracker();

    ITracker<IGoalNonVariableExtension> getGoalTracker();

    ITracker<ILiteralNonVariableExtension> getLiteralTracker();

    // meta unification:
    ITracker<ITrivialExtension> getSortTracker();

    ITracker<ITrivialExtension> getPredicateTracker();

    ITracker<ITrivialExtension> getOperationTracker();

}
