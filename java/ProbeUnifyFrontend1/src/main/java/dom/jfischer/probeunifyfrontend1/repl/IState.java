/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunifyfrontend1.repl;

import dom.jfischer.probeunify3.basic.IClause;
import dom.jfischer.probeunifyfrontend1.exceptions.QualificatorException;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.Serializable;

/**
 *
 * @author jfischer
 */
public interface IState extends Serializable {

    void addProofStep();

    void apply(int goalNr, String proofName) throws IOException;

    boolean assume(int goalNr, int premiseNr);

    boolean checkGoalNr(Integer goalNr);

    boolean checkPremiseNr(int goalNr, Integer premiseNr);
    
    boolean checkProofStepNr(Integer proofStepNr);

    void init();

    IClause parseClauseSelector(String selectorString) throws QualificatorException;

    void printAssumptions(int goalNr);

    void printProofState();

    void printVariables();

    boolean resolve(int goalNr, String selectorString);
    
    void save(String proofName) throws FileNotFoundException;

    void saveState();

    void undo(int proofStepNr);

}
