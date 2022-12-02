/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.antlr.impl;

import dom.jfischer.probeunify2.antlr.IPelThisVisitor;
import dom.jfischer.probeunify2.basic.IBaseCopy;
import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.ICheckVariableOccurence;
import dom.jfischer.probeunify2.basic.ICopy;
import dom.jfischer.probeunify2.basic.INonVariable;
import dom.jfischer.probeunify2.basic.ITrivialExtension;
import dom.jfischer.probeunify2.basic.IUnification;
import dom.jfischer.probeunify2.basic.IVariable;
import dom.jfischer.probeunify2.basic.IVariableContext;
import dom.jfischer.probeunify2.basic.impl.CopyBaseCopy;
import dom.jfischer.probeunify2.basic.impl.NonVariable;
import dom.jfischer.probeunify2.basic.impl.TrivialVariableOccurenceChecker;
import dom.jfischer.probeunify2.basic.impl.Variable;
import dom.jfischer.probeunify2.exception.QualificatorException;
import dom.jfischer.probeunify2.module.IModule;
import dom.jfischer.probeunify2.pel.INamedClause;
import dom.jfischer.probeunify2.pel.INamedLiteral;
import dom.jfischer.probeunify2.pel.INamedTerm;
import dom.jfischer.probeunify2.module.impl.Module;
import dom.jfischer.probeunify2.module.impl.ModuleHelper;
import dom.jfischer.probeunify2.module.impl.ModuleUnification;
import dom.jfischer.probeunify2.pel.impl.NamedClause;
import dom.jfischer.probeunify2.pel.impl.NamedTerm;
import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;
import dom.jfischer.probeunify2.pel.IOperation;
import dom.jfischer.probeunify2.pel.IOperationExpression;
import dom.jfischer.probeunify2.pel.IPELVariableContext;
import dom.jfischer.probeunify2.pel.IPredicate;
import dom.jfischer.probeunify2.pel.IPredicateExpression;
import dom.jfischer.probeunify2.pel.ITermNonVariableExtension;
import dom.jfischer.probeunify2.pel.impl.LiteralNonVariableExtension;
import dom.jfischer.probeunify2.pel.impl.LiteralNonVariableExtensionCopy;
import dom.jfischer.probeunify2.pel.impl.LiteralNonVariableExtensionUnification;
import dom.jfischer.probeunify2.pel.impl.NamedLiteral;
import dom.jfischer.probeunify2.pel.impl.Operation;
import dom.jfischer.probeunify2.pel.impl.OperationExpression;
import dom.jfischer.probeunify2.pel.impl.PELVariableContext;
import dom.jfischer.probeunify2.pel.impl.Predicate;
import dom.jfischer.probeunify2.pel.impl.PredicateExpression;
import dom.jfischer.probeunify2.pel.impl.TermNonVariableExtension;
import dom.jfischer.probeunify2.pel.impl.TermNonVariableExtensionCopy;
import dom.jfischer.probeunify2.pel.impl.TermNonVariableExtensionUnification;
import dom.jfischer.probeunify2.pel.impl.TermNonVariableExtensionVariableOccurenceChecker;
import dom.jfischer.probeunify2.pprint.IBackReference;
import dom.jfischer.probeunify2.pprint.IConstructionPPrint;
import dom.jfischer.probeunify2.pprint.IPPrintBase;
import dom.jfischer.probeunify2.pprint.IPPrintConfig;
import dom.jfischer.probeunify2.pprint.impl.BackReference;
import dom.jfischer.probeunify2.pprint.impl.PPrintBase;
import dom.jfischer.probeunify2.pprint.impl.PPrintConfig;
import dom.jfischer.probeunify2.pprint.impl.TermConstructionPPrint;
import dom.jfischer.probeunify2.proof.IClause;
import dom.jfischer.probeunify2.proof.impl.Clause;
import java.io.IOException;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.Token;

/**
 *
 * @author jfischer
 */
@SuppressWarnings("unchecked")
public class PelThisVisitor extends PelBaseVisitor<Object> implements IPelThisVisitor {

    private final IUnification<IModule> moduleUnification
            = new ModuleUnification();

    private final IBaseCopy<ILiteralNonVariableExtension, ILiteralNonVariableExtension> literalNonVariableExtensionBaseCopy;
    private final IBaseCopy<ITermNonVariableExtension, ITermNonVariableExtension> termNonVariableExtensionBaseCopy;
    private final ICheckVariableOccurence<ILiteralNonVariableExtension> literalNonVariableExtensionVariableOccurenceChecker
            = new TrivialVariableOccurenceChecker<>();
    private final ICheckVariableOccurence<ITermNonVariableExtension> termNonVariableExtensionVariableOccurenceChecker
            = new TermNonVariableExtensionVariableOccurenceChecker();
    private final IUnification<ILiteralNonVariableExtension> literalNonVariableExtensionUnification
            = new LiteralNonVariableExtensionUnification();
    private final IUnification<ITermNonVariableExtension> termNonVariableExtensionUnification
            = new TermNonVariableExtensionUnification();

