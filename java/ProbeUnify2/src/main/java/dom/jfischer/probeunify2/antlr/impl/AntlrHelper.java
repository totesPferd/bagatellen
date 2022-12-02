/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.antlr.impl;

import dom.jfischer.probeunify2.pel.INamedClause;
import dom.jfischer.probeunify2.pel.INamedLiteral;
import dom.jfischer.probeunify2.pel.INamedTerm;
import dom.jfischer.probeunify2.proof.IClause;
import java.io.IOException;
import java.util.Set;
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

    public static Set<INamedClause> parseProof(
            PelThisVisitor pelThisVisitor,
            CharStream charStream) {
        PelLexer pelLexer = new PelLexer(charStream);
        CommonTokenStream commonTokenStream = new CommonTokenStream(pelLexer);
        PelParser pelParser = new PelParser(commonTokenStream);
        PelParser.ProofContext proofContext = pelParser.proof();
        return (Set<INamedClause>) pelThisVisitor.visit(proofContext);
    }

    public static INamedClause getClause(
            PelThisVisitor pelThisVisitor,
            String clauseString) {
        CharStream charStream = CharStreams.fromString(clauseString);
        PelLexer pelLexer = new PelLexer(charStream);
        CommonTokenStream commonTokenStream = new CommonTokenStream(pelLexer);
        PelParser pelParser = new PelParser(commonTokenStream);
        PelParser.ClauseContext clauseContext = pelParser.clause();
        clauseContext.pelVariableContext = pelThisVisitor.getModule().getInitialCtxBean().getPelVariableContext();
        clauseContext.literalVariableInfo = pelThisVisitor.getModule().getInitialCtxBean().getLiteralVariableInfo();
        return (INamedClause) pelThisVisitor.visit(clauseContext);
    }

    public static INamedLiteral getLiteral(PelThisVisitor pelThisVisitor, String literalString) {
        CharStream charStream = CharStreams.fromString(literalString);
        PelLexer pelLexer = new PelLexer(charStream);
        CommonTokenStream commonTokenStream = new CommonTokenStream(pelLexer);
        PelParser pelParser = new PelParser(commonTokenStream);
        PelParser.LiteralContext literalContext = pelParser.literal();
        literalContext.pelVariableContext = pelThisVisitor.getModule().getInitialCtxBean().getPelVariableContext();
        literalContext.literalVariableInfo = pelThisVisitor.getModule().getInitialCtxBean().getLiteralVariableInfo();
        return (INamedLiteral) pelThisVisitor.visit(literalContext);
    }

    public static INamedTerm getTerm(PelThisVisitor pelThisVisitor, String termString) {
        CharStream charStream = CharStreams.fromString(termString);
        PelLexer pelLexer = new PelLexer(charStream);
        CommonTokenStream commonTokenStream = new CommonTokenStream(pelLexer);
        PelParser pelParser = new PelParser(commonTokenStream);
        PelParser.TermContext termContext = pelParser.term();
        termContext.termVariableContext = pelThisVisitor.getModule().getInitialCtxBean().getPelVariableContext().getTermVariableContext();
        termContext.termVariableInfo = pelThisVisitor.getModule().getInitialCtxBean().getLiteralVariableInfo().getTermVariableInfo();
        return (INamedTerm) pelThisVisitor.visit(termContext);
    }

}
