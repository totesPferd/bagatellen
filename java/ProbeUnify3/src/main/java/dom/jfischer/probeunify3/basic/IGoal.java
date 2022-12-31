/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify3.basic;

import java.util.Set;

/**
 *
 * @author jfischer
 */
public interface IGoal extends IResettable {

    IVariableContext<ITNonVariableXt> getVariableContext();

    IAssumptionsContext getAssumptions();

    IXpr<ITNonVariableXt> getConclusion();

    IClause getClause();
    
    void clear();
    
    boolean resolve(IClause clause);

    void collectOpenGoals(Set<IGoal> openGoals);

    void createProof(Set<IClause> proof);
    
    void applyProof(Set<IClause> proof);

}
