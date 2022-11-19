/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify2;

import dom.jfischer.probeunify2.exception.QualificatorException;
import dom.jfischer.probeunify2.module.IModule;
import dom.jfischer.probeunify2.module.INamedClause;
import dom.jfischer.probeunify2.pprint.IBackReference;
import dom.jfischer.probeunify2.proof.IGoalExpression;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.Serializable;
import java.util.List;
import java.util.Optional;

/**
 *
 * @author jfischer
 */
public interface IState extends Serializable {

    IModule getModule();

    IBackReference getBackReference();

    INamedClause getConjecture();

    IGoalExpression getGoal();

    void printProofState();

    void printTermVariables();

    boolean checkGoalNr(Integer goalNr);

    boolean checkPremiseNr(Integer premiseNr);

    boolean checkProofStepNr(Integer proofStepNr);

    Optional<INamedClause> parseClauseSelector(String selector)
            throws QualificatorException;

    List<IGoalExpression> getOpenGoals();

    void addProofStep();

    void apply(int goalNr, String proofName) throws IOException;
    
    boolean assume(int goalNr, int premiseNr);

    void assumeAll();
    
    boolean resolve(int goalNr, INamedClause clause);

    void save(String proofName) throws FileNotFoundException;
    
    void saveState();
    
    void undo(int proofStepNr);

}
