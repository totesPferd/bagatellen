/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify2.module;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.IExtension;
import dom.jfischer.probeunify2.basic.ITrivialExtension;
import dom.jfischer.probeunify2.pel.ITermNonVariableExtension;
import dom.jfischer.probeunify2.pprint.ITermVariableContext;

/**
 *
 * @author jfischer
 */
public interface INamedTerm extends IExtension {

    IBaseExpression<ITermNonVariableExtension> getTerm();

    IBaseExpression<ITrivialExtension> getSort();

    ITermVariableContext getTermVariableContext();

}
