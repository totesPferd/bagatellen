/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2;

import dom.jfischer.probeunify2.antlr.impl.AntlrHelper;
import dom.jfischer.probeunify2.antlr.impl.PelThisListener;
import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.ICompare;
import dom.jfischer.probeunify2.basic.ICopy;
import dom.jfischer.probeunify2.basic.IUnification;
import dom.jfischer.probeunify2.basic.IVariable;
import dom.jfischer.probeunify2.basic.impl.BaseUnification;
import dom.jfischer.probeunify2.basic.impl.Compare;
import dom.jfischer.probeunify2.exception.QualificatorException;
import dom.jfischer.probeunify2.module.IModule;
import dom.jfischer.probeunify2.module.INamedClause;
import dom.jfischer.probeunify2.module.INamedLiteral;
import dom.jfischer.probeunify2.module.impl.NamedClause;
import dom.jfischer.probeunify2.module.impl.NamedClauseCopy;
import dom.jfischer.probeunify2.module.impl.NamedLiteral;
import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;
import dom.jfischer.probeunify2.pel.IPELLeafCollector;
import dom.jfischer.probeunify2.pel.IPELTracker;
import dom.jfischer.probeunify2.pel.ITermNonVariableExtension;
import dom.jfischer.probeunify2.pel.impl.PELLeafCollector;
import dom.jfischer.probeunify2.pel.impl.PELTracker;
import dom.jfischer.probeunify2.pprint.IBackReference;
import dom.jfischer.probeunify2.pprint.IConstructionPPrint;
import dom.jfischer.probeunify2.pprint.IPPrintBase;
import dom.jfischer.probeunify2.pprint.ITermVariableContext;
import dom.jfischer.probeunify2.pprint.impl.ClauseConstructionPPrint;
import dom.jfischer.probeunify2.pprint.impl.LiteralConstructionPPrint;
import dom.jfischer.probeunify2.pprint.impl.PPrintBase;
import dom.jfischer.probeunify2.pprint.impl.PPrintConfig;
import dom.jfischer.probeunify2.pprint.impl.TermLeafConstructionPPrint;
import dom.jfischer.probeunify2.proof.IClause;
import dom.jfischer.probeunify2.proof.IGoalExpression;
import dom.jfischer.probeunify2.proof.IGoalExtension;
import dom.jfischer.probeunify2.proof.impl.GoalExpressionCopy;
import dom.jfischer.probeunify2.proof.impl.ProofHelper;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.PrintStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;
import org.antlr.v4.runtime.CharStream;

/**
 *
 * @author jfischer
 */
public class State implements IState {

    private final IModule module;
    private final IBackReference backReference;
    private final INamedClause conjecture;
    private final IGoalExpression goal;
    private final String moduleName;

    private final PPrintConfig pprintConfig;

    private final IPELLeafCollector leafCollector;

    private final ICopy<INamedClause> namedClauseCopier
            = new NamedClauseCopy();
    private final ICopy<IGoalExpression> goalCopier
            = new GoalExpressionCopy();
    private final IUnification<IBaseExpression<ILiteralNonVariableExtension>> literalUnification
            = new BaseUnification<>();
    private final List<IProofStep> proofSteps = Collections.synchronizedList(new ArrayList<>());

    private final IStatePersistence statePersistence = new StatePersistence();

    private transient PPrintBase pprintBase = null;
    private List<IGoalExpression> openGoals = null;

    public State(
            IModule module,
            IBackReference backReference,
            IPELLeafCollector leafCollector,
            String moduleName,
            INamedClause conjecture,
            IGoalExpression goal) {
        this.module = module;
        this.backReference = backReference;
        this.leafCollector = leafCollector;
        this.conjecture = conjecture;
        this.goal = goal;
        this.moduleName = moduleName;

        this.pprintConfig = new PPrintConfig();
    }

    @Override
    public IModule getModule() {
        return this.module;
    }

    @Override
    public IBackReference getBackReference() {
        return this.backReference;
    }

    @Override
    public INamedClause getConjecture() {
        return this.conjecture;
    }

    @Override
    public IGoalExpression getGoal() {
        return this.goal;
    }

