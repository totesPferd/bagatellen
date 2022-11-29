/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify2.basic;

import dom.jfischer.probeunify2.pel.IPELLeafCollector;

/**
 *
 * @author jfischer
 * @param <NonVariableExtension>
 */
public interface ILeafCollector<NonVariableExtension extends IExtension> extends
        ISimpleLeafCollector<NonVariableExtension> {

    IPELLeafCollector getAllLeafCollectors();

}
