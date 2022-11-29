/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.antlr.impl;

import dom.jfischer.probeunify2.antlr.ExpressionSystem;
import dom.jfischer.probeunify2.basic.IBaseCopy;
import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.ICheckVariableOccurence;
import dom.jfischer.probeunify2.basic.ICopy;
import dom.jfischer.probeunify2.basic.INonVariable;
import dom.jfischer.probeunify2.basic.ITrivialExtension;
import dom.jfischer.probeunify2.basic.IUnification;
import dom.jfischer.probeunify2.basic.IVariable;
import dom.jfischer.probeunify2.basic.impl.CopyBaseCopy;
import dom.jfischer.probeunify2.basic.impl.NonVariable;
import dom.jfischer.probeunify2.basic.impl.TrivialExtension;
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
import dom.jfischer.probeunify2.pel.impl.NamedLiteral;
import dom.jfischer.probeunify2.pel.impl.NamedTerm;
import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;
import dom.jfischer.probeunify2.pel.IOperation;
import dom.jfischer.probeunify2.pel.IOperationExpression;
import dom.jfischer.probeunify2.pel.IPELVariableContext;
import dom.jfischer.probeunify2.pel.IPredicate;
import dom.jfischer.probeunify2.pel.IPredicateExpression;
import dom.jfischer.probeunify2.pel.ITermExtension;
import dom.jfischer.probeunify2.pel.ITermNonVariableExtension;
import dom.jfischer.probeunify2.pel.impl.LiteralNonVariableExtension;
import dom.jfischer.probeunify2.pel.impl.LiteralNonVariableExtensionCopy;
import dom.jfischer.probeunify2.pel.impl.LiteralNonVariableExtensionUnification;
import dom.jfischer.probeunify2.pel.impl.Operation;
import dom.jfischer.probeunify2.pel.impl.OperationExpression;
import dom.jfischer.probeunify2.pel.impl.PELVariableContext;
import dom.jfischer.probeunify2.pel.impl.Predicate;
import dom.jfischer.probeunify2.pel.impl.PredicateExpression;
import dom.jfischer.probeunify2.pel.impl.TermExtension;
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
public class PelThisVisitor extends PelBaseVisitor<Object> {

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
    private final Pattern baseVarPattern;
    private final Pattern indexedVarPattern;

    private final IPPrintBase pprintBase;

