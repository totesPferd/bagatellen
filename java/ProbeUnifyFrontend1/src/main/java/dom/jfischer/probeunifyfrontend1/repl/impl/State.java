/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunifyfrontend1.repl.impl;

import dom.jfischer.pph.IConstructionPPrint;
import dom.jfischer.pph.IPPrintBase;
import dom.jfischer.pph.IPPrintConfig;
import dom.jfischer.pph.impl.PPrintBase;
import dom.jfischer.pph.impl.PPrintConfig;
import dom.jfischer.probeunify3.basic.IAssumptionsContext;
import dom.jfischer.probeunify3.basic.IClause;
import dom.jfischer.probeunify3.basic.IGoal;
import dom.jfischer.probeunify3.basic.ILeafCollector;
import dom.jfischer.probeunify3.basic.IProofStep;
import dom.jfischer.probeunify3.basic.ITNonVariableXt;
import dom.jfischer.probeunify3.basic.IVariable;
import dom.jfischer.probeunify3.basic.impl.LeafCollector;
import dom.jfischer.probeunify3.basic.impl.ProofStep;
import dom.jfischer.probeunify3.module.IModule;
import dom.jfischer.probeunify3.module.IObject;
import dom.jfischer.probeunifyfrontend1.antlr.impl.AntlrHelper;
import dom.jfischer.probeunifyfrontend1.exceptions.QualificatorException;
import dom.jfischer.probeunifyfrontend1.names.IPELXt;
import dom.jfischer.probeunifyfrontend1.pph.IBackReference;
import dom.jfischer.probeunifyfrontend1.pph.impl.BackReference;
import dom.jfischer.probeunifyfrontend1.pph.impl.ClauseConstructionPPrint;
import dom.jfischer.probeunifyfrontend1.pph.impl.VarAssgnConstructionPPrint;
import dom.jfischer.probeunifyfrontend1.pph.impl.VariableContextConstructionPPrint;
import dom.jfischer.probeunifyfrontend1.repl.IState;
import dom.jfischer.probeunifyfrontend1.repl.IStatePersistence;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.PrintStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;
import org.antlr.v4.runtime.CharStream;

/**
 *
 * @author jfischer
 */
public class State implements IState {

    private final IStatePersistence statePersistence
            = new StatePersistence();
    private final IPPrintConfig pprintConfig
            = new PPrintConfig();
    private final List<IProofStep> proofSteps
            = Collections.synchronizedList(new ArrayList<>());
    private final List<IGoal> openGoals
            = Collections.synchronizedList(new ArrayList<>());
    private final IBackReference backReference
            = new BackReference();

    private final IGoal goal;

    private transient IPPrintBase pprintBase = null;

    public State(IGoal goal) {
        this.goal = goal;
    }

    @Override
    public void addProofStep() {
        this.openGoals.clear();
        Set<IGoal> goals
                = Collections.synchronizedSet(new HashSet<>());
        this.goal.collectOpenGoals(goals);
        this.openGoals.addAll(goals);
        ILeafCollector<ITNonVariableXt> leafCollector
                = new LeafCollector<>();
        this.openGoals
                .parallelStream()
                .map(goal -> goal.getConclusion())
                .forEach(literal -> literal.collectLeafs(leafCollector));
        IProofStep nextProofStep
                = new ProofStep(goals, leafCollector.getLeafs());
        this.proofSteps.add(nextProofStep);
    }

    @Override
    public void apply(int goalNr, String proofName) throws IOException {
        CharStream proofCharStream = AntlrHelper.getProofCharStream(proofName);
        Set<IClause> parseProof = AntlrHelper.parseProof(proofCharStream);
        this.openGoals.get(goalNr).applyProof(parseProof);
        this.addProofStep();
        this.printProofState();
    }

