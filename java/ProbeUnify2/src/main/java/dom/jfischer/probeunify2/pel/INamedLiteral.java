/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify2.pel;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.ICheckFreeness;
import dom.jfischer.probeunify2.basic.IExpression;
import dom.jfischer.probeunify2.basic.ITrivialExtension;

/**
 *
 * @author jfischer
 */
public interface INamedLiteral extends
        ICheckFreeness,
        IExpression<ITrivialExtension, ILiteralNonVariableExtension> {

    IBaseExpression<ILiteralNonVariableExtension> getLiteral();

    IPELVariableContext getPelVariableContext();

}
