/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunifyfrontend1.antlr.impl;

import dom.jfischer.probeunify3.basic.ICheckVariableOccurence;
import dom.jfischer.probeunify3.basic.IClause;
import dom.jfischer.probeunify3.basic.ICopy;
import dom.jfischer.probeunify3.basic.ILeafCollecting;
import dom.jfischer.probeunify3.basic.INonVariableXt;
import dom.jfischer.probeunify3.basic.ITNonVariableXt;
import dom.jfischer.probeunify3.basic.ITracker;
import dom.jfischer.probeunify3.basic.IUnification;
import dom.jfischer.probeunify3.basic.IVariableContext;
import dom.jfischer.probeunify3.basic.IXpr;
import dom.jfischer.probeunify3.basic.impl.TNonVariableXtCopy;
import dom.jfischer.probeunify3.basic.impl.XprCheckVariableOccurence;
import dom.jfischer.probeunify3.basic.impl.XprUnification;
import dom.jfischer.probeunify3.module.IModule;
import dom.jfischer.probeunify3.module.IModuleTracker;
import dom.jfischer.probeunify3.module.impl.Module;
import dom.jfischer.probeunify3.module.impl.ModuleCopy;
import dom.jfischer.probeunify3.module.impl.ModuleUnification;
import dom.jfischer.probeunifyfrontend1.antlr.IPELThisVisitor;
import dom.jfischer.probeunifyfrontend1.names.IPELXt;
import dom.jfischer.probeunifyfrontend1.names.ITermVariableInfo;
import dom.jfischer.probeunifyfrontend1.names.IVariableInfo;
import dom.jfischer.probeunifyfrontend1.names.IVariableNameInfo;
import dom.jfischer.probeunifyfrontend1.names.impl.PELXt;
import dom.jfischer.probeunifyfrontend1.names.impl.PELXtCopy;
import dom.jfischer.probeunifyfrontend1.names.impl.PELXtUnification;
import dom.jfischer.probeunifyfrontend1.names.impl.TermVariableInfo;
import dom.jfischer.probeunifyfrontend1.names.impl.VariableInfo;
import dom.jfischer.probeunifyfrontend1.names.impl.VariableNameInfo;
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
public class AntlrHelper {

    private static IModule<IPELXt> MODULE;
    private static String MODULE_NAME;
    private static IVariableInfo VARIABLE_INFO;
    private static IVariableNameInfo VARIABLE_NAME_INFO;
    private static ITermVariableInfo TERM_VARIABLE_INFO;
    private static IVariableContext<ITNonVariableXt> VARIABLE_CONTEXT;
    private static ICheckVariableOccurence<ITNonVariableXt, ITNonVariableXt> NONVARIABLEXT_VARIABLE_OCCURENCE_CHECKER;
    private static ICopy<ITNonVariableXt, ITracker<IXpr<ITNonVariableXt>>> NONVARIABLEXT_COPY;
    private static ILeafCollecting<ITNonVariableXt, ITNonVariableXt> NONVARIABLEXT_LEAF_COLLECTING;
    private static IUnification<ITNonVariableXt> NONVARIABLEXT_UNIFICATION;
    private static ICopy<IXpr<ITNonVariableXt>, ITracker<IXpr<ITNonVariableXt>>> ITEM_COPIER;
    private static ICheckVariableOccurence<ITNonVariableXt, IXpr<ITNonVariableXt>> ITEM_VARIABLE_OCCURENCE_CHECKER;
    private static ICopy<IModule<IPELXt>, IModuleTracker<IPELXt>> MODULE_COPIER;
    private static IUnification<IXpr<ITNonVariableXt>> ITEM_UNIFICATION;
    private static IUnification<IPELXt> XT_UNIFICATION;
    private static IUnification<IModule<IPELXt>> MODULE_UNIFICATION;
    private static Map<String, IModule<IPELXt>> MODULE_REGISTER;
    private static PELThisVisitor PEL_VISITOR;

    public static void init(String moduleName) {
        IPELXt pelXt = new PELXt();
        MODULE = new Module<>(pelXt);
        MODULE_NAME = moduleName;
        VARIABLE_NAME_INFO = new VariableNameInfo();
        VARIABLE_INFO = new VariableInfo();
        TERM_VARIABLE_INFO =  new TermVariableInfo();

        TNonVariableXtCopy tNonVariableXtCopy
                = new TNonVariableXtCopy();
        NONVARIABLEXT_COPY = tNonVariableXtCopy;
        NONVARIABLEXT_VARIABLE_OCCURENCE_CHECKER
                = tNonVariableXtCopy.getBaseVariableOccurenceChecker();
        NONVARIABLEXT_LEAF_COLLECTING
                = tNonVariableXtCopy.getBaseLeafCollecting();
        NONVARIABLEXT_UNIFICATION
                = tNonVariableXtCopy.getBaseUnification();
        ITEM_COPIER
                = tNonVariableXtCopy.getBaseCopier();
        VARIABLE_CONTEXT
                = tNonVariableXtCopy.getVariableContext();
        ITEM_VARIABLE_OCCURENCE_CHECKER
                = new XprCheckVariableOccurence<>();
        ITEM_UNIFICATION
                = new XprUnification<>();
        ICopy<IPELXt, ITracker<IXpr<INonVariableXt>>> pelXtCopier
                =  new PELXtCopy();
        MODULE_COPIER
                =  new ModuleCopy<>(pelXtCopier);
        XT_UNIFICATION
                =  new PELXtUnification();
        MODULE_UNIFICATION
                =  new ModuleUnification<>(XT_UNIFICATION);
        MODULE_REGISTER
                =  new ConcurrentHashMap<>();
        PEL_VISITOR = new PELThisVisitor(
                MODULE,
                MODULE_NAME,
                VARIABLE_INFO,
                VARIABLE_NAME_INFO,
                TERM_VARIABLE_INFO,
                VARIABLE_CONTEXT,
                NONVARIABLEXT_VARIABLE_OCCURENCE_CHECKER,
                NONVARIABLEXT_COPY,
                NONVARIABLEXT_LEAF_COLLECTING,
                NONVARIABLEXT_UNIFICATION,
                ITEM_COPIER,
                ITEM_VARIABLE_OCCURENCE_CHECKER,
                MODULE_COPIER,
                ITEM_UNIFICATION,
                MODULE_UNIFICATION,
                MODULE_REGISTER
        );
    }

