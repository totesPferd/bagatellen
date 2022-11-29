/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify2.pel;

import dom.jfischer.probeunify2.basic.IExtension;
import dom.jfischer.probeunify2.basic.ITrivialExtension;
import dom.jfischer.probeunify2.basic.IVariableContext;

/**
 *
 * @author jfischer
 */
public interface IPELVariableContext extends IExtension {

    IVariableContext<ITrivialExtension, ILiteralNonVariableExtension> getLiteralVariableContext();

    IVariableContext<ITermExtension, ITermNonVariableExtension> getTermVariableContext();

}