    @Override
    public boolean assume(int goalNr, int premiseNr) {
        IGoal nextGoal = this.openGoals.get(goalNr);
        List<IClause> assumptions
                = this.getAssumptions(nextGoal);
        IClause nextPremise = assumptions.get(premiseNr);
        boolean retval = nextGoal.resolve(nextPremise);

        if (retval) {
            nextGoal.commit();
            this.addProofStep();
            this.printProofState();
        }

        return retval;
    }

    @Override
    public boolean checkGoalNr(Integer goalNr) {
        return goalNr != null && goalNr >= 0 && goalNr < this.openGoals.size();
    }

    @Override
    public boolean checkPremiseNr(int goalNr, Integer premiseNr) {
        return premiseNr != null
                && goalNr >= 0
                && goalNr < this.getAssumptions(this.openGoals.get(goalNr)).size();
    }

    @Override
    public boolean checkProofStepNr(Integer proofStepNr) {
        return proofStepNr != null
                && proofStepNr >= 0
                && proofStepNr < this.proofSteps.size();
    }

    @Override
    public void init() {
        this.backReference.put(AntlrHelper.getModule());
    }

    @Override
    public IClause parseClauseSelector(String selectorString) throws QualificatorException {
        String[] items = selectorString.split("\\.");
        int lastIndex = items.length - 1;
        List<String> qualItems
                = Collections.synchronizedList(Arrays.stream(items, 0, lastIndex)
                        .collect(Collectors.toList()));
        IModule<IPELXt> subModule = this.selectModule(qualItems);
        IPELXt pelXt = subModule.getXt();
        IClause retval = null;
        if (pelXt.getAxioms().containsKey(items[lastIndex])) {
            IObject clauseSelector = pelXt.getAxioms().get(items[lastIndex]);
            retval = subModule.getAxioms().get(clauseSelector);
        } else {
            throw new QualificatorException();
        }
        return retval;
    }

    @Override
    public void printAssumptions(int goalNr) {
        List<IClause> assumptions
                = this.getAssumptions(this.openGoals.get(goalNr));
        this.updPPrintBase();
        for (int i = 0; i < assumptions.size(); i++) {
            this.pprintBase.printToken(Integer.toString(i + 1));
            this.pprintBase.printPeriod(".");
            this.pprintBase.setDeeperIndent();
            {
                IConstructionPPrint clauseConstructionPPrint
                        = new ClauseConstructionPPrint(
                                AntlrHelper.getVariableNameInfo(),
                                this.backReference,
                                assumptions.get(i)
                        );
                clauseConstructionPPrint.pprint(pprintBase);
            }
            this.pprintBase.restoreIndent();
            this.pprintBase.printNewLine();
        }
    }

    @Override
    public void printProofState() {
        this.updPPrintBase();
        this.pprintBase.printToken("step");
        this.pprintBase.printToken("#" + this.proofSteps.size());
        this.pprintBase.printNewLine();

        {
            IConstructionPPrint variableContextConstructionPPrint
                    = new VariableContextConstructionPPrint(
                            AntlrHelper.getVariableNameInfo(),
                            this.goal.getVariableContext()
                    );
            variableContextConstructionPPrint.pprint(this.pprintBase);
        }

        for (int i = 0; i < this.openGoals.size(); i++) {
            pprintBase.navigateToPos(0);
            this.pprintBase.printToken(Integer.toString(i + 1));
            this.pprintBase.printPeriod(".");
            this.pprintBase.setDeeperIndent();
            {
                IConstructionPPrint clauseConstructionPPrint
                        = new ClauseConstructionPPrint(
                                AntlrHelper.getVariableNameInfo(),
                                this.backReference,
                                openGoals.get(i).getClause()
                        );
                clauseConstructionPPrint.pprint(pprintBase);
            }
            this.pprintBase.restoreIndent();
            this.pprintBase.printNewLine();
        }
    }