    public static String getRealProofFileName(String proofName) {
        return proofName + ".prf";
    }

    public static CharStream getLogicCharStream(String moduleName) throws IOException {
        return CharStreams.fromFileName(moduleName + ".pel");
    }

    public static CharStream getProofCharStream(String proofName) throws IOException {
        return CharStreams.fromFileName(getRealProofFileName(proofName));
    }

    public static void parseLogics(CharStream charStream, PELThisVisitor pelThisVisitor) {
        PelLexer pelLexer = new PelLexer(charStream);
        CommonTokenStream commonTokenStream = new CommonTokenStream(pelLexer);
        PelParser pelParser = new PelParser(commonTokenStream);
        PelParser.LogicContext logicContext
                = pelParser.logic();
        pelThisVisitor.visit(logicContext);
    }

    public static void parseLogics(CharStream charStream) {
        parseLogics(charStream, PEL_VISITOR);
    }
    
    public static Set<IClause> parseProof(
            CharStream charStream) {
        PelLexer pelLexer = new PelLexer(charStream);
        CommonTokenStream commonTokenStream = new CommonTokenStream(pelLexer);
        PelParser pelParser = new PelParser(commonTokenStream);
        PelParser.ProofContext proofContext = pelParser.proof();
        return (Set<IClause>) PEL_VISITOR.visit(proofContext);
    }

    public static IModule<IPELXt> getModule() {
        return MODULE;
    }
    
    public static String getModuleName() {
        return MODULE_NAME;
    }
    
    public static IPELThisVisitor getPELThisVisitor() {
        return PEL_VISITOR;
    }
    
    public static IVariableNameInfo getVariableNameInfo() {
        return VARIABLE_NAME_INFO;
    }
    
    public static ITermVariableInfo getTermVariableInfo() {
        return TERM_VARIABLE_INFO;
    }
    
    public static ICopy<IXpr<ITNonVariableXt>, ITracker<IXpr<ITNonVariableXt>>> getItemCopier() {
        return ITEM_COPIER;
    }
    
    public static IUnification<IXpr<ITNonVariableXt>> getItemUnification() {
        return ITEM_UNIFICATION;
    }
    
    public static IVariableContext<ITNonVariableXt> getVariableContext() {
        return VARIABLE_CONTEXT;
    }
    
    public static IClause getClause(
            String clauseString) {
        CharStream charStream = CharStreams.fromString(clauseString);
        PelLexer pelLexer = new PelLexer(charStream);
        CommonTokenStream commonTokenStream = new CommonTokenStream(pelLexer);
        PelParser pelParser = new PelParser(commonTokenStream);
        PelParser.ClauseContext clauseContext = pelParser.clause();
        clauseContext.variableContext = VARIABLE_CONTEXT;
        clauseContext.variableInfo = VARIABLE_INFO;
        return (IClause) PEL_VISITOR.visit(clauseContext);
    }

    public static IXpr<ITNonVariableXt> getLiteral(String literalString) {
        CharStream charStream = CharStreams.fromString(literalString);
        PelLexer pelLexer = new PelLexer(charStream);
        CommonTokenStream commonTokenStream = new CommonTokenStream(pelLexer);
        PelParser pelParser = new PelParser(commonTokenStream);
        PelParser.LiteralContext literalContext = pelParser.literal();
        literalContext.variableContext = VARIABLE_CONTEXT;
        literalContext.variableInfo = VARIABLE_INFO;
        return (IXpr<ITNonVariableXt>) PEL_VISITOR.visit(literalContext);
    }

    public static IXpr<ITNonVariableXt> getTerm(String termString) {
        CharStream charStream = CharStreams.fromString(termString);
        PelLexer pelLexer = new PelLexer(charStream);
        CommonTokenStream commonTokenStream = new CommonTokenStream(pelLexer);
        PelParser pelParser = new PelParser(commonTokenStream);
        PelParser.TermContext termContext = pelParser.term();
        termContext.variableContext = VARIABLE_CONTEXT;
        termContext.variableInfo = VARIABLE_INFO;
        return (IXpr<ITNonVariableXt>) PEL_VISITOR.visit(termContext);
    }

}
