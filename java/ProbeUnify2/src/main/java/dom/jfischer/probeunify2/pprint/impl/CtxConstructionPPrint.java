/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pprint.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.ITrivialExtension;
import dom.jfischer.probeunify2.basic.IVariable;
import dom.jfischer.probeunify2.basic.IVariableContext;
import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;
import dom.jfischer.probeunify2.pel.IPELVariableContext;
import dom.jfischer.probeunify2.pel.ITermNonVariableExtension;
import dom.jfischer.probeunify2.pprint.IConstructionPPrint;
import dom.jfischer.probeunify2.pprint.IPPrintBase;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 *
 * @author jfischer
 */
public class CtxConstructionPPrint implements IConstructionPPrint {

    private final IPELVariableContext pelVariableContext;

    public CtxConstructionPPrint(IPELVariableContext pelVariableContext) {
        this.pelVariableContext = pelVariableContext;
    }

    @Override
    public String getSingleLine() {
        return "{ " + String.join(" ", this.getItems()) + " }";
    }

    @Override
    public void pprintMultiLine(IPPrintBase pprintBase) {
        pprintBase.printOpeningParenthesis("{");
        this.getItems().forEach(item -> pprintBase.printToken(item));
        pprintBase.printClosingParenthesis("}");
    }

    private List<String> getItems() {
        return Stream.concat(
                this.pelVariableContext.getLiteralVariableContext().getExtensionMap().keySet()
                        .parallelStream()
                        .filter(v -> v.value().isEmpty())
                        .map(this::getLiteralVariableString),
                this.pelVariableContext.getTermVariableContext().getExtensionMap().keySet()
                        .parallelStream()
                        .filter(v -> v.value().isEmpty())
                        .map(this::getTermVariableString)
        ).collect(Collectors.toList());
    }

    private String getLiteralVariableString(IVariable<ILiteralNonVariableExtension> variable) {
        IVariableContext<ITrivialExtension, ILiteralNonVariableExtension> literalVariableContext
                = this.pelVariableContext.getLiteralVariableContext();
        return "??" + literalVariableContext.getName(variable);
    }

    private String getTermVariableString(IVariable<ITermNonVariableExtension> variable) {
        IVariableContext<IBaseExpression<ITrivialExtension>, ITermNonVariableExtension> termVariableContext
                = this.pelVariableContext.getTermVariableContext();
        return "?" + termVariableContext.getName(variable);
    }

}
