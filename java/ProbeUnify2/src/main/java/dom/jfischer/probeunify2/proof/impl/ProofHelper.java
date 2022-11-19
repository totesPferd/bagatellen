/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.proof.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.ICheckVariableOccurence;
import dom.jfischer.probeunify2.basic.ICompare;
import dom.jfischer.probeunify2.basic.ICopy;
import dom.jfischer.probeunify2.basic.IExpression;
import dom.jfischer.probeunify2.basic.INonVariable;
import dom.jfischer.probeunify2.basic.IUnification;
import dom.jfischer.probeunify2.basic.IVariable;
import dom.jfischer.probeunify2.basic.impl.Compare;
import dom.jfischer.probeunify2.basic.impl.NonVariable;
import dom.jfischer.probeunify2.basic.impl.Unification;
import dom.jfischer.probeunify2.basic.impl.Variable;
import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;
import dom.jfischer.probeunify2.proof.IClause;
import dom.jfischer.probeunify2.proof.IGoalExpression;
import dom.jfischer.probeunify2.proof.IGoalExtension;
import dom.jfischer.probeunify2.proof.IGoalNonVariableExtension;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

/**
 *
 * @author jfischer
 */
public class ProofHelper {

    public static IGoalExpression createGoal(IBaseExpression<ILiteralNonVariableExtension> arg) {
        IGoalExtension extension = new GoalExtension(arg);
        IVariable<IGoalNonVariableExtension> baseExpression
                = new Variable<>();
        return new GoalExpression(extension, baseExpression);
    }

    public static boolean resolve(IGoalExpression accu, IClause clause) {
        IBaseExpression<ILiteralNonVariableExtension> conclusion = clause.getConclusion();
        IGoalExtension goalExtension
                = new GoalExtension(conclusion);
        List<IBaseExpression<ILiteralNonVariableExtension>> premises
                = clause.getPremises();
        List<IGoalExpression> premiseGoals
                = Collections.synchronizedList(premises
                        .parallelStream()
                        .map(ProofHelper::createGoal)
                        .collect(Collectors.toList()));
        IGoalNonVariableExtension goalNonVariableExtension
                = new GoalNonVariableExtension(premiseGoals);
        ICopy<IGoalNonVariableExtension> goalNonVariableExtensionCopy
                = new GoalNonVariableExtensionCopy();
        ICheckVariableOccurence<IGoalNonVariableExtension> goalNonVariableExtensionVariableOccurenceChecker
                = new GoalNonVariableExtensionVariableOccurenceChecker();
        IUnification<IGoalNonVariableExtension> goalNonVariableExtensionUnification
                = new GoalNonVariableExtensionUnification();
        IBaseExpression<IGoalNonVariableExtension> goalNonVariableExpression
                = new NonVariable<>(
                        goalNonVariableExtension,
                        goalNonVariableExtensionVariableOccurenceChecker,
                        goalNonVariableExtensionCopy,
                        goalNonVariableExtensionUnification);
        IGoalExpression goalExpression
                = new GoalExpression(goalExtension, goalNonVariableExpression);
        IUnification<IGoalExtension> goalExtensionUnification
                = new GoalExtensionUnification();
        IUnification<IExpression<IGoalExtension, IGoalNonVariableExtension>> unification
                = new Unification<>(goalExtensionUnification);
        boolean retval = unification.unify(accu, goalExpression);
        if (retval) {
            accu.commit();
        }

        return retval;
    }

    public static void applyProof(IGoalExpression accu, Set<IClause> proof) {
        if (!proof.isEmpty()) {
            ICompare<IClause> clauseComparer
                    = new Compare<>();
            List<IGoalExpression> openGoals
                    = Collections.synchronizedList(new ArrayList<>());
            listOpenGoals(accu, openGoals);
            for (IGoalExpression openGoal : openGoals) {
                Set<IClause> candidates = clauseComparer.getMaximalSet(
                        u -> u.getConclusion(),
                        proof,
                        openGoal.getExtension().getGoal());
                if (candidates.size() == 1) {
                    for (IClause candidate : candidates) {
                        if (resolve(openGoal, candidate)) {
                            openGoal.commit();
                            Set<IClause> proofCopy = Collections.synchronizedSet(
                                    proof
                                            .parallelStream()
                                            .filter(c -> c != candidate)
                                            .collect(Collectors.toSet()));
                            applyProof(openGoal, proofCopy);
                        }
                    }
                }
            }
        }
    }

    public static void createProof(IGoalExpression accu, Set<IClause> proof) {
        IBaseExpression<IGoalNonVariableExtension> nextGoal = accu.getBaseExpression().dereference();
        {
            Optional<INonVariable<IGoalNonVariableExtension>> optNonVariableAccu
                    = nextGoal.nonVariable();
            if (optNonVariableAccu.isPresent()) {
                IBaseExpression<ILiteralNonVariableExtension> conclusion
                        = accu.getExtension().getGoal();
                List<IGoalExpression> premisesGoals
                        = optNonVariableAccu.get().getNonVariableExtension().getSubGoals();
                List<IBaseExpression<ILiteralNonVariableExtension>> premises
                        = Collections.synchronizedList(premisesGoals
                                .parallelStream()
                                .map(goal -> goal.getExtension().getGoal())
                                .collect(Collectors.toList()));
                proof.add(new Clause(conclusion, premises));
                premisesGoals
                        .parallelStream()
                        .forEach(premise -> createProof(premise, proof));
            }
        }
    }

    public static void listOpenGoals(IGoalExpression accu, List<IGoalExpression> openGoals) {
        IGoalExtension extension = accu.getExtension();
        if (!extension.isClosed()) {
            {
                Optional<IVariable<IGoalNonVariableExtension>> optVariableAccu
                        = accu.getBaseExpression().variable();
                if (optVariableAccu.isPresent()) {
                    IVariable<IGoalNonVariableExtension> var = optVariableAccu.get();
                    Optional<IBaseExpression<IGoalNonVariableExtension>> optValue
                            = var.value();
                    if (optValue.isPresent()) {
                        IGoalExpression newExpression = new GoalExpression(extension, optValue.get());
                        listOpenGoals(newExpression, openGoals);
                    } else {
                        openGoals.add(accu);
                    }
                }
            }

            {
                Optional<INonVariable<IGoalNonVariableExtension>> optNonVariableAccu
                        = accu.getBaseExpression().nonVariable();
                if (optNonVariableAccu.isPresent()) {
                    optNonVariableAccu.get().getNonVariableExtension().getSubGoals()
                            .parallelStream()
                            .forEach(goal -> listOpenGoals(goal, openGoals));
                }
            }
        }
    }

    public void undo(IGoalExpression goal) {
        goal.getExtension().undo();
        goal.getBaseExpression().variable().get().clear();
    }

}
