/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify2.module;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.IExtension;
import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;
import dom.jfischer.probeunify2.pprint.ITermVariableContext;

/**
 *
 * @author jfischer
 */
public interface INamedLiteral extends IExtension {

    IBaseExpression<ILiteralNonVariableExtension> getLiteral();

    ITermVariableContext getTermVariableContext();

}