    private final IModule module;
    private final String moduleName;
    private final Pattern literalBaseVarPattern;
    private final Pattern literalIndexedVarPattern;
    private final Pattern termBaseVarPattern;
    private final Pattern termIndexedVarPattern;

    private final IPPrintBase pprintBase;

    public PelThisVisitor(IModule module, String moduleName) {
        this.moduleName = moduleName;
        this.module = module;

        this.literalBaseVarPattern = Pattern.compile("^\\?\\?(__|[A-Za-z_][A-Za-z0-9]*)$");
        this.literalIndexedVarPattern = Pattern.compile("^\\?\\?(__|[A-Za-z_][A-Za-z0-9]*)_([0-9]+)$");
        this.termBaseVarPattern = Pattern.compile("^\\?(__|[A-Za-z_][A-Za-z0-9]*)$");
        this.termIndexedVarPattern = Pattern.compile("^\\?(__|[A-Za-z_][A-Za-z0-9]*)_([0-9]+)$");

        IPPrintConfig pprintConfig = new PPrintConfig();
        this.pprintBase = new PPrintBase(System.err, pprintConfig, 0);

        {
            ICopy<ITermNonVariableExtension> termNonVariableExtensionCopy
                    = new TermNonVariableExtensionCopy();
            this.termNonVariableExtensionBaseCopy
                    = new CopyBaseCopy<>(termNonVariableExtensionCopy);
        }
        {
            ICopy<ILiteralNonVariableExtension> literalNonVariableExtensionCopy
                    = new LiteralNonVariableExtensionCopy();
            this.literalNonVariableExtensionBaseCopy
                    = new CopyBaseCopy<>(literalNonVariableExtensionCopy);
        }
    }

    @Override
    public IModule getModule() {
        return this.module;
    }

    @Override
    public Object visitProof(PelParser.ProofContext ctx) {
        List<PelParser.ClauseContext> clausesContext = ctx.clauses;
        clausesContext
                .parallelStream()
                .forEach(clause -> clause.pelVariableContext = this.module.getInitialCtxBean().getPelVariableContext());
        clausesContext
                .parallelStream()
                .forEach(clause -> clause.literalVariableInfo = this.module.getInitialCtxBean().getLiteralVariableInfo());
        Set<INamedClause> proof = clausesContext
                .stream()
                .map(clause -> this.visit(clause))
                .map(obj -> (INamedClause) obj)
                .collect(Collectors.toSet());
        return (Object) proof;
    }

    @Override
    public Object visitModule_decl(PelParser.Module_declContext ctx) {
        Token symbol = ctx.SymbolToken(0).getSymbol();
        Token baseModuleSymbol = ctx.SymbolToken(1).getSymbol();
        String symbolText = symbol.getText();
        String baseModuleSymbolText = baseModuleSymbol.getText();
        ITrivialExtension trivialExtension = this.module.getTrivialExtension();
        IModule baseModule = new Module(trivialExtension);
        try {
            CharStream baseModuleCharStream
                    = AntlrHelper.getLogicCharStream(baseModuleSymbolText);
            PelThisVisitor baseModuleVisitor
                    = new PelThisVisitor(baseModule, baseModuleSymbolText);
            AntlrHelper.parseLogics(baseModuleVisitor, baseModuleCharStream);
        } catch (IOException ex) {
            this.printErr_LeadingLine_Region(ctx.start, ctx.stop, "no module " + baseModuleSymbolText + " found.");
        }

        {
            Map<String, IModule> imports = this.module.getImports();
            imports.put(symbolText, baseModule);
        }

        return null;
    }

    @Override
    public Object visitModule_eq(PelParser.Module_eqContext ctx) {
        List<PelParser.SymbolContext> symbolContexts = ctx.symbol();
        List<IModule> modules = symbolContexts
                .stream()
                .map(symbol -> this.visit(symbol))
                .map(outData -> (IModule) ((Object[]) outData)[0])
                .collect(Collectors.toList());
        IModule refModule = modules.get(0);
        for (int i = 1; i < modules.size(); i++) {
            if (!this.moduleUnification.unify(refModule, modules.get(i))) {
                for (int j = 0; j < i; j++) {
                    modules.get(j).reset();
                }
                printErr_LeadingLine_Region(ctx.args.get(0).SymbolToken, ctx.args.get(i).SymbolToken, " not unifyable.");
                break;
            }
        }
        modules
                .stream()
                .forEach(m -> m.commit());
        return null;
    }

    @Override
    public Object visitSort_decl(PelParser.Sort_declContext ctx) {
        Token sortToken = ctx.SymbolToken().getSymbol();
        String sortText = sortToken.getText();
        Map<String, IBaseExpression<ITrivialExtension>> sortsMap = this.module.getSorts();
        if (sortsMap.containsKey(sortText)) {
            printErr_LeadingLine_SingleToken(sortToken, "sort " + sortText + " already declared.");
        } else {
            IVariable<ITrivialExtension> sortExpression = new Variable<>();
            sortsMap.put(sortText, sortExpression);
        }
        return null;
    }