    @Override
    public void printProofState() {
        ITermVariableContext termVariableContext = this.conjecture.getTermVariableContext();

        this.updPPrintBase();
        this.pprintBase.printToken("step");
        this.pprintBase.printToken("#" + this.proofSteps.size());
        this.pprintBase.printNewLine();
        {
            List<IBaseExpression<ILiteralNonVariableExtension>> premises
                    = this.conjecture.getClause().getPremises();
            for (int i = 0; i < premises.size(); i++) {
                INamedLiteral namedLiteral = new NamedLiteral(premises.get(i), termVariableContext);
                IConstructionPPrint literalConstructionPPrint
                        = new LiteralConstructionPPrint(this.backReference, namedLiteral);
                this.pprintBase.printToken(Integer.toString(i + 1));
                this.pprintBase.printPeriod(".");
                this.pprintBase.setDeeperIndent();
                literalConstructionPPrint.pprint(this.pprintBase);
                this.pprintBase.restoreIndent();
                this.pprintBase.printNewLine();
            }
        }

        this.pprintBase.printToken("==>");
        this.pprintBase.printNewLine();

        {
            for (int i = 0; i < this.openGoals.size(); i++) {
                INamedLiteral namedLiteral = new NamedLiteral(
                        this.openGoals.get(i).getExtension().getGoal(),
                        termVariableContext);
                IConstructionPPrint literalConstructionPPrint
                        = new LiteralConstructionPPrint(this.backReference, namedLiteral);
                pprintBase.printToken(Integer.toString(i + 1));
                pprintBase.printPeriod(".");
                pprintBase.setDeeperIndent();
                literalConstructionPPrint.pprint(this.pprintBase);
                pprintBase.restoreIndent();
                pprintBase.printNewLine();
            }
        }
    }

    @Override
    public List<IGoalExpression> getOpenGoals() {
        return this.openGoals;
    }

    @Override
    public void printTermVariables() {
        ITermVariableContext termVariableContext = this.conjecture.getTermVariableContext();
        IConstructionPPrint constructionPPrint
                = new TermLeafConstructionPPrint(
                        this.backReference,
                        termVariableContext,
                        this.leafCollector
                );
        this.updPPrintBase();
        constructionPPrint.pprint(this.pprintBase);
        pprintBase.printNewLine();
    }

    @Override
    public void apply(int goalNr, String proofName) throws IOException {
        CharStream proofCharStream = AntlrHelper.getProofCharStream(proofName);
        PelThisListener pelThisListener = new PelThisListener(this.module, this.moduleName);
        pelThisListener.resetTermVariableContext();
        AntlrHelper.parseProof(pelThisListener, proofCharStream);
        IGoalExpression selectedGoal = this.openGoals.get(goalNr);
        ProofHelper.applyProof(selectedGoal, pelThisListener.getProof());
        {
            IPELLeafCollector localLeafCollector = new PELLeafCollector();
            this.goalCopier.collectLeafs(localLeafCollector, selectedGoal);
            Set<IVariable<ITermNonVariableExtension>> leafs
                    = localLeafCollector.getTermLeafCollector().getLeafs();
            leafs
                    .parallelStream()
                    .forEach(var -> this.conjecture.getTermVariableContext().addUnsortedVariable(var));
        }
        this.printProofState();
    }

    @Override
    public boolean assume(int goalNr, int premiseNr) {
        IBaseExpression<ILiteralNonVariableExtension> premise
                = this.conjecture.getClause().getPremises().get(premiseNr);
        IGoalExtension goalExtension = this.openGoals.get(goalNr).getExtension();
        IBaseExpression<ILiteralNonVariableExtension> goalLiteral
                = goalExtension.getGoal();
        boolean retval = this.literalUnification.unify(goalLiteral, premise);
        if (retval) {
            premise.commit();
            goalLiteral.commit();
            goalExtension.close();
            this.addProofStep();
            this.printProofState();
        }
        return retval;
    }

    @Override
    public void assumeAll() {
        boolean isUpdNeed = false;
        Set<IBaseExpression<ILiteralNonVariableExtension>> premises
                = Collections.synchronizedSet(this.conjecture.getClause().getPremises()
                        .parallelStream()
                        .collect(Collectors.toSet()));
        ICompare<IBaseExpression<ILiteralNonVariableExtension>> literalComparer
                = new Compare<>();
        for (IGoalExpression openGoal : this.openGoals) {
            IGoalExtension goalExtension = openGoal.getExtension();
            IBaseExpression<ILiteralNonVariableExtension> goalLiteral
                    = goalExtension.getGoal();
            Set<IBaseExpression<ILiteralNonVariableExtension>> minimalSet
                    = literalComparer.getMaximalSet(
                            lit -> lit,
                            premises,
                            goalLiteral);
            if (minimalSet.size() == 1) {
                for (IBaseExpression<ILiteralNonVariableExtension> premise : minimalSet) {
                    if (this.literalUnification.unify(goalLiteral, premise)) {
                        isUpdNeed = true;
                        premise.commit();
                        goalLiteral.commit();
                        goalExtension.close();
                    }
                }
            }
        }
        if (isUpdNeed) {
            this.addProofStep();
            this.printProofState();
        }
    }

