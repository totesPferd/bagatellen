/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.module.impl;

import dom.jfischer.probeunify2.pel.impl.NamedTermUnification;
import dom.jfischer.probeunify2.pel.impl.NamedLiteralUnification;
import dom.jfischer.probeunify2.pel.impl.NamedClauseUnification;
import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.ITrivialExtension;
import dom.jfischer.probeunify2.basic.IUnification;
import dom.jfischer.probeunify2.basic.impl.BaseUnification;
import dom.jfischer.probeunify2.basic.impl.DictUnification;
import java.util.Map;
import dom.jfischer.probeunify2.module.IModule;
import dom.jfischer.probeunify2.pel.INamedClause;
import dom.jfischer.probeunify2.pel.INamedLiteral;
import dom.jfischer.probeunify2.pel.INamedTerm;
import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;
import dom.jfischer.probeunify2.pel.IOperationExpression;
import dom.jfischer.probeunify2.pel.IPredicateExpression;
import dom.jfischer.probeunify2.pel.impl.OperationExpressionUnification;
import dom.jfischer.probeunify2.pel.impl.PredicateExpressionUnification;

/**
 *
 * @author jfischer
 */
public class ModuleUnification implements IUnification<IModule> {

    private final IUnification<Map<String, INamedClause>> axiomsUnification;
    private final IUnification<Map<String, IModule>> importsUnification;
    private final IUnification<Map<String, INamedLiteral>> literalsUnification;
    private final IUnification<Map<String, IOperationExpression>> operationsUnification;
    private final IUnification<Map<String, IPredicateExpression>> predicatesUnification;
    private final IUnification<Map<String, IBaseExpression<ITrivialExtension>>> sortsUnification;
    private final IUnification<Map<String, INamedTerm>> termsUnification;

    public ModuleUnification() {
        {
            IUnification<IBaseExpression<ILiteralNonVariableExtension>> goalUnification
                    = new BaseUnification<>();
            IUnification<INamedClause> axiomUnification
                    = new NamedClauseUnification(goalUnification);
            this.axiomsUnification = new DictUnification<>(axiomUnification);
        }
        this.importsUnification = new DictUnification<>(this);
        {
            IUnification<INamedLiteral> literalUnification
                    = new NamedLiteralUnification();
            this.literalsUnification = new DictUnification<>(literalUnification);
        }
        {
            IUnification<IOperationExpression> operationUnification
                    = new OperationExpressionUnification();
            this.operationsUnification = new DictUnification<>(operationUnification);
        }
        {
            IUnification<IPredicateExpression> predicateUnification
                    = new PredicateExpressionUnification();
            this.predicatesUnification = new DictUnification<>(predicateUnification);
        }
        {
            IUnification<IBaseExpression<ITrivialExtension>> sortUnification
                    = new BaseUnification<>();
            this.sortsUnification = new DictUnification<>(sortUnification);
        }
        {
            IUnification<INamedTerm> termUnification
                    = new NamedTermUnification();
            this.termsUnification = new DictUnification<>(termUnification);
        }
    }

    @Override
    public boolean unify(IModule arg1, IModule arg2) {
        return this.importsUnification.unify(arg1.getImports(), arg2.getImports())
                && this.sortsUnification.unify(arg1.getSorts(), arg2.getSorts())
                && this.predicatesUnification.unify(arg1.getPredicates(), arg2.getPredicates())
                && this.operationsUnification.unify(arg1.getOperations(), arg2.getOperations())
                && this.axiomsUnification.unify(arg1.getAxioms(), arg2.getAxioms());
    }

}