    @Override
    public Object visitPredicate_decl(PelParser.Predicate_declContext ctx) {
        Token predicateToken = ctx.SymbolToken().getSymbol();
        String predicateText = predicateToken.getText();
        Map<String, IPredicateExpression> predicatesMap
                = this.module.getPredicates();
        if (predicatesMap.containsKey(predicateText)) {
            printErr_LeadingLine_SingleToken(predicateToken, "predicate " + predicateText + " already declared.");
        } else {
            List<IBaseExpression<ITrivialExtension>> domain = ctx.args
                    .stream()
                    .map(symbol -> this.derefSort(symbol))
                    .collect(Collectors.toList());
            IPredicate predicate = new Predicate(domain);
            IBaseExpression<ITrivialExtension> baseExpression = new Variable<>();
            IPredicateExpression predicateExpression = new PredicateExpression(predicate, baseExpression);
            predicatesMap.put(predicateText, predicateExpression);
        }
        return null;
    }

    @Override
    public Object visitOperation_decl(PelParser.Operation_declContext ctx) {
        Token operationToken = ctx.SymbolToken().getSymbol();
        String operationText = operationToken.getText();
        Map<String, IOperationExpression> operationsMap
                = this.module.getOperations();
        if (operationsMap.containsKey(operationText)) {
            printErr_LeadingLine_SingleToken(operationToken, "operation " + operationText + " already declared.");
        } else {
            List<IBaseExpression<ITrivialExtension>> domain = ctx.lhs
                    .stream()
                    .map(symbol -> this.derefSort(symbol))
                    .collect(Collectors.toList());
            IBaseExpression<ITrivialExtension> range = this.derefSort(ctx.rhs);
            IOperation operation = new Operation(range, domain);
            IBaseExpression<ITrivialExtension> baseExpression = new Variable<>();
            IOperationExpression operationExpression = new OperationExpression(operation, baseExpression);
            operationsMap.put(operationText, operationExpression);
        }
        return null;
    }

    @Override
    public Object visitAxiom_decl(PelParser.Axiom_declContext ctx) {
        Token axiomToken = ctx.SymbolToken().getSymbol();
        String axiomText = axiomToken.getText();
        Map<String, INamedClause> axiomsMap
                = this.module.getAxioms();
        PelParser.ClauseContext clauseContext = ctx.clause();
        clauseContext.pelVariableContext = this.module.getInitialCtxBean().getPelVariableContext();
        clauseContext.literalVariableInfo = this.module.getInitialCtxBean().getLiteralVariableInfo();
        INamedClause namedClause
                = (INamedClause) this.visit(clauseContext);
        if (axiomsMap.containsKey(axiomText)) {
            printErr_LeadingLine_SingleToken(axiomToken, "axiom " + axiomText + " already declared.");
        } else if (namedClause != null) {
            axiomsMap.put(axiomText, namedClause);
        }
        return null;
    }

    @Override
    public Object visitLiteralVariable(PelParser.LiteralVariableContext ctx) {
        PelParser.Literal_variableContext variableContext = ctx.literal_variable();
        variableContext.pelVariableContext = ctx.pelVariableContext;
        variableContext.literalVariableInfo = ctx.literalVariableInfo;
        return visitChildren(ctx);
    }

    @Override
    public Object visitTermVariable(PelParser.TermVariableContext ctx) {
        PelParser.Term_variableContext variableContext = ctx.term_variable();
        variableContext.expectedSort = ctx.expectedSort;
        variableContext.termVariableContext = ctx.termVariableContext;
        variableContext.termVariableInfo = ctx.termVariableInfo;
        return visitChildren(ctx);
    }

