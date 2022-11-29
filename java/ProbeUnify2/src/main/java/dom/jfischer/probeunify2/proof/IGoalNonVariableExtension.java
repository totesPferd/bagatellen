/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify2.proof;

import dom.jfischer.probeunify2.basic.IExpression;
import dom.jfischer.probeunify2.basic.IExtension;
import java.util.List;

/**
 *
 * @author jfischer
 */
public interface IGoalNonVariableExtension extends
        IExtension {

    List<IExpression<IGoalExtension, IGoalNonVariableExtension>> getSubGoals();

}
