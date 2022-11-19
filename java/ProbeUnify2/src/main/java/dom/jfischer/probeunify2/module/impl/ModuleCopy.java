/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.module.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.ICopy;
import dom.jfischer.probeunify2.basic.ITrivialExtension;
import dom.jfischer.probeunify2.module.IModule;
import dom.jfischer.probeunify2.module.INamedClause;
import dom.jfischer.probeunify2.module.INamedLiteral;
import dom.jfischer.probeunify2.module.INamedTerm;
import dom.jfischer.probeunify2.pel.IOperationExpression;
import dom.jfischer.probeunify2.pel.IPELLeafCollector;
import dom.jfischer.probeunify2.pel.IPELTracker;
import dom.jfischer.probeunify2.pel.IPredicateExpression;
import java.util.Map;

/**
 *
 * @author jfischer
 */
public class ModuleCopy implements ICopy<IModule> {

    private final ICopy<INamedClause> namedClauseCopier = new NamedClauseCopy();
    private final ICopy<INamedLiteral> namedLiteralCopier = new NamedLiteralCopy();
    private final ICopy<INamedTerm> namedTermCopier = new NamedTermCopy();

    @Override
    public IModule copy(IPELTracker tracker, IModule object) {
        IModule retval = new Module();

        {
            Map<String, INamedClause> retAxioms = retval.getAxioms();
            for (Map.Entry<String, INamedClause> axiom : object.getAxioms().entrySet()) {
                retAxioms.put(axiom.getKey(), this.namedClauseCopier.copy(tracker, axiom.getValue()));
            }
        }
        {
            Map<String, IModule> retImports = retval.getImports();
            for (Map.Entry<String, IModule> imp : object.getImports().entrySet()) {
                retImports.put(imp.getKey(), this.copy(tracker, imp.getValue()));
            }
        }
        {
            Map<String, INamedLiteral> retLiterals = retval.getLiterals();
            for (Map.Entry<String, INamedLiteral> literal : object.getLiterals().entrySet()) {
                retLiterals.put(literal.getKey(), this.namedLiteralCopier.copy(tracker, literal.getValue()));
            }
        }
        {
            Map<String, IOperationExpression> retOperations = retval.getOperations();
            for (Map.Entry<String, IOperationExpression> operation : object.getOperations().entrySet()) {
                retOperations.put(operation.getKey(), operation.getValue());
            }
        }
        {
            Map<String, IPredicateExpression> retPredicates = retval.getPredicates();
            for (Map.Entry<String, IPredicateExpression> predicate : object.getPredicates().entrySet()) {
                retPredicates.put(predicate.getKey(), predicate.getValue());
            }
        }
        {
            Map<String, IBaseExpression<ITrivialExtension>> retSorts = retval.getSorts();
            for (Map.Entry<String, IBaseExpression<ITrivialExtension>> sort : object.getSorts().entrySet()) {
                retSorts.put(sort.getKey(), sort.getValue());
            }
        }
        {
            Map<String, INamedTerm> retTerms = retval.getTerms();
            for (Map.Entry<String, INamedTerm> term : object.getTerms().entrySet()) {
                retTerms.put(term.getKey(), this.namedTermCopier.copy(tracker, term.getValue()));
            }
        }

        return retval;
    }

    @Override
    public void collectLeafs(IPELLeafCollector leafCollector, IModule object) {
        {
            for (Map.Entry<String, INamedClause> axiom : object.getAxioms().entrySet()) {
                this.namedClauseCopier.collectLeafs(leafCollector, axiom.getValue());
            }
        }
        for (Map.Entry<String, IModule> imp : object.getImports().entrySet()) {
            this.collectLeafs(leafCollector, imp.getValue());
        }
        for (Map.Entry<String, INamedLiteral> literal : object.getLiterals().entrySet()) {
            this.namedLiteralCopier.collectLeafs(leafCollector, literal.getValue());
        }
        for (Map.Entry<String, INamedTerm> term : object.getTerms().entrySet()) {
            this.namedTermCopier.collectLeafs(leafCollector, term.getValue());
        }
    }

}