    @Override
    public Object visitTermExpression(PelParser.TermExpressionContext ctx) {
        PelParser.SymbolContext operationSymbol = ctx.symbol();
        IOperationExpression operation
                = this.derefOperation(operationSymbol);

        INonVariable<ITermNonVariableExtension> nonVariableTerm = null;

        if (operation != null) {
            List<IBaseExpression<ITrivialExtension>> domain
                    = operation.getExtension().getDomain();
            if (domain.size() == ctx.args.size()) {
                ctx.args
                        .parallelStream()
                        .forEach(arg -> arg.termVariableContext = ctx.termVariableContext);
                ctx.args
                        .parallelStream()
                        .forEach(arg -> arg.termVariableInfo = ctx.termVariableInfo);
                for (int i = 0; i < domain.size(); i++) {
                    ctx.args.get(i).expectedSort = domain.get(i);
                }
                List<IBaseExpression<ITermNonVariableExtension>> arguments
                        = ctx.args
                                .stream()
                                .map(arg -> this.visit(arg))
                                .map(obj -> (INamedTerm) obj)
                                .map(namedTerm -> namedTerm.getTerm())
                                .collect(Collectors.toList());
                boolean argumentsOK = arguments
                        .parallelStream()
                        .allMatch(argument -> argument != null);
                if (argumentsOK) {
                    ITermNonVariableExtension nonVariableExtension = new TermNonVariableExtension(
                            operation,
                            arguments
                    );
                    nonVariableTerm = new NonVariable<>(
                            nonVariableExtension,
                            this.termNonVariableExtensionVariableOccurenceChecker,
                            this.termNonVariableExtensionBaseCopy,
                            this.termNonVariableExtensionUnification);
                }
            } else {
                IBackReference bref = new BackReference();
                ModuleHelper.getBackReference(this.module, bref, null);
                Map<IOperationExpression, String> operationRef = bref.getOperationRef();
                String operationName = operationRef.get(operation);
                this.printErr_LeadingLine_Region(ctx.start, ctx.stop, "" + domain.size() + " args expected for " + operationName + ".  " + ctx.args.size() + " found.");
            }

            if (ctx.expectedSort != null) {
                IBaseExpression<ITrivialExtension> realSort
                        = operation.getExtension().getRange();
                if (!realSort.eq(ctx.expectedSort)) {
                    IBackReference bref = new BackReference();
                    ModuleHelper.getBackReference(this.module, bref, null);
                    Map<IBaseExpression<ITrivialExtension>, String> sortRef = bref.getSortRef();
                    String realSortRef = sortRef.get(realSort);
                    String expectedSortRef = sortRef.get(ctx.expectedSort);
                    this.printErr_LeadingLine_Region(ctx.start, ctx.stop, "following has wrong type (" + realSortRef + "); expected: (" + expectedSortRef + ")");
                    INamedTerm namedTerm = new NamedTerm(nonVariableTerm, ctx.termVariableContext);
                    IConstructionPPrint termConstructionPPrint = new TermConstructionPPrint(bref, namedTerm);
                    termConstructionPPrint.pprint(this.pprintBase);
                    this.pprintBase.printNewLine();
                }
            }
        }
        INamedTerm namedTerm
                = nonVariableTerm == null
                        ? null
                        : new NamedTerm(nonVariableTerm, ctx.termVariableContext);
        return (Object) namedTerm;
    }

    @Override
    public Object visitLiteralExpression(PelParser.LiteralExpressionContext ctx) {
        PelParser.SymbolContext predicateSymbol = ctx.symbol();
        IPredicateExpression predicate
                = this.derefPredicate(predicateSymbol);

        INonVariable<ILiteralNonVariableExtension> nonVariableLiteral = null;

        if (predicate != null) {
            List<IBaseExpression<ITrivialExtension>> domain
                    = predicate.getExtension().getDomain();
            if (domain.size() == ctx.args.size()) {
                ctx.args
                        .parallelStream()
                        .forEach(arg -> arg.termVariableContext = ctx.pelVariableContext.getTermVariableContext());
                ctx.args
                        .parallelStream()
                        .forEach(arg -> arg.termVariableInfo = ctx.literalVariableInfo.getTermVariableInfo());
                for (int i = 0; i < domain.size(); i++) {
                    ctx.args.get(i).expectedSort = domain.get(i);
                }
                List<IBaseExpression<ITermNonVariableExtension>> arguments
                        = ctx.args
                                .stream()
                                .map(arg -> this.visit(arg))
                                .map(obj -> (INamedTerm) obj)
                                .map(namedTerm -> namedTerm.getTerm())
                                .collect(Collectors.toList());
                boolean argumentsOK = arguments
                        .parallelStream()
                        .allMatch(argument -> argument != null);
                if (argumentsOK) {
                    ILiteralNonVariableExtension nonVariableExtension = new LiteralNonVariableExtension(
                            predicate,
                            arguments
                    );
                    nonVariableLiteral = new NonVariable<>(
                            nonVariableExtension,
                            this.literalNonVariableExtensionVariableOccurenceChecker,
                            this.literalNonVariableExtensionBaseCopy,
                            this.literalNonVariableExtensionUnification);
                }
            } else {
                IBackReference bref = new BackReference();
                ModuleHelper.getBackReference(this.module, bref, null);
                Map<IPredicateExpression, String> predicateRef = bref.getPredicateRef();
                String predicateName = predicateRef.get(predicate);
                this.printErr_LeadingLine_Region(ctx.start, ctx.stop, "" + domain.size() + "args expected for " + predicateName + ".  " + ctx.args.size() + " found.");
            }
        }
        INamedLiteral namedLiteral
                = nonVariableLiteral == null
                        ? null
                        : new NamedLiteral(nonVariableLiteral, ctx.pelVariableContext);
        return (Object) namedLiteral;
    }

    @Override
    public Object visitAxiomConstant(PelParser.AxiomConstantContext ctx) {
        PelParser.SymbolContext symbol = ctx.symbol();
        INamedClause namedClause
                = this.derefClause(symbol);
        if (namedClause == null) {
            this.printErr_LeadingLine_Region(ctx.start, ctx.stop, "clause symbol " + symbol.getText() + " not declared.");
        }

        return (Object) namedClause;
    }

