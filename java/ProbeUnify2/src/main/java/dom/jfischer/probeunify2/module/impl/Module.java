/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.module.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.ITrivialExtension;
import dom.jfischer.probeunify2.exception.QualificatorException;
import java.util.Map;
import java.util.Map.Entry;
import dom.jfischer.probeunify2.module.IModule;
import dom.jfischer.probeunify2.module.INamedClause;
import dom.jfischer.probeunify2.module.INamedLiteral;
import dom.jfischer.probeunify2.module.INamedTerm;
import dom.jfischer.probeunify2.pel.IOperationExpression;
import dom.jfischer.probeunify2.pel.IPredicateExpression;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.ConcurrentHashMap;

/**
 *
 * @author jfischer
 */
public class Module implements IModule {

    private final Map<String, INamedClause> axioms = new ConcurrentHashMap<>();
    private final Map<String, IModule> imps = new ConcurrentHashMap<>();
    private final Map<String, INamedLiteral> literals = new ConcurrentHashMap<>();
    private final Map<String, IOperationExpression> operations = new ConcurrentHashMap<>();
    private final Map<String, IPredicateExpression> predicates = new ConcurrentHashMap<>();
    private final Map<String, IBaseExpression<ITrivialExtension>> sorts = new ConcurrentHashMap<>();
    private final Map<String, INamedTerm> terms = new ConcurrentHashMap<>();

    @Override
    public Map<String, INamedClause> getAxioms() {
        return this.axioms;
    }

    @Override
    public Map<String, IModule> getImports() {
        return this.imps;
    }

    @Override
    public Map<String, INamedLiteral> getLiterals() {
        return this.literals;
    }

    @Override
    public Map<String, IOperationExpression> getOperations() {
        return this.operations;
    }

    @Override
    public Map<String, IPredicateExpression> getPredicates() {
        return this.predicates;
    }

    @Override
    public Map<String, IBaseExpression<ITrivialExtension>> getSorts() {
        return this.sorts;
    }

    @Override
    public Map<String, INamedTerm> getTerms() {
        return this.terms;
    }

    @Override
    public void commit() {
        for (Entry<String, INamedClause> axiom : this.axioms.entrySet()) {
            axiom.getValue().commit();
        }
        for (Entry<String, IModule> imp : this.imps.entrySet()) {
            imp.getValue().commit();
        }
        for (Entry<String, INamedLiteral> literal : this.literals.entrySet()) {
            literal.getValue().commit();
        }
        for (Entry<String, INamedTerm> term : this.terms.entrySet()) {
            term.getValue().commit();
        }
    }

    @Override
    public void reset() {
        for (Entry<String, INamedClause> axiom : this.axioms.entrySet()) {
            axiom.getValue().reset();
        }
        for (Entry<String, IModule> imp : this.imps.entrySet()) {
            imp.getValue().reset();
        }
        for (Entry<String, INamedLiteral> literal : this.literals.entrySet()) {
            literal.getValue().reset();
        }
        for (Entry<String, INamedTerm> term : this.terms.entrySet()) {
            term.getValue().reset();
        }
    }

    @Override
    public Optional<IModule> derefModule(List<String> qualificator) throws QualificatorException {
        IModule retval = this;
        for (String qual : qualificator) {
            Map<String, IModule> importsMap = retval.getImports();
            if (importsMap.containsKey(qual)) {
                retval = importsMap.get(qual);
            } else {
                throw new QualificatorException(qualificator);
            }
        }
        return Optional.ofNullable(retval);
    }

    @Override
    public String toString() {
        return "Module{" + "axioms=" + axioms + ", imps=" + imps + ", literals=" + literals + ", operations=" + operations + ", predicates=" + predicates + ", sorts=" + sorts + ", terms=" + terms + '}';
    }
    
}
