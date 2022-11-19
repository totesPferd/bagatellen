/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.antlr.impl;

import dom.jfischer.probeunify2.module.INamedClause;
import dom.jfischer.probeunify2.module.INamedLiteral;
import dom.jfischer.probeunify2.module.INamedTerm;
import java.io.IOException;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.tree.ParseTreeWalker;

/**
 *
 * @author jfischer
 */
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

    public static void parseLogic(PelThisListener pelThisListener, CharStream charStream) {
        PelLexer pelLexer = new PelLexer(charStream);
        CommonTokenStream commonTokenStream = new CommonTokenStream(pelLexer);
        PelParser pelParser = new PelParser(commonTokenStream);
        ParseTreeWalker parseTreeWalker = new ParseTreeWalker();
        parseTreeWalker.walk(pelThisListener, pelParser.logic());
    }

    public static void parseProof(PelThisListener pelThisListener, CharStream charStream) {
        PelLexer pelLexer = new PelLexer(charStream);
        CommonTokenStream commonTokenStream = new CommonTokenStream(pelLexer);
        PelParser pelParser = new PelParser(commonTokenStream);
        ParseTreeWalker parseTreeWalker = new ParseTreeWalker();
        parseTreeWalker.walk(pelThisListener, pelParser.proof());
    }

    public static INamedClause getClause(PelThisListener pelThisListener, String clauseString) {
        CharStream charStream = CharStreams.fromString(clauseString);
        PelLexer pelLexer = new PelLexer(charStream);
        CommonTokenStream commonTokenStream = new CommonTokenStream(pelLexer);
        PelParser pelParser = new PelParser(commonTokenStream);
        ParseTreeWalker parseTreeWalker = new ParseTreeWalker();
        parseTreeWalker.walk(pelThisListener, pelParser.clause());
        return pelThisListener.popClause();
    }

    public static INamedLiteral getLiteral(PelThisListener pelThisListener, String literalString) {
        CharStream charStream = CharStreams.fromString(literalString);
        PelLexer pelLexer = new PelLexer(charStream);
        CommonTokenStream commonTokenStream = new CommonTokenStream(pelLexer);
        PelParser pelParser = new PelParser(commonTokenStream);
        ParseTreeWalker parseTreeWalker = new ParseTreeWalker();
        parseTreeWalker.walk(pelThisListener, pelParser.literal());
        return pelThisListener.popLiteral();
    }

    public static INamedTerm getTerm(PelThisListener pelThisListener, String termString) {
        CharStream charStream = CharStreams.fromString(termString);
        PelLexer pelLexer = new PelLexer(charStream);
        CommonTokenStream commonTokenStream = new CommonTokenStream(pelLexer);
        PelParser pelParser = new PelParser(commonTokenStream);
        ParseTreeWalker parseTreeWalker = new ParseTreeWalker();
        parseTreeWalker.walk(pelThisListener, pelParser.term());
        return pelThisListener.popTerm();
    }

}
