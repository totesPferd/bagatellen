/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify2.pel;

import dom.jfischer.probeunify2.basic.ILeafCollector;
import java.io.Serializable;

/**
 *
 * @author jfischer
 */
public interface IPELLeafCollector extends Serializable {

    ILeafCollector<ITermNonVariableExtension> getTermLeafCollector();

    ILeafCollector<ILiteralNonVariableExtension> getLiteralLeafCollector();

    void undo();

}
