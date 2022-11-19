/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify2.proof;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.IExtension;
import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;
import java.util.List;

/**
 *
 * @author jfischer
 */
public interface IClause extends IExtension {

    IBaseExpression<ILiteralNonVariableExtension> getConclusion();

    List<IBaseExpression<ILiteralNonVariableExtension>> getPremises();

}