    @Override
    public Object visitAxiomExpression(PelParser.AxiomExpressionContext ctx) {
        PelParser.Variable_ctxContext variable_ctx
                = ctx.variable_ctx();
        CtxBean ctxBean = new CtxBean();
        variable_ctx.ctxBean = ctxBean;
        variable_ctx.pelVariableContext = this.module.getInitialCtxBean().getPelVariableContext();
        variable_ctx.literalVariableInfo = this.module.getInitialCtxBean().getLiteralVariableInfo();
        this.visit(variable_ctx);

        PelParser.LiteralContext conclusionContext = ctx.conclusion;
        conclusionContext.pelVariableContext = ctxBean.getPelVariableContext();
        conclusionContext.literalVariableInfo = ctxBean.getLiteralVariableInfo();
        INamedLiteral namedConclusion
                = (INamedLiteral) this.visit(conclusionContext);
        IBaseExpression<ILiteralNonVariableExtension> conclusion
                = namedConclusion.getLiteral();
        INamedClause namedClause = null;
        if (conclusion != null) {
            ctx.premises
                    .parallelStream()
                    .forEach(premis -> premis.pelVariableContext = ctxBean.getPelVariableContext());
            ctx.premises
                    .parallelStream()
                    .forEach(premis -> premis.literalVariableInfo = ctxBean.getLiteralVariableInfo());
            List<IBaseExpression<ILiteralNonVariableExtension>> premises
                    = ctx.premises
                            .stream()
                            .map(premis -> this.visit(premis))
                            .map(obj -> (INamedLiteral) obj)
                            .map(namedLiteral -> namedLiteral.getLiteral())
                            .collect(Collectors.toList());

            boolean premisesOK = premises
                    .parallelStream()
                    .allMatch(argument -> argument != null);
            if (premisesOK) {
                IClause clause = new Clause(conclusion, premises);
                namedClause = new NamedClause(clause, ctxBean.getPelVariableContext());
            }
        }
        return (Object) namedClause;
    }

    @Override
    public Object visitSymbol(PelParser.SymbolContext ctx) {
        Object[] outData = new Object[2];
        {
            List<Token> quals = ctx.quals;
            List<String> qualificator
                    = Collections.synchronizedList(quals
                            .parallelStream()
                            .map(token -> token.getText())
                            .collect(Collectors.toList()));
            IModule retval = null;
            try {
                retval = this.module.derefModule(qualificator).get();
            } catch (QualificatorException ex) {
                this.printErr_LeadingLine_Region(quals.get(0), quals.get(quals.size() - 1), ex.getMessage());
            }

            outData[0] = (Object) retval;
        }
        outData[1] = (Object) ctx.base;
        return (Object) outData;
    }

    @Override
    public Object visitLiteralBasicVariable(PelParser.LiteralBasicVariableContext ctx) {
        IVariable<ILiteralNonVariableExtension> literal = null;
        SymbolBean symbolBean = new SymbolBean();
        if (this.parseLiteralBaseVariable(symbolBean, ctx.getText())) {
            String baseVariableText = symbolBean.getSymbol();
            Map<String, IVariable<ILiteralNonVariableExtension>> literalBaseVars
                    = ctx.literalVariableInfo.getLiteralBaseVars();
            if (literalBaseVars.containsKey(baseVariableText)) {
                literal = literalBaseVars.get(baseVariableText);
            } else {
                ITrivialExtension extension = this.module.getTrivialExtension();
                IVariableContext<ITrivialExtension, ILiteralNonVariableExtension> literalVariableContext
                        = this.lookupVariableContextForBaseLiterals(ctx.literalVariableInfo, symbolBean);
                literal = literalVariableContext.createVariable(extension, baseVariableText);
                literalBaseVars.put(baseVariableText, literal);
            }
        }
        INamedLiteral namedLiteral
                = literal == null
                        ? null
                        : new NamedLiteral(literal, ctx.pelVariableContext);
        return (Object) namedLiteral;
    }

    @Override
    public Object visitLiteralIndexedVariable(PelParser.LiteralIndexedVariableContext ctx) {
        IVariable<ILiteralNonVariableExtension> literal = null;
        IndexedSymbolBean indexedSymbolBean = new IndexedSymbolBean();
        if (this.parseLiteralIndexedVariable(indexedSymbolBean, ctx.getText())) {
            String baseVariableText = indexedSymbolBean.getSymbol();
            Integer index = indexedSymbolBean.getIndex();

            Map<Integer, IVariable<ILiteralNonVariableExtension>> varIndex
                    = null;
            Map<String, Map<Integer, IVariable<ILiteralNonVariableExtension>>> literalIndexedVars
                    = ctx.literalVariableInfo.getLiteralIndexedVars();
            if (literalIndexedVars.containsKey(baseVariableText)) {
                varIndex = literalIndexedVars.get(baseVariableText);
            } else {
                varIndex = new ConcurrentHashMap<>();
                literalIndexedVars.put(baseVariableText, varIndex);
            }
            if (varIndex.containsKey(index)) {
                literal = varIndex.get(index);
            } else {
                ITrivialExtension literalExtension = this.module.getTrivialExtension();
                IVariableContext<ITrivialExtension, ILiteralNonVariableExtension> literalVariableContext
                        = this.lookupVariableContextForIndexedLiterals(ctx.literalVariableInfo, indexedSymbolBean);
                literal = literalVariableContext.createVariable(literalExtension, baseVariableText);
                varIndex.put(index, literal);
            }

        }
        INamedLiteral namedLiteral
                = literal == null
                        ? null
                        : new NamedLiteral(literal, ctx.pelVariableContext);
        return (Object) namedLiteral;
    }

