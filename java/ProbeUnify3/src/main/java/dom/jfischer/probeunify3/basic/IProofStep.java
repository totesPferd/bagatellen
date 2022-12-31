/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify3.basic;

import java.io.Serializable;
import java.util.Set;

/**
 *
 * @author jfischer
 */
public interface IProofStep extends Serializable {
    
    Set<IGoal> getOpenGoals();
    
    Set<IVariable<ITNonVariableXt>> getVariables();
    
    void reset();
    
}