    @Override
    public void addProofStep() {
        this.openGoals = Collections.synchronizedList(new ArrayList<>());
        ProofHelper.listOpenGoals(this.goal, this.openGoals);
        IPELLeafCollector pelLeafCollector = new PELLeafCollector();
        this.goalCopier.collectLeafs(pelLeafCollector, this.goal);
        Set<IVariable<ITermNonVariableExtension>> vars
                = pelLeafCollector.getTermLeafCollector().getLeafs();
        IProofStep proofStep = new ProofStep(vars, this.openGoals);
        this.proofSteps.add(proofStep);
    }

    @Override
    public boolean checkGoalNr(Integer goalNr) {
        return goalNr != null && goalNr >= 0 && goalNr < this.openGoals.size();
    }

    @Override
    public boolean checkPremiseNr(Integer premiseNr) {
        List<IBaseExpression<ILiteralNonVariableExtension>> premises
                = this.conjecture.getClause().getPremises();
        return premiseNr != null
                && premiseNr >= 0
                && premiseNr < premises.size();
    }

    @Override
    public boolean checkProofStepNr(Integer proofStepNr) {
        return proofStepNr != null
                && proofStepNr >= 0
                && proofStepNr < this.proofSteps.size();
    }

    @Override
    public Optional<INamedClause> parseClauseSelector(String selector)
            throws QualificatorException {
        String[] items = selector.split("\\.");
        int lastIndex = items.length - 1;
        List<String> qualItems
                = Collections.synchronizedList(Arrays.stream(items, 0, lastIndex)
                        .collect(Collectors.toList()));
        Optional<IModule> optModule = this.module.derefModule(qualItems);
        return optModule.map(m -> m.getAxioms().get(items[lastIndex]));
    }

    @Override
    public boolean resolve(int goalNr, INamedClause clause) {
        boolean retval = resolveWoPrinting(goalNr, clause);
        printProofState();
        return retval;
    }

    @Override
    public void save(String proofName) throws FileNotFoundException {
        String realProofFileName = AntlrHelper.getRealProofFileName(proofName);
        try ( PrintStream outStream = new PrintStream(realProofFileName)) {
            Set<IClause> proof = Collections.synchronizedSet(new HashSet<>());
            ProofHelper.createProof(this.goal, proof);
            IPPrintBase proofOutPprintBase
                    = new PPrintBase(outStream, this.pprintConfig, 0);
            proofOutPprintBase.printToken(this.moduleName);
            proofOutPprintBase.printNewLine();
            for (IClause clause : proof) {
                INamedClause namedClause
                        = new NamedClause(clause, this.conjecture.getTermVariableContext());
                IConstructionPPrint namedClauseConstructionPPrint
                        = new ClauseConstructionPPrint(this.backReference, namedClause);
                namedClauseConstructionPPrint.pprint(proofOutPprintBase);
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
        IProofStep currentProofStep = this.proofSteps.get(proofStepNr);
        this.resetProofStep(currentProofStep);
        this.printProofState();
    }

    private IProofStep currentProofStep() {
        return this.proofSteps.get(this.proofSteps.size() - 1);
    }

    private boolean resolveWoPrinting(int goalNr, INamedClause namedClause) {

        IGoalExpression selectedGoal = this.openGoals.get(goalNr);

        IPELTracker pelTracker = new PELTracker();

        INamedClause namedClauseInstance = this.namedClauseCopier.copy(pelTracker, namedClause);

        IClause clauseInstance = namedClauseInstance.getClause();

        boolean retval = ProofHelper.resolve(selectedGoal, clauseInstance);

        if (retval) {
            ITermVariableContext termVariableContext = this.conjecture.getTermVariableContext();
            termVariableContext.unify(namedClauseInstance.getTermVariableContext());
            this.addProofStep();
        }

        return retval;
    }

    private void resetProofStep(IProofStep proofStep) {
        proofStep.reset();
        this.conjecture.getTermVariableContext().retainAll(proofStep.getTermVariables());
        this.openGoals = Collections.synchronizedList(new ArrayList<>());
        ProofHelper.listOpenGoals(this.goal, this.openGoals);
    }

    private void updPPrintBase() {
        if (this.pprintBase == null) {
            this.pprintBase = new PPrintBase(System.out, pprintConfig, 0);
        }
    }

}