    @Override
    public Object visitTermBasicVariable(PelParser.TermBasicVariableContext ctx) {
        IVariable<ITermNonVariableExtension> term = null;
        SymbolBean symbolBean = new SymbolBean();
        if (this.parseTermBaseVariable(symbolBean, ctx.getText())) {
            String baseVariableText = symbolBean.getSymbol();
            Map<String, IVariable<ITermNonVariableExtension>> termBaseVars
                    = ctx.termVariableInfo.getTermBaseVars();
            if (ctx.expectedSort == null) {
                this.printErr_LeadingLine_SingleToken(ctx.start, "no sort derivable from variable " + baseVariableText + ".");
            } else if (termBaseVars.containsKey(baseVariableText)) {
                term = termBaseVars.get(baseVariableText);
            } else {
                IVariableContext<IBaseExpression<ITrivialExtension>, ITermNonVariableExtension> termVariableContext
                        = this.lookupVariableContextForBaseTerms(ctx.termVariableInfo, symbolBean);
                term = termVariableContext.createVariable(ctx.expectedSort, baseVariableText);
                termBaseVars.put(baseVariableText, term);
            }
        }
        INamedTerm namedTerm
                = term == null
                        ? null
                        : new NamedTerm(term, ctx.termVariableContext);
        return (Object) namedTerm;
    }

    @Override
    public Object visitTermIndexedVariable(PelParser.TermIndexedVariableContext ctx) {
        IVariable<ITermNonVariableExtension> term = null;
        IndexedSymbolBean indexedSymbolBean = new IndexedSymbolBean();
        if (this.parseTermIndexedVariable(indexedSymbolBean, ctx.getText())) {
            String baseVariableText = indexedSymbolBean.getSymbol();
            Integer index = indexedSymbolBean.getIndex();
            if (ctx.expectedSort == null) {
                this.printErr_LeadingLine_SingleToken(ctx.start, "no sort derivable from variable " + baseVariableText + ".");
            } else {
                Map<Integer, IVariable<ITermNonVariableExtension>> varIndex
                        = null;
                Map<String, Map<Integer, IVariable<ITermNonVariableExtension>>> termIndexedVars
                        = ctx.termVariableInfo.getTermIndexedVars();
                if (termIndexedVars.containsKey(baseVariableText)) {
                    varIndex = termIndexedVars.get(baseVariableText);
                } else {
                    varIndex = new ConcurrentHashMap<>();
                    termIndexedVars.put(baseVariableText, varIndex);
                }
                if (varIndex.containsKey(index)) {
                    term = varIndex.get(index);
                } else {
                    IVariableContext<IBaseExpression<ITrivialExtension>, ITermNonVariableExtension> termVariableContext
                            = this.lookupVariableContextForIndexedTerms(ctx.termVariableInfo, indexedSymbolBean);
                    term = termVariableContext.createVariable(ctx.expectedSort, baseVariableText);
                    varIndex.put(index, term);
                }
            }
        }
        INamedTerm namedTerm
                = term == null
                        ? null
                        : new NamedTerm(term, ctx.termVariableContext);
        return (Object) namedTerm;
    }

    @Override
    public Object visitVariable_ctx(PelParser.Variable_ctxContext ctx) {
        IPELVariableContext newPelVariableContext
                = new PELVariableContext(
                        ctx.pelVariableContext
                );
        ctx.ctxBean.setPelVariableContext(newPelVariableContext);
        LiteralVariableInfo newLiteralVariableInfo
                = new LiteralVariableInfo(ctx.literalVariableInfo);
        ctx.ctxBean.setLiteralVariableInfo(newLiteralVariableInfo);
        ctx.args
                .parallelStream()
                .forEach(c -> c.pelVariableContext = newPelVariableContext);
        ctx.args
                .parallelStream()
                .forEach(c -> c.literalVariableInfo = newLiteralVariableInfo);
        this.visitChildren(ctx);
        return null;
    }

    @Override
    public Object visitLiteralIndexedCtx(PelParser.LiteralIndexedCtxContext ctx) {
        IndexedSymbolBean indexedSymbolBean = new IndexedSymbolBean();
        if (this.parseLiteralIndexedVariable(indexedSymbolBean, ctx.getText())) {
            String baseVariableText = indexedSymbolBean.getSymbol();
            Integer index = indexedSymbolBean.getIndex();
            Map<String, Map<Integer, IVariableContext<ITrivialExtension, ILiteralNonVariableExtension>>> literalIndexedCtxMap
                    = ctx.literalVariableInfo.getLiteralIndexedCtx();
            Map<Integer, IVariableContext<ITrivialExtension, ILiteralNonVariableExtension>> excerpt
                    = null;
            if (literalIndexedCtxMap.containsKey(baseVariableText)) {
                excerpt = literalIndexedCtxMap.get(baseVariableText);
            } else {
                excerpt = new ConcurrentHashMap<>();
                literalIndexedCtxMap.put(baseVariableText, excerpt);
            }
            excerpt.put(index, ctx.pelVariableContext.getLiteralVariableContext());
        }
        return null;
    }

