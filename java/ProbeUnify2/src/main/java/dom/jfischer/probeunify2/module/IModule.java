/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify2.module;

import dom.jfischer.probeunify2.pel.INamedTerm;
import dom.jfischer.probeunify2.pel.INamedLiteral;
import dom.jfischer.probeunify2.pel.INamedClause;
import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.IExtension;
import dom.jfischer.probeunify2.basic.ITrivialExtension;
import dom.jfischer.probeunify2.exception.QualificatorException;
import dom.jfischer.probeunify2.pel.IOperationExpression;
import dom.jfischer.probeunify2.pel.IPredicateExpression;
import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 *
 * @author jfischer
 */
public interface IModule extends IExtension {

    Map<String, INamedClause> getAxioms();

    Map<String, IModule> getImports();

    Map<String, INamedLiteral> getLiterals();

    Map<String, IOperationExpression> getOperations();

    Map<String, IPredicateExpression> getPredicates();

    Map<String, IBaseExpression<ITrivialExtension>> getSorts();

    Map<String, INamedTerm> getTerms();

    Optional<IModule> derefModule(List<String> qualificator) throws QualificatorException;

}
