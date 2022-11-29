/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify2;

import dom.jfischer.probeunify2.basic.IExpression;
import dom.jfischer.probeunify2.exception.QualificatorException;
import dom.jfischer.probeunify2.module.IModule;
import dom.jfischer.probeunify2.pel.INamedClause;
import dom.jfischer.probeunify2.pprint.IBackReference;
import dom.jfischer.probeunify2.proof.IGoalExtension;
import dom.jfischer.probeunify2.proof.IGoalNonVariableExtension;
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

    IExpression<IGoalExtension, IGoalNonVariableExtension> getGoal();

    void printProofState();

    void printVariables();

    boolean checkGoalNr(Integer goalNr);

    boolean checkPremiseNr(Integer premiseNr);

    boolean checkProofStepNr(Integer proofStepNr);

    Optional<INamedClause> parseClauseSelector(String selector)
            throws QualificatorException;

    List<IExpression<IGoalExtension, IGoalNonVariableExtension>> getOpenGoals();

    void addProofStep();

    void apply(int goalNr, String proofName) throws IOException;

    boolean assume(int goalNr, int premiseNr);

    void assumeAll();

    boolean resolve(int goalNr, INamedClause clause);

    void save(String proofName) throws FileNotFoundException;

    void saveState();

    void undo(int proofStepNr);

}