    @Override
    public Object visitLiteralBaseCtx(PelParser.LiteralBaseCtxContext ctx) {
        SymbolBean symbolBean = new SymbolBean();
        if (this.parseLiteralBaseVariable(symbolBean, ctx.getText())) {
            String baseVariableText = symbolBean.getSymbol();
            Map<String, IVariableContext<ITrivialExtension, ILiteralNonVariableExtension>> literalBaseCtxMap
                    = ctx.literalVariableInfo.getLiteralBaseCtx();
            literalBaseCtxMap.put(baseVariableText, ctx.pelVariableContext.getLiteralVariableContext());
        }
        return null;
    }

    @Override
    public Object visitTermIndexedCtx(PelParser.TermIndexedCtxContext ctx) {
        IndexedSymbolBean indexedSymbolBean = new IndexedSymbolBean();
        if (this.parseTermIndexedVariable(indexedSymbolBean, ctx.getText())) {
            String baseVariableText = indexedSymbolBean.getSymbol();
            Integer index = indexedSymbolBean.getIndex();

            Map<String, Map<Integer, IVariableContext<IBaseExpression<ITrivialExtension>, ITermNonVariableExtension>>> termIndexedCtxMap
                    = ctx.literalVariableInfo.getTermIndexedCtx();
            Map<Integer, IVariableContext<IBaseExpression<ITrivialExtension>, ITermNonVariableExtension>> excerpt
                    = null;
            if (termIndexedCtxMap.containsKey(baseVariableText)) {
                excerpt = termIndexedCtxMap.get(baseVariableText);
            } else {
                excerpt = new ConcurrentHashMap<>();
                termIndexedCtxMap.put(baseVariableText, excerpt);
            }
            excerpt.put(index, ctx.pelVariableContext.getTermVariableContext());
        }

        return null;
    }

    @Override
    public Object visitTermBaseCtx(PelParser.TermBaseCtxContext ctx) {
        SymbolBean symbolBean = new SymbolBean();
        if (this.parseTermBaseVariable(symbolBean, ctx.getText())) {
            String baseVariableText = symbolBean.getSymbol();
            Map<String, IVariableContext<IBaseExpression<ITrivialExtension>, ITermNonVariableExtension>> termBaseCtxMap
                    = ctx.literalVariableInfo.getTermBaseCtx();
            termBaseCtxMap.put(baseVariableText, ctx.pelVariableContext.getTermVariableContext());
        }
        return null;
    }

    private IVariableContext<ITrivialExtension, ILiteralNonVariableExtension> lookupVariableContextForBaseLiterals(
            LiteralVariableInfo literalVariableInfo,
            SymbolBean symbolBean
    ) {
        IVariableContext<ITrivialExtension, ILiteralNonVariableExtension> retval
                = literalVariableInfo.lookupVariableContextForBaseLiterals(symbolBean);
        if (retval == null) {
            retval = this.module.getInitialCtxBean().getPelVariableContext().getLiteralVariableContext();
        }

        return retval;
    }

    private IVariableContext<ITrivialExtension, ILiteralNonVariableExtension> lookupVariableContextForIndexedLiterals(
            LiteralVariableInfo literalVariableInfo,
            IndexedSymbolBean indexedSymbolBean
    ) {
        IVariableContext<ITrivialExtension, ILiteralNonVariableExtension> retval
                = literalVariableInfo.lookupVariableContextForIndexedLiterals(indexedSymbolBean);
        if (retval == null) {
            retval = this.module.getInitialCtxBean().getPelVariableContext().getLiteralVariableContext();
        }

        return retval;
    }

    private IVariableContext<IBaseExpression<ITrivialExtension>, ITermNonVariableExtension> lookupVariableContextForBaseTerms(
            TermVariableInfo termVariableInfo,
            SymbolBean symbolBean
    ) {
        IVariableContext<IBaseExpression<ITrivialExtension>, ITermNonVariableExtension> retval
                = termVariableInfo.lookupVariableContextForBaseTerms(symbolBean);
        if (retval == null) {
            retval = this.module.getInitialCtxBean().getPelVariableContext().getTermVariableContext();
        }

        return retval;
    }

    private IVariableContext<IBaseExpression<ITrivialExtension>, ITermNonVariableExtension> lookupVariableContextForIndexedTerms(
            TermVariableInfo termVariableInfo,
            IndexedSymbolBean indexedSymbolBean
    ) {
        IVariableContext<IBaseExpression<ITrivialExtension>, ITermNonVariableExtension> retval
                = termVariableInfo.lookupVariableContextForIndexedTerms(indexedSymbolBean);
        if (retval == null) {
            retval = this.module.getInitialCtxBean().getPelVariableContext().getTermVariableContext();
        }

        return retval;
    }

