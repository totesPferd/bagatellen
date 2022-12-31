/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify3.basic.impl;

import dom.jfischer.probeunify3.basic.IAssumptionsContext;
import dom.jfischer.probeunify3.basic.IClause;
import dom.jfischer.probeunify3.basic.ICompare;
import dom.jfischer.probeunify3.basic.ICopy;
import dom.jfischer.probeunify3.basic.IGoal;
import dom.jfischer.probeunify3.basic.ITNonVariableXt;
import dom.jfischer.probeunify3.basic.ITracker;
import dom.jfischer.probeunify3.basic.IUnification;
import dom.jfischer.probeunify3.basic.IVariableContext;
import dom.jfischer.probeunify3.basic.IXpr;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

/**
 *
 * @author jfischer
 */
public class Goal implements IGoal {

    private final IVariableContext<ITNonVariableXt> variableContext;
    private final IAssumptionsContext assumptions;
    private final IXpr<ITNonVariableXt> conclusion;
    private final ICompare<IClause> comparer;

    private final IUnification<IXpr<ITNonVariableXt>> literalUnification
            = new XprUnification<>();
    private final ICopy<IClause, ITracker<IXpr<ITNonVariableXt>>> clauseCopier
            = new ClauseCopy();

    private List<IGoal> subgoals = null;

    public Goal(IClause clause, IAssumptionsContext assumptions) {
        this.variableContext = clause.getVariableContext();
        this.assumptions
                = new AssumptionsContext(clause.getPremises(), assumptions);
        this.conclusion = clause.getConclusion();
        this.comparer = new Compare<>(this.variableContext);
    }

    @Override
    public boolean resolve(IClause clause) {
        ITracker<IXpr<ITNonVariableXt>> tracker
                = new Tracker<>();
        IClause clauseCopy = this.clauseCopier.copy(tracker, clause);

        boolean retval = this.literalUnification.unify(this.conclusion, clauseCopy.getConclusion());
        if (retval) {
            this.conclusion.commit();
            clauseCopy.commit();
            this.subgoals = clauseCopy.getPremises()
                    .parallelStream()
                    .map(l -> new Goal(l, this.assumptions))
                    .collect(Collectors.toList());
        }

        return retval;
    }

    @Override
    public IVariableContext<ITNonVariableXt> getVariableContext() {
        return this.variableContext;
    }

    @Override
    public IAssumptionsContext getAssumptions() {
        return this.assumptions;
    }

    @Override
    public IXpr<ITNonVariableXt> getConclusion() {
        return this.conclusion;
    }

    @Override
    public IClause getClause() {
        return new Clause(
                this.variableContext,
                this.getAllAssumptions(),
                this.conclusion
        );
    }

    @Override
    public void clear() {
        this.subgoals = null;
    }

    @Override
    public void collectOpenGoals(Set<IGoal> openGoals) {
        if (this.subgoals == null) {
            openGoals.add(this);
        } else {
            this.subgoals
                    .parallelStream()
                    .forEach(subgoal -> subgoal.collectOpenGoals(openGoals));
        }
    }

    @Override
    public void createProof(Set<IClause> proof) {
        if (this.subgoals != null) {
            proof.add(new Clause(this));
            this.subgoals
                    .parallelStream()
                    .forEach(goal -> goal.createProof(proof));
        }
    }

    @Override
    public void applyProof(Set<IClause> proof) {
        if (!proof.isEmpty()) {
            Set<IGoal> openGoals
                    = Collections.synchronizedSet(new HashSet<>());
            this.collectOpenGoals(openGoals);
            for (IGoal openGoal : openGoals) {
                Set<IClause> candidates
                        = this.comparer.getMaximalSet(
                                u -> u.getConclusion(),
                                proof,
                                openGoal.getConclusion()
                        );
                if (candidates.size() == 1) {
                    for (IClause candidate : candidates) {
                        if (openGoal.resolve(candidate)) {
                            candidate.commit();
                            openGoal.commit();
                            Set<IClause> proofCopy = proof
                                    .parallelStream()
                                    .filter(clause -> clause != candidate)
                                    .collect(Collectors.toSet());
                            openGoal.applyProof(proofCopy);
                        }
                    }
                }
            }
        }
    }

    @Override
    public void commit() {
        this.assumptions.commit();
        this.conclusion.commit();
    }

    @Override
    public void reset() {
        this.assumptions.reset();
        this.conclusion.reset();
    }

    private List<IClause> getAllAssumptions() {
        List<IClause> retval = Collections.synchronizedList(new ArrayList<>());

        IAssumptionsContext ac
                = this.assumptions;
        while (ac.getParent().isPresent()) {
            retval.addAll(ac.getAssumptions());
            ac = ac.getParent().get();
        }

        return retval;
    }
}