    @Override
    public void printVariables() {
        IConstructionPPrint variablesConstructionPPrint
                = new VarAssgnConstructionPPrint(
                        AntlrHelper.getVariableNameInfo(),
                        AntlrHelper.getTermVariableInfo(),
                        this.backReference,
                        this.goal.getVariableContext()
                );
        this.updPPrintBase();
        pprintBase.printNewLine();
        variablesConstructionPPrint.pprint(pprintBase);
        pprintBase.printNewLine();
    }

    @Override
    public boolean resolve(int goalNr, String selectorString) {
        IGoal nextGoal = this.openGoals.get(goalNr);
        IClause nextPremise = this.parseClauseSelector(selectorString);
        boolean retval = nextGoal.resolve(nextPremise);

        if (retval) {
            nextGoal.commit();
            this.addProofStep();
            this.printProofState();
        }

        return retval;
    }

    @Override
    public void save(String proofName) throws FileNotFoundException {
        String realProofFileName = AntlrHelper.getRealProofFileName(proofName);
        try ( PrintStream outStream = new PrintStream(realProofFileName)) {
            Set<IClause> proof = Collections.synchronizedSet(new HashSet<>());
            this.goal.createProof(proof);
            IPPrintBase proofOutPprintBase
                    = new PPrintBase(outStream, this.pprintConfig, 0);
            proofOutPprintBase.printToken(AntlrHelper.getModuleName());
            proofOutPprintBase.printNewLine();
            for (IClause clause : proof) {
                IConstructionPPrint clauseConstructionPPrint
                        = new ClauseConstructionPPrint(
                                AntlrHelper.getVariableNameInfo(),
                                this.backReference,
                                clause
                        );
                clauseConstructionPPrint.pprint(proofOutPprintBase);
                proofOutPprintBase.printNewLine();
            }
        } catch (FileNotFoundException ex) {
            throw ex;
        }
    }

    @Override
    public void saveState() {
        this.statePersistence.backup(this);
    }

    @Override
    public void undo(int proofStepNr) {
        for (int i = this.proofSteps.size() - 1; i > proofStepNr; i--) {
            this.proofSteps.remove(i);
        }
        this.killVariables();
        IProofStep currentProofStep = this.proofSteps.get(proofStepNr);
        this.resetProofStep(currentProofStep);
        this.printProofState();
    }

    private void killVariables() {
        Set<IVariable<ITNonVariableXt>> variables
                = Collections.synchronizedSet(new HashSet<>());
        this.proofSteps
                .parallelStream()
                .map(ps -> ps.getVariables())
                .forEach(vs -> variables.addAll(vs));
        AntlrHelper.getTermVariableInfo().retainAll(variables);
        AntlrHelper.getVariableNameInfo().retainAll(variables);
    }

    private void resetProofStep(IProofStep proofStep) {
        proofStep.reset();
        this.openGoals.clear();
        Set<IGoal> goals = Collections.synchronizedSet(new HashSet<>());
        this.goal.collectOpenGoals(goals);
        this.openGoals.addAll(goals);
    }

    private IModule<IPELXt> selectModule(List<String> selector) throws QualificatorException {
        IModule<IPELXt> retval = AntlrHelper.getModule();

        for (String qualItem : selector) {
            IPELXt pelXt = retval.getXt();
            if (pelXt.getQuals().containsKey(qualItem)) {
                IObject s = pelXt.getQuals().get(qualItem);
                retval = retval.getImports().get(s);
            } else {
                throw new QualificatorException();
            }
        }

        return retval;
    }

    private void updPPrintBase() {
        if (this.pprintBase == null) {
            this.pprintBase = new PPrintBase(System.out, pprintConfig, 0);
        }
    }

    private List<IClause> getAssumptions(IGoal goal) {
        List<IClause> retval =  Collections.synchronizedList(new ArrayList<>());
        
        IAssumptionsContext assumptionsContext
                =  goal.getAssumptions();
        while (assumptionsContext.getParent().isPresent()) {
            retval.addAll(assumptionsContext.getAssumptions());
            assumptionsContext =  assumptionsContext.getParent().get();
        }
        
        return retval;
    }
    
}