    private boolean parseLiteralBaseVariable(SymbolBean symbolBean, String symbol) {
        Matcher m = this.literalBaseVarPattern.matcher(symbol);
        boolean retval = m.matches();
        if (retval) {
            String symbolText = m.group(1);
            if (symbolText.equals("__")) {
                symbolText = "_";
            }
            symbolBean.setSymbol(symbolText);
        }
        return retval;
    }

    private boolean parseLiteralIndexedVariable(IndexedSymbolBean indexedSymbolBean, String indexedSymbol) {
        Matcher m = this.literalIndexedVarPattern.matcher(indexedSymbol);
        boolean retval = m.matches();
        if (retval) {
            String indexedSymbolText = m.group(1);
            if (indexedSymbolText.equals("__")) {
                indexedSymbolText = "_";
            }
            String indexText = m.group(2);
            Integer index = Integer.parseInt(indexText);
            indexedSymbolBean.setIndex(index);
            indexedSymbolBean.setSymbol(indexedSymbolText);
        }
        return retval;
    }

    private boolean parseTermBaseVariable(SymbolBean symbolBean, String symbol) {
        Matcher m = this.termBaseVarPattern.matcher(symbol);
        boolean retval = m.matches();
        if (retval) {
            String symbolText = m.group(1);
            if (symbolText.equals("__")) {
                symbolText = "_";
            }
            symbolBean.setSymbol(symbolText);
        }
        return retval;
    }

    private boolean parseTermIndexedVariable(IndexedSymbolBean indexedSymbolBean, String indexedSymbol) {
        Matcher m = this.termIndexedVarPattern.matcher(indexedSymbol);
        boolean retval = m.matches();
        if (retval) {
            String indexedSymbolText = m.group(1);
            if (indexedSymbolText.equals("__")) {
                indexedSymbolText = "_";
            }
            String indexText = m.group(2);
            Integer index = Integer.parseInt(indexText);
            indexedSymbolBean.setIndex(index);
            indexedSymbolBean.setSymbol(indexedSymbolText);
        }
        return retval;
    }

    private INamedClause derefClause(PelParser.SymbolContext ctx) {
        Object[] visit = (Object[]) this.visit(ctx);
        IModule baseModule = (IModule) visit[0];
        Token base = (Token) visit[1];
        String baseText = base.getText();

        INamedClause retval = null;
        Map<String, INamedClause> axiomsMap
                = baseModule.getAxioms();
        if (axiomsMap.containsKey(baseText)) {
            retval = axiomsMap.get(baseText);
        } else {
            this.printErr_LeadingLine_SingleToken(base, "base " + baseText + " not found");
        }
        return retval;
    }

    private IOperationExpression derefOperation(PelParser.SymbolContext ctx) {
        Object[] visit = (Object[]) this.visit(ctx);
        IModule baseModule = (IModule) visit[0];
        Token base = (Token) visit[1];
        String baseText = base.getText();

        IOperationExpression retval = null;
        Map<String, IOperationExpression> operationsMap = baseModule.getOperations();
        if (operationsMap.containsKey(baseText)) {
            retval = operationsMap.get(baseText);
        } else {
            this.printErr_LeadingLine_SingleToken(base, "base " + baseText + " not found");
        }
        return retval;
    }

    private IPredicateExpression derefPredicate(PelParser.SymbolContext ctx) {
        Object[] visit = (Object[]) this.visit(ctx);
        IModule baseModule = (IModule) visit[0];
        Token base = (Token) visit[1];
        String baseText = base.getText();

        IPredicateExpression retval = null;
        Map<String, IPredicateExpression> predicatesMap = baseModule.getPredicates();
        if (predicatesMap.containsKey(baseText)) {
            retval = predicatesMap.get(baseText);
        } else {
            this.printErr_LeadingLine_SingleToken(base, "base " + baseText + " not found");
        }
        return retval;
    }

    private IBaseExpression<ITrivialExtension> derefSort(PelParser.SymbolContext ctx) {
        Object[] visit = (Object[]) this.visit(ctx);
        IModule baseModule = (IModule) visit[0];
        Token base = (Token) visit[1];
        String baseText = base.getText();

        IBaseExpression<ITrivialExtension> retval = null;
        Map<String, IBaseExpression<ITrivialExtension>> sortsMap = baseModule.getSorts();
        if (sortsMap.containsKey(baseText)) {
            retval = sortsMap.get(baseText);
        } else {
            this.printErr_LeadingLine_SingleToken(base, "base " + baseText + " not found");
        }
        return retval;
    }

    private void printErr_LeadingLine_SingleToken(Token token, String msg) {
        System.err.println(this.moduleName + ":" + token.getLine() + "." + token.getCharPositionInLine() + ": " + msg);
    }

    private void printErr_LeadingLine_Region(Token begin, Token end, String msg) {
        System.err.println(
                this.moduleName
                + ":"
                + begin.getLine()
                + "."
                + begin.getCharPositionInLine()
                + ".."
                + end.getLine()
                + "."
                + end.getCharPositionInLine()
                + ": "
                + msg);

    }

}
