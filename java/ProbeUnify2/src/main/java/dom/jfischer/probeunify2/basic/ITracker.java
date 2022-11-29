/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify2.basic;

import dom.jfischer.probeunify2.pel.IPELTracker;

/**
 *
 * @author jfischer
 * @param <NonVariableExtension>
 */
public interface ITracker<NonVariableExtension extends IExtension> extends
        ISimpleTracker<NonVariableExtension> {

    IPELTracker getAllTrackers();

}
