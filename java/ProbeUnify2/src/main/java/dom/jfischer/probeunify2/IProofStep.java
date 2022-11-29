/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify2;

import dom.jfischer.probeunify2.basic.IExpression;
import dom.jfischer.probeunify2.basic.IVariable;
import dom.jfischer.probeunify2.pel.ITermNonVariableExtension;
import dom.jfischer.probeunify2.proof.IGoalExtension;
import dom.jfischer.probeunify2.proof.IGoalNonVariableExtension;
import java.io.Serializable;
import java.util.List;
import java.util.Set;

/**
 *
 * @author jfischer
 */
public interface IProofStep extends Serializable {

    Set<IVariable<ITermNonVariableExtension>> getTermVariables();

    List<IExpression<IGoalExtension, IGoalNonVariableExtension>> getGoals();

    void reset();

}
