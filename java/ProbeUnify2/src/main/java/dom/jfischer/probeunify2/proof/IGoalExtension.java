/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify2.proof;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.IExtension;
import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;

/**
 *
 * @author jfischer
 */
public interface IGoalExtension extends
        IExtension {

    boolean isClosed();

    void close();

    void undo();

    IBaseExpression<ILiteralNonVariableExtension> getGoal();

}