    public PelThisVisitor(IModule module, String moduleName) {
        this.moduleName = moduleName;
        this.module = module;

        this.baseVarPattern = Pattern.compile("^\\?(__|[A-Za-z_][A-Za-z0-9]*)$");
        this.indexedVarPattern = Pattern.compile("^\\?(__|[A-Za-z_][A-Za-z0-9]*)_([0-9]+)$");

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
    public Object visitProof(PelParser.ProofContext ctx) {
        IPELVariableContext pelVariableContext = new PELVariableContext();
        Map<String, IVariable<ILiteralNonVariableExtension>> literalBaseVars
                = new ConcurrentHashMap<>();
        Map<String, Map<Integer, IVariable<ILiteralNonVariableExtension>>> literalIndexedVars
                = new ConcurrentHashMap<>();
        Map<String, IVariable<ITermNonVariableExtension>> termBaseVars
                = new ConcurrentHashMap<>();
        Map<String, Map<Integer, IVariable<ITermNonVariableExtension>>> termIndexedVars
                = new ConcurrentHashMap<>();

        List<PelParser.ClauseContext> clausesContext = ctx.clauses;
        clausesContext
                .parallelStream()
                .forEach(clause -> clause.literalBaseVars = literalBaseVars);
        clausesContext
                .parallelStream()
                .forEach(clause -> clause.literalIndexedVars = literalIndexedVars);
        clausesContext
                .parallelStream()
                .forEach(clause -> clause.termBaseVars = termBaseVars);
        clausesContext
                .parallelStream()
                .forEach(clause -> clause.termIndexedVars = termIndexedVars);
        clausesContext
                .parallelStream()
                .forEach(clause -> clause.pelVariableContext = pelVariableContext);
        Set<IClause> proof = clausesContext
                .stream()
                .map(clause -> this.visit(clause))
                .map(obj -> (IClause) obj)
                .collect(Collectors.toSet());
        return (Object) proof;
    }

    @Override
    public Object visitModule_decl(PelParser.Module_declContext ctx) {
        Token symbol = ctx.SymbolToken(0).getSymbol();
        Token baseModuleSymbol = ctx.SymbolToken(1).getSymbol();
        String symbolText = symbol.getText();
        String baseModuleSymbolText = baseModuleSymbol.getText();
        IModule baseModule = new Module();
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
    public Object visitLiteral_variable_decl(PelParser.Literal_variable_declContext ctx) {
        IPELVariableContext pelVariableContext
                = new PELVariableContext();
        Token variableToken = ctx.SymbolToken().getSymbol();
        String variableText = variableToken.getText();
        Map<String, INamedLiteral> literalsMap = this.module.getLiterals();
        boolean errorMode = false;
        if (literalsMap.containsKey(variableText)) {
            printErr_LeadingLine_SingleToken(variableToken, "variable " + variableText + " already declared as literal.");
            errorMode = true;
        }
        if (!errorMode) {
            ITrivialExtension literalExtension = new TrivialExtension();
            IVariable<ILiteralNonVariableExtension> variable
                    = pelVariableContext.getLiteralVariableContext().createVariable(literalExtension, variableText);
            INamedLiteral namedLiteral = new NamedLiteral(variable, pelVariableContext);
            literalsMap.put(variableText, namedLiteral);
        }
        return null;
    }

    @Override
    public Object visitTerm_variable_decl(PelParser.Term_variable_declContext ctx) {
        IPELVariableContext pelVariableContext
                = new PELVariableContext();
        Token variableToken = ctx.SymbolToken().getSymbol();
        String variableText = variableToken.getText();
        Map<String, INamedTerm> termsMap = this.module.getTerms();
        boolean errorMode = false;
        if (termsMap.containsKey(variableText)) {
            printErr_LeadingLine_SingleToken(variableToken, "variable " + variableText + " already declared as term.");
            errorMode = true;
        }
        if (!errorMode) {
            PelParser.SymbolContext symbolContext = ctx.symbol();
            IBaseExpression<ITrivialExtension> sort = this.derefSort(symbolContext);
            ITermExtension termExtension = new TermExtension(sort);
            IVariable<ITermNonVariableExtension> variable
                    = pelVariableContext.getTermVariableContext().createVariable(termExtension, variableText);
            INamedTerm namedTerm = new NamedTerm(variable, pelVariableContext.getTermVariableContext());
            termsMap.put(variableText, namedTerm);
        }
        return null;
    }

    @Override
    public Object visitTerm_decl(PelParser.Term_declContext ctx) {
        IPELVariableContext pelVariableContext
                = new PELVariableContext();
        Map<String, IVariable<ITermNonVariableExtension>> termBaseVars
                = new ConcurrentHashMap<>();
        Map<String, Map<Integer, IVariable<ITermNonVariableExtension>>> termIndexedVars
                = new ConcurrentHashMap<>();
        Token termToken = ctx.SymbolToken().getSymbol();
        String termText = termToken.getText();
        Map<String, INamedTerm> termsMap = this.module.getTerms();
        PelParser.TermContext termContext = ctx.term();
        termContext.pelVariableContext = pelVariableContext;
        termContext.termBaseVars = termBaseVars;
        termContext.termIndexedVars = termIndexedVars;
        termContext.expectedSort = null;
        IBaseExpression<ITermNonVariableExtension> term
                = (IBaseExpression<ITermNonVariableExtension>) this.visit(termContext);
        if (termsMap.containsKey(termText)) {
            printErr_LeadingLine_SingleToken(termToken, "term " + termText + " already declared.");
        } else if (term != null) {
            INamedTerm namedTerm
                    = new NamedTerm(term, pelVariableContext.getTermVariableContext());
            termsMap.put(termText, namedTerm);
        }
        return null;
    }

    @Override
    public Object visitLiteral_decl(PelParser.Literal_declContext ctx) {
        IPELVariableContext pelVariableContext
                = new PELVariableContext();
        Map<String, IVariable<ILiteralNonVariableExtension>> literalBaseVars
                = new ConcurrentHashMap<>();
        Map<String, Map<Integer, IVariable<ILiteralNonVariableExtension>>> literalIndexedVars
                = new ConcurrentHashMap<>();
        Map<String, IVariable<ITermNonVariableExtension>> termBaseVars
                = new ConcurrentHashMap<>();
        Map<String, Map<Integer, IVariable<ITermNonVariableExtension>>> termIndexedVars
                = new ConcurrentHashMap<>();
        Token literalToken = ctx.SymbolToken().getSymbol();
        String literalText = literalToken.getText();
        Map<String, INamedLiteral> literalsMap = this.module.getLiterals();
        PelParser.LiteralContext literalContext = ctx.literal();
        literalContext.pelVariableContext = pelVariableContext;
        literalContext.literalBaseVars = literalBaseVars;
        literalContext.literalIndexedVars = literalIndexedVars;
        literalContext.termBaseVars = termBaseVars;
        literalContext.termIndexedVars = termIndexedVars;
        IBaseExpression<ILiteralNonVariableExtension> literal
                = (IBaseExpression<ILiteralNonVariableExtension>) this.visit(literalContext);
        if (literalsMap.containsKey(literalText)) {
            printErr_LeadingLine_SingleToken(literalToken, "literal " + literalText + " already declared.");
        } else if (literal != null) {
            INamedLiteral namedLiteral = new NamedLiteral(literal, pelVariableContext);
            literalsMap.put(literalText, namedLiteral);
        }
        return null;
    }

    @Override
    public Object visitAxiom_decl(PelParser.Axiom_declContext ctx) {
        IPELVariableContext pelVariableContext
                = new PELVariableContext();
        Map<String, IVariable<ILiteralNonVariableExtension>> literalBaseVars
                = new ConcurrentHashMap<>();
        Map<String, Map<Integer, IVariable<ILiteralNonVariableExtension>>> literalIndexedVars
                = new ConcurrentHashMap<>();
        Map<String, IVariable<ITermNonVariableExtension>> termBaseVars
                = new ConcurrentHashMap<>();
        Map<String, Map<Integer, IVariable<ITermNonVariableExtension>>> termIndexedVars
                = new ConcurrentHashMap<>();
        Token axiomToken = ctx.SymbolToken().getSymbol();
        String axiomText = axiomToken.getText();
        Map<String, INamedClause> axiomsMap
                = this.module.getAxioms();
        PelParser.ClauseContext clauseContext = ctx.clause();
        clauseContext.pelVariableContext = pelVariableContext;
        clauseContext.literalBaseVars = literalBaseVars;
        clauseContext.literalIndexedVars = literalIndexedVars;
        clauseContext.termBaseVars = termBaseVars;
        clauseContext.termIndexedVars = termIndexedVars;
        IClause clause
                = (IClause) this.visit(clauseContext);
        if (axiomsMap.containsKey(axiomText)) {
            printErr_LeadingLine_SingleToken(axiomToken, "axiom " + axiomText + " already declared.");
        } else if (clause != null) {
            INamedClause namedClause
                    = new NamedClause(clause, pelVariableContext);
            axiomsMap.put(axiomText, namedClause);
        }
        return null;
    }

    @Override
    public Object visitTermConstant(PelParser.TermConstantContext ctx) {
        PelParser.SymbolContext symbol = ctx.symbol();
        INamedTerm namedTerm = this.derefTerm(symbol);
        IBaseExpression<ITermNonVariableExtension> term = null;
        if (namedTerm == null) {
            this.printErr_LeadingLine_Region(ctx.start, ctx.stop, "term symbol " + symbol.getText() + " not declared.");
        } else {
            term = namedTerm.getTerm();
            if (ctx.expectedSort != null) {
                IBaseExpression<ITrivialExtension> realSort
                        = namedTerm.getExtension().getSort();
                if (!ctx.expectedSort.eq(realSort)) {
                    IBackReference bref = new BackReference();
                    ModuleHelper.getBackReference(this.module, bref, null);
                    Map<IBaseExpression<ITrivialExtension>, String> sortRef = bref.getSortRef();
                    String realSortRef = sortRef.get(realSort);
                    String expectedSortRef = sortRef.get(ctx.expectedSort);
                    this.printErr_LeadingLine_SingleToken(symbol.SymbolToken, symbol.getText() + " has wrong type (" + realSortRef + "); expected: (" + expectedSortRef + ")");
                }
            }
        }

        return (Object) term;
    }

    @Override
    public Object visitLiteralVariable(PelParser.LiteralVariableContext ctx) {
        PelParser.VariableContext variableContext = ctx.variable();
        variableContext.expressionSystem = ExpressionSystem.LITERALS;
        variableContext.expectedSort = null;
        variableContext.literalBaseVars = ctx.literalBaseVars;
        variableContext.literalIndexedVars = ctx.literalIndexedVars;
        variableContext.termBaseVars = ctx.termBaseVars;
        variableContext.termIndexedVars = ctx.termIndexedVars;
        variableContext.pelVariableContext = ctx.pelVariableContext;
        return visitChildren(ctx);
    }

    @Override
    public Object visitTermVariable(PelParser.TermVariableContext ctx) {
        PelParser.VariableContext variableContext = ctx.variable();
        variableContext.expressionSystem = ExpressionSystem.TERMS;
        variableContext.expectedSort = ctx.expectedSort;
        variableContext.literalBaseVars = null;
        variableContext.literalIndexedVars = null;
        variableContext.termBaseVars = ctx.termBaseVars;
        variableContext.termIndexedVars = ctx.termIndexedVars;
        variableContext.pelVariableContext = ctx.pelVariableContext;
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
                        .forEach(arg -> arg.pelVariableContext = ctx.pelVariableContext);
                ctx.args
                        .parallelStream()
                        .forEach(arg -> arg.termBaseVars = ctx.termBaseVars);
                ctx.args
                        .parallelStream()
                        .forEach(arg -> arg.termIndexedVars = ctx.termIndexedVars);
                for (int i = 0; i < domain.size(); i++) {
                    ctx.args.get(i).expectedSort = domain.get(i);
                }
                List<IBaseExpression<ITermNonVariableExtension>> arguments
                        = ctx.args
                                .stream()
                                .map(arg -> this.visit(arg))
                                .map(obj -> (IBaseExpression<ITermNonVariableExtension>) obj)
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
                    INamedTerm namedTerm = new NamedTerm(nonVariableTerm, ctx.pelVariableContext.getTermVariableContext());
                    IConstructionPPrint termConstructionPPrint = new TermConstructionPPrint(bref, namedTerm);
                    termConstructionPPrint.pprint(this.pprintBase);
                    this.pprintBase.printNewLine();
                }
            }
        }
        return (Object) nonVariableTerm;
    }

    @Override
    public Object visitLiteralConstant(PelParser.LiteralConstantContext ctx) {
        PelParser.SymbolContext symbol = ctx.symbol();
        INamedLiteral namedLiteral = this.derefLiteral(symbol);
        IBaseExpression<ILiteralNonVariableExtension> literal = null;
        if (namedLiteral == null) {
            this.printErr_LeadingLine_Region(ctx.start, ctx.stop, "literal symbol " + symbol.getText() + " not declared.");
        } else {
            literal = namedLiteral.getLiteral();
        }

        return (Object) literal;
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
                        .forEach(arg -> arg.pelVariableContext = ctx.pelVariableContext);
                ctx.args
                        .parallelStream()
                        .forEach(arg -> arg.termBaseVars = ctx.termBaseVars);
                ctx.args
                        .parallelStream()
                        .forEach(arg -> arg.termIndexedVars = ctx.termIndexedVars);
                for (int i = 0; i < domain.size(); i++) {
                    ctx.args.get(i).expectedSort = domain.get(i);
                }
                List<IBaseExpression<ITermNonVariableExtension>> arguments
                        = ctx.args
                                .stream()
                                .map(arg -> this.visit(arg))
                                .map(obj -> (IBaseExpression<ITermNonVariableExtension>) obj)
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
        return (Object) nonVariableLiteral;
    }

    @Override
    public Object visitAxiomConstant(PelParser.AxiomConstantContext ctx) {
        PelParser.SymbolContext symbol = ctx.symbol();
        INamedClause namedClause
                = this.derefClause(symbol);
        IClause clause = null;
        if (namedClause == null) {
            this.printErr_LeadingLine_Region(ctx.start, ctx.stop, "clause symbol " + symbol.getText() + " not declared.");
        } else {
            clause = namedClause.getClause();
        }

        return (Object) clause;
    }

    @Override
    public Object visitAxiomExpression(PelParser.AxiomExpressionContext ctx) {
        PelParser.LiteralContext conclusionContext = ctx.conclusion;
        conclusionContext.pelVariableContext = ctx.pelVariableContext;
        conclusionContext.literalBaseVars = ctx.literalBaseVars;
        conclusionContext.literalIndexedVars = ctx.literalIndexedVars;
        conclusionContext.termBaseVars = ctx.termBaseVars;
        conclusionContext.termIndexedVars = ctx.termIndexedVars;
        IBaseExpression<ILiteralNonVariableExtension> conclusion
                = (IBaseExpression<ILiteralNonVariableExtension>) this.visit(conclusionContext);
        IClause clause = null;
        if (conclusion != null) {
            ctx.premises
                    .parallelStream()
                    .forEach(premis -> premis.pelVariableContext = ctx.pelVariableContext);
            ctx.premises
                    .parallelStream()
                    .forEach(premis -> premis.literalBaseVars = ctx.literalBaseVars);
            ctx.premises
                    .parallelStream()
                    .forEach(premis -> premis.literalIndexedVars = ctx.literalIndexedVars);
            ctx.premises
                    .parallelStream()
                    .forEach(premis -> premis.termBaseVars = ctx.termBaseVars);
            ctx.premises
                    .parallelStream()
                    .forEach(premis -> premis.termIndexedVars = ctx.termIndexedVars);
            List<IBaseExpression<ILiteralNonVariableExtension>> premises
                    = ctx.premises
                            .stream()
                            .map(premis -> this.visit(premis))
                            .map(obj -> (IBaseExpression<ILiteralNonVariableExtension>) obj)
                            .collect(Collectors.toList());

            boolean premisesOK = premises
                    .parallelStream()
                    .allMatch(argument -> argument != null);
            if (premisesOK) {
                clause = new Clause(conclusion, premises);
            }
        }
        return (Object) clause;
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
    public Object visitIndexedVariable(PelParser.IndexedVariableContext ctx) {
        Object retval = null;
        String rawText = ctx.getText();
        Matcher m = this.indexedVarPattern.matcher(rawText);
        if (m.matches()) {
            String baseVariableText = m.group(1);
            if (baseVariableText.equals("__")) {
                baseVariableText = "_";
            }
            String indexText = m.group(2);
            Integer index = Integer.parseInt(indexText);
            switch (ctx.expressionSystem) {
                case LITERALS: {
                    IVariable<ILiteralNonVariableExtension> literal = null;

                    Map<Integer, IVariable<ILiteralNonVariableExtension>> varIndex
                            = null;
                    if (ctx.literalIndexedVars.containsKey(baseVariableText)) {
                        varIndex = ctx.literalIndexedVars.get(baseVariableText);
                    } else {
                        varIndex = new ConcurrentHashMap<>();
                        ctx.literalIndexedVars.put(baseVariableText, varIndex);
                    }
                    if (varIndex.containsKey(index)) {
                        literal = varIndex.get(index);
                    } else {
                        ITrivialExtension literalExtension = new TrivialExtension();
                        literal = ctx.pelVariableContext.getLiteralVariableContext().createVariable(literalExtension, baseVariableText);
                        varIndex.put(index, literal);
                    }

                    retval = (Object) literal;
                }
                break;
                case TERMS: {
                    IVariable<ITermNonVariableExtension> term = null;

                    if (ctx.expectedSort == null) {
                        this.printErr_LeadingLine_SingleToken(ctx.start, "no sort derivable from variable " + baseVariableText + ".");
                    } else {
                        Map<Integer, IVariable<ITermNonVariableExtension>> varIndex
                                = null;
                        if (ctx.termIndexedVars.containsKey(baseVariableText)) {
                            varIndex = ctx.termIndexedVars.get(baseVariableText);
                        } else {
                            varIndex = new ConcurrentHashMap<>();
                            ctx.termIndexedVars.put(baseVariableText, varIndex);
                        }
                        if (varIndex.containsKey(index)) {
                            term = varIndex.get(index);
                        } else {
                            ITermExtension termExtension = new TermExtension(ctx.expectedSort);
                            term = ctx.pelVariableContext.getTermVariableContext().createVariable(termExtension, baseVariableText);
                            varIndex.put(index, term);
                        }
                    }

                    retval = (Object) term;
                }
                break;
            }
        }

        return retval;
    }

    @Override
    public Object visitBasicVariable(PelParser.BasicVariableContext ctx) {
        Object retval = null;
        String rawText = ctx.getText();
        Matcher m = this.baseVarPattern.matcher(rawText);
        if (m.matches()) {
            String baseVariableText = m.group(1);
            if (baseVariableText.equals("__")) {
                baseVariableText = "_";
            }
            switch (ctx.expressionSystem) {
                case LITERALS: {
                    IVariable<ILiteralNonVariableExtension> literal = null;
                    if (ctx.literalBaseVars.containsKey(baseVariableText)) {
                        literal = ctx.literalBaseVars.get(baseVariableText);
                    } else {
                        ITrivialExtension extension = new TrivialExtension();
                        literal = ctx.pelVariableContext.getLiteralVariableContext().createVariable(extension, baseVariableText);
                        ctx.literalBaseVars.put(baseVariableText, literal);
                    }
                    retval = (Object) literal;
                }
                break;
                case TERMS: {
                    IVariable<ITermNonVariableExtension> term = null;
                    if (ctx.expectedSort == null) {
                        this.printErr_LeadingLine_SingleToken(ctx.start, "no sort derivable from variable " + baseVariableText + ".");
                    } else if (ctx.termBaseVars.containsKey(baseVariableText)) {
                        term = ctx.termBaseVars.get(baseVariableText);
                    } else {
                        ITermExtension extension = new TermExtension(ctx.expectedSort);
                        term = ctx.pelVariableContext.getTermVariableContext().createVariable(extension, baseVariableText);
                        ctx.termBaseVars.put(baseVariableText, term);
                    }
                    retval = (Object) term;
                }
                break;
            }
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

    private INamedLiteral derefLiteral(PelParser.SymbolContext ctx) {
        Object[] visit = (Object[]) this.visit(ctx);
        IModule baseModule = (IModule) visit[0];
        Token base = (Token) visit[1];
        String baseText = base.getText();

        INamedLiteral retval = null;
        Map<String, INamedLiteral> literalsMap = baseModule.getLiterals();
        if (literalsMap.containsKey(baseText)) {
            retval = literalsMap.get(baseText);
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

    private INamedTerm derefTerm(PelParser.SymbolContext ctx) {
        Object[] visit = (Object[]) this.visit(ctx);
        IModule baseModule = (IModule) visit[0];
        Token base = (Token) visit[1];
        String baseText = base.getText();

        INamedTerm retval = null;
        Map<String, INamedTerm> termsMap = baseModule.getTerms();
        if (termsMap.containsKey(baseText)) {
            retval = termsMap.get(baseText);
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
