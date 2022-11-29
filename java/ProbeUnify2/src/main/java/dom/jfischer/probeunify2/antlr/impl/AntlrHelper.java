/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.antlr.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.IVariable;
import dom.jfischer.probeunify2.pel.INamedClause;
import dom.jfischer.probeunify2.pel.INamedLiteral;
import dom.jfischer.probeunify2.pel.INamedTerm;
import dom.jfischer.probeunify2.pel.impl.NamedClause;
import dom.jfischer.probeunify2.pel.impl.NamedLiteral;
import dom.jfischer.probeunify2.pel.impl.NamedTerm;
import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;
import dom.jfischer.probeunify2.pel.IPELVariableContext;
import dom.jfischer.probeunify2.pel.ITermNonVariableExtension;
import dom.jfischer.probeunify2.pel.impl.PELVariableContext;
import dom.jfischer.probeunify2.proof.IClause;
import java.io.IOException;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;

/**
 *
 * @author jfischer
 */
@SuppressWarnings("unchecked")
public class AntlrHelper {

    public static String getRealProofFileName(String proofName) {
        return proofName + ".prf";
    }

    public static CharStream getLogicCharStream(String moduleName) throws IOException {
        return CharStreams.fromFileName(moduleName + ".pel");
    }

    public static CharStream getProofCharStream(String proofName) throws IOException {
        return CharStreams.fromFileName(getRealProofFileName(proofName));
    }

    public static void parseLogics(PelThisVisitor pelThisVisitor, CharStream charStream) {
        PelLexer pelLexer = new PelLexer(charStream);
        CommonTokenStream commonTokenStream = new CommonTokenStream(pelLexer);
        PelParser pelParser = new PelParser(commonTokenStream);
        PelParser.LogicContext logicContext
                = pelParser.logic();
        pelThisVisitor.visit(logicContext);
    }

    public static Set<IClause> parseProof(
            PelThisVisitor pelThisVisitor,
            CharStream charStream) {
        PelLexer pelLexer = new PelLexer(charStream);
        CommonTokenStream commonTokenStream = new CommonTokenStream(pelLexer);
        PelParser pelParser = new PelParser(commonTokenStream);
        PelParser.ProofContext proofContext = pelParser.proof();
        return (Set<IClause>) pelThisVisitor.visit(proofContext);
    }

    public static INamedClause getClause(
            PelThisVisitor pelThisVisitor,
            String clauseString) {
        CharStream charStream = CharStreams.fromString(clauseString);
        PelLexer pelLexer = new PelLexer(charStream);
        CommonTokenStream commonTokenStream = new CommonTokenStream(pelLexer);
        PelParser pelParser = new PelParser(commonTokenStream);
        PelParser.ClauseContext clauseContext = pelParser.clause();

        Map<String, IVariable<ILiteralNonVariableExtension>> literalBaseVars
                = new ConcurrentHashMap<>();
        Map<String, Map<Integer, IVariable<ILiteralNonVariableExtension>>> literalIndexedVars
                = new ConcurrentHashMap<>();
        Map<String, IVariable<ITermNonVariableExtension>> termBaseVars
                = new ConcurrentHashMap<>();
        Map<String, Map<Integer, IVariable<ITermNonVariableExtension>>> termIndexedVars
                = new ConcurrentHashMap<>();
        IPELVariableContext pelVariableContext = new PELVariableContext();
        clauseContext.pelVariableContext = pelVariableContext;
        clauseContext.literalBaseVars = literalBaseVars;
        clauseContext.literalIndexedVars = literalIndexedVars;
        clauseContext.termBaseVars = termBaseVars;
        clauseContext.termIndexedVars = termIndexedVars;
        IClause clause
                = (IClause) pelThisVisitor.visit(clauseContext);
        return clause == null ? null : new NamedClause(clause, pelVariableContext);
    }

    public static INamedLiteral getLiteral(PelThisVisitor pelThisVisitor, String literalString) {
        CharStream charStream = CharStreams.fromString(literalString);
        PelLexer pelLexer = new PelLexer(charStream);
        CommonTokenStream commonTokenStream = new CommonTokenStream(pelLexer);
        PelParser pelParser = new PelParser(commonTokenStream);
        PelParser.LiteralContext literalContext = pelParser.literal();
        Map<String, IVariable<ILiteralNonVariableExtension>> literalBaseVars
                = new ConcurrentHashMap<>();
        Map<String, Map<Integer, IVariable<ILiteralNonVariableExtension>>> literalIndexedVars
                = new ConcurrentHashMap<>();
        Map<String, IVariable<ITermNonVariableExtension>> termBaseVars
                = new ConcurrentHashMap<>();
        Map<String, Map<Integer, IVariable<ITermNonVariableExtension>>> termIndexedVars
                = new ConcurrentHashMap<>();
        IPELVariableContext pelVariableContext = new PELVariableContext();
        literalContext.pelVariableContext = pelVariableContext;
        literalContext.literalBaseVars = literalBaseVars;
        literalContext.literalIndexedVars = literalIndexedVars;
        literalContext.termBaseVars = termBaseVars;
        literalContext.termIndexedVars = termIndexedVars;
        IBaseExpression<ILiteralNonVariableExtension> literal
                = (IBaseExpression<ILiteralNonVariableExtension>) pelThisVisitor.visit(literalContext);
        return literal == null ? null : new NamedLiteral(literal, pelVariableContext);
    }

    public static INamedTerm getTerm(PelThisVisitor pelThisVisitor, String termString) {
        CharStream charStream = CharStreams.fromString(termString);
        PelLexer pelLexer = new PelLexer(charStream);
        CommonTokenStream commonTokenStream = new CommonTokenStream(pelLexer);
        PelParser pelParser = new PelParser(commonTokenStream);
        PelParser.TermContext termContext = pelParser.term();
        Map<String, IVariable<ITermNonVariableExtension>> termBaseVars
                = new ConcurrentHashMap<>();
        Map<String, Map<Integer, IVariable<ITermNonVariableExtension>>> termIndexedVars
                = new ConcurrentHashMap<>();
        IPELVariableContext pelVariableContext = new PELVariableContext();
        termContext.pelVariableContext = pelVariableContext;

        termContext.termBaseVars = termBaseVars;
        termContext.termIndexedVars = termIndexedVars;
        IBaseExpression<ITermNonVariableExtension> term
                = (IBaseExpression<ITermNonVariableExtension>) pelThisVisitor.visit(termContext);
        return term == null ? null : new NamedTerm(term, pelVariableContext.getTermVariableContext());
    }

}
