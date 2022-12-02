/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.proof.impl;

import dom.jfischer.probeunify2.basic.IBaseCopy;
import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.ICheckVariableOccurence;
import dom.jfischer.probeunify2.basic.ICompare;
import dom.jfischer.probeunify2.basic.ICopy;
import dom.jfischer.probeunify2.basic.IExpression;
import dom.jfischer.probeunify2.basic.INonVariable;
import dom.jfischer.probeunify2.basic.IUnification;
import dom.jfischer.probeunify2.basic.IVariable;
import dom.jfischer.probeunify2.basic.impl.Compare;
import dom.jfischer.probeunify2.basic.impl.CopyBaseCopy;
import dom.jfischer.probeunify2.basic.impl.Expression;
import dom.jfischer.probeunify2.basic.impl.NonVariable;
import dom.jfischer.probeunify2.basic.impl.Unification;
import dom.jfischer.probeunify2.basic.impl.Variable;
import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;
import dom.jfischer.probeunify2.pel.INamedClause;
import dom.jfischer.probeunify2.proof.IClause;
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

    public static IExpression<IGoalExtension, IGoalNonVariableExtension> createGoal(IBaseExpression<ILiteralNonVariableExtension> arg) {
        IGoalExtension extension = new GoalExtension(arg);
        IVariable<IGoalNonVariableExtension> baseExpression
                = new Variable<>();
        return new Expression<>(extension, baseExpression);
    }

    public static boolean resolve(
            ICopy<IBaseExpression<ILiteralNonVariableExtension>> copier,
            IUnification<IBaseExpression<ILiteralNonVariableExtension>> goalUnification,
            IExpression<IGoalExtension, IGoalNonVariableExtension> accu,
            IClause clause) {
        IBaseExpression<ILiteralNonVariableExtension> conclusion = clause.getConclusion();
        IGoalExtension goalExtension
                = new GoalExtension(conclusion);
        List<IBaseExpression<ILiteralNonVariableExtension>> premises
                = clause.getPremises();
        List<IExpression<IGoalExtension, IGoalNonVariableExtension>> premiseGoals
                = Collections.synchronizedList(premises
                        .parallelStream()
                        .map(ProofHelper::createGoal)
                        .collect(Collectors.toList()));
        IGoalNonVariableExtension goalNonVariableExtension
                = new GoalNonVariableExtension(premiseGoals);

        IBaseCopy<IGoalNonVariableExtension, IBaseExpression<ILiteralNonVariableExtension>> literalBaseCopy
                = new CopyBaseCopy<>(copier);
        IBaseCopy<IGoalNonVariableExtension, IGoalExtension> goalExtensionBaseCopy
                = new GoalExtensionBaseCopy(literalBaseCopy);
        IBaseCopy<IGoalNonVariableExtension, IExpression<IGoalExtension, IGoalNonVariableExtension>> goalExpressionBaseCopy
                = new GoalExpressionBaseCopy(goalExtensionBaseCopy);
        IBaseCopy<IGoalNonVariableExtension, IGoalNonVariableExtension> goalNonVariableExtensionBaseCopy
                = new GoalNonVariableExtensionBaseCopy(goalExpressionBaseCopy);
        ICheckVariableOccurence<IGoalNonVariableExtension> goalNonVariableExtensionVariableOccurenceChecker
                = new GoalNonVariableExtensionVariableOccurenceChecker();
        IUnification<IGoalNonVariableExtension> goalNonVariableExtensionUnification
                = new GoalNonVariableExtensionUnification(goalUnification);
        IBaseExpression<IGoalNonVariableExtension> goalNonVariableExpression
                = new NonVariable<>(
                        goalNonVariableExtension,
                        goalNonVariableExtensionVariableOccurenceChecker,
                        goalNonVariableExtensionBaseCopy,
                        goalNonVariableExtensionUnification);
        IExpression<IGoalExtension, IGoalNonVariableExtension> goalExpression
                = new Expression<>(goalExtension, goalNonVariableExpression);
        IUnification<IGoalExtension> goalExtensionUnification
                = new GoalExtensionUnification(goalUnification);
        IUnification<IExpression<IGoalExtension, IGoalNonVariableExtension>> unification
                = new Unification<>(goalExtensionUnification);
        boolean retval = unification.unify(accu, goalExpression);
        if (retval) {
            accu.commit();
        }

        return retval;
    }

    public static void applyProof(
            ICopy<IBaseExpression<ILiteralNonVariableExtension>> copier,
            IUnification<IBaseExpression<ILiteralNonVariableExtension>> unification,
            IExpression<IGoalExtension, IGoalNonVariableExtension> accu,
            Set<INamedClause> proof) {
        if (!proof.isEmpty()) {
            ICompare<INamedClause> clauseComparer
                    = new Compare<>(copier, unification);
            List<IExpression<IGoalExtension, IGoalNonVariableExtension>> openGoals
                    = Collections.synchronizedList(new ArrayList<>());
            listOpenGoals(accu, openGoals);
            for (IExpression<IGoalExtension, IGoalNonVariableExtension> openGoal : openGoals) {
                Set<INamedClause> candidates = clauseComparer.getMaximalSet(
                        u -> u.getClause().getConclusion(),
                        proof,
                        openGoal.getExtension().getGoal());
                if (candidates.size() == 1) {
                    for (INamedClause candidate : candidates) {
                        if (resolve(copier, unification, openGoal, candidate.getClause())) {
                            openGoal.commit();
                            Set<INamedClause> proofCopy = Collections.synchronizedSet(
                                    proof
                                            .parallelStream()
                                            .filter(c -> c != candidate)
                                            .collect(Collectors.toSet()));
                            applyProof(copier, unification, openGoal, proofCopy);
                        }
                    }
                }
            }
        }
    }

    public static void createProof(IExpression<IGoalExtension, IGoalNonVariableExtension> accu, Set<IClause> proof) {
        IBaseExpression<IGoalNonVariableExtension> nextGoal = accu.getBaseExpression().dereference();
        {
            Optional<INonVariable<IGoalNonVariableExtension>> optNonVariableAccu
                    = nextGoal.nonVariable();
            if (optNonVariableAccu.isPresent()) {
                IBaseExpression<ILiteralNonVariableExtension> conclusion
                        = accu.getExtension().getGoal();
                List<IExpression<IGoalExtension, IGoalNonVariableExtension>> premisesGoals
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

    public static void listOpenGoals(IExpression<IGoalExtension, IGoalNonVariableExtension> accu, List<IExpression<IGoalExtension, IGoalNonVariableExtension>> openGoals) {
        IGoalExtension extension = accu.getExtension();
        if (!extension.isClosed()) {
            IBaseExpression<IGoalNonVariableExtension> accuDereferencedBaseExpression
                    = accu.getBaseExpression().dereference();
            {
                Optional<IVariable<IGoalNonVariableExtension>> optVariableAccu
                        = accuDereferencedBaseExpression.variable();
                if (optVariableAccu.isPresent()) {
                    openGoals.add(accu);
                }
            }

            {
                Optional<INonVariable<IGoalNonVariableExtension>> optNonVariableAccu
                        = accuDereferencedBaseExpression.nonVariable();
                if (optNonVariableAccu.isPresent()) {
                    optNonVariableAccu.get().getNonVariableExtension().getSubGoals()
                            .parallelStream()
                            .forEach(goal -> listOpenGoals(goal, openGoals));
                }
            }
        }
    }

    public void undo(IExpression<IGoalExtension, IGoalNonVariableExtension> goal) {
        goal.getExtension().undo();
        goal.getBaseExpression().variable().get().clear();
    }

}
