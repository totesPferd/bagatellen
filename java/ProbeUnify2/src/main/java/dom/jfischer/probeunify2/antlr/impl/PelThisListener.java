/*name;
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.antlr.impl;

import dom.jfischer.probeunify2.antlr.IPelThisListener;
import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.ICheckVariableOccurence;
import dom.jfischer.probeunify2.basic.ICopy;
import dom.jfischer.probeunify2.basic.IUnification;
import dom.jfischer.probeunify2.basic.IVariable;
import dom.jfischer.probeunify2.basic.impl.Variable;
import dom.jfischer.probeunify2.exception.QualificatorException;
import dom.jfischer.probeunify2.module.IModule;
import dom.jfischer.probeunify2.module.INamedClause;
import dom.jfischer.probeunify2.module.INamedLiteral;
import dom.jfischer.probeunify2.module.INamedTerm;
import dom.jfischer.probeunify2.module.impl.Module;
import dom.jfischer.probeunify2.module.impl.ModuleUnification;
import dom.jfischer.probeunify2.module.impl.NamedClause;
import dom.jfischer.probeunify2.module.impl.NamedLiteral;
import dom.jfischer.probeunify2.module.impl.NamedTerm;
import dom.jfischer.probeunify2.pel.IOperation;
import dom.jfischer.probeunify2.pel.IOperationExpression;
import dom.jfischer.probeunify2.pel.IPredicate;
import dom.jfischer.probeunify2.pel.IPredicateExpression;
import dom.jfischer.probeunify2.pel.impl.Operation;
import dom.jfischer.probeunify2.pel.impl.OperationExpression;
import dom.jfischer.probeunify2.pel.impl.Predicate;
import dom.jfischer.probeunify2.pel.impl.PredicateExpression;
import dom.jfischer.probeunify2.basic.impl.NonVariable;
import dom.jfischer.probeunify2.module.impl.ModuleHelper;
import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;
import dom.jfischer.probeunify2.pprint.ITermVariableContext;
import dom.jfischer.probeunify2.pprint.impl.TermVariableContext;
import dom.jfischer.probeunify2.proof.IClause;
import dom.jfischer.probeunify2.proof.impl.Clause;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Stack;
import java.util.stream.Collectors;
import org.antlr.v4.runtime.Token;
import dom.jfischer.probeunify2.pel.ITermNonVariableExtension;
import dom.jfischer.probeunify2.pel.impl.LiteralNonVariableExtension;
import dom.jfischer.probeunify2.pel.impl.LiteralNonVariableExtensionCopy;
import dom.jfischer.probeunify2.pel.impl.LiteralNonVariableExtensionUnification;
import dom.jfischer.probeunify2.pel.impl.TermNonVariableExtension;
import dom.jfischer.probeunify2.pel.impl.TermNonVariableExtensionCopy;
import dom.jfischer.probeunify2.pel.impl.TermNonVariableExtensionUnification;
import dom.jfischer.probeunify2.pprint.IBackReference;
import dom.jfischer.probeunify2.pprint.IConstructionPPrint;
import dom.jfischer.probeunify2.pprint.IPPrintBase;
import dom.jfischer.probeunify2.pprint.IPPrintConfig;
import dom.jfischer.probeunify2.pprint.impl.BackReference;
import dom.jfischer.probeunify2.pprint.impl.PPrintBase;
import dom.jfischer.probeunify2.pprint.impl.PPrintConfig;
import dom.jfischer.probeunify2.pprint.impl.TermConstructionPPrint;
import java.util.HashSet;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.antlr.v4.runtime.CharStream;
import dom.jfischer.probeunify2.basic.ITrivialExtension;
import dom.jfischer.probeunify2.basic.impl.TrivialVariableOccurenceChecker;
import dom.jfischer.probeunify2.pel.impl.TermNonVariableExtensionVariableOccurenceChecker;
import java.util.Collections;
import java.util.concurrent.ConcurrentHashMap;

/**
 *
 * @author jfischer
 */
public class PelThisListener extends PelBaseListener implements
        IPelThisListener {

    private final IUnification<IModule> moduleUnification = new ModuleUnification();
    private final IUnification<ILiteralNonVariableExtension> literalNonVariableExtensionUnification
            = new LiteralNonVariableExtensionUnification();
    private final IUnification<ITermNonVariableExtension> termNonVariableExtensionUnification
            = new TermNonVariableExtensionUnification();
    private final Set<IClause> proof = Collections.synchronizedSet(new HashSet<>());

    private final String moduleName;
    private final IModule module;
    private final IPPrintBase pprintBase;
    private final Pattern baseVarPattern;
    private final Pattern indexedVarPattern;

    private final Stack<IBaseExpression<ITrivialExtension>> inStack = new Stack<>();
    private final Stack<IBaseExpression<ITermNonVariableExtension>> termStack = new Stack<>();
    private final Stack<IBaseExpression<ILiteralNonVariableExtension>> literalStack = new Stack<>();
    private final Stack<Boolean> termSortCheckFlags;

    private final ICopy<ILiteralNonVariableExtension> literalNonVariableExtensionCopy
            = new LiteralNonVariableExtensionCopy();
    private final ICheckVariableOccurence<ILiteralNonVariableExtension> literalNonVariableExtensionVariableOccurenceChecker
            = new TrivialVariableOccurenceChecker<>();
    private final ICopy<ITermNonVariableExtension> termNonVariableExtensionCopy
            = new TermNonVariableExtensionCopy();
    private final ICheckVariableOccurence<ITermNonVariableExtension> termNonVariableExtensionVariableOccurenceChecker
            = new TermNonVariableExtensionVariableOccurenceChecker();

    private ITermVariableContext termVariableContext = null;
    private Map<String, IVariable<ITermNonVariableExtension>> baseVars = null;
    private Map<String, Map<Integer, IVariable<ITermNonVariableExtension>>> indexedVars = null;

    public PelThisListener(IModule module, String moduleName) {
        this.module = module;
        this.moduleName = moduleName;
        this.termSortCheckFlags = new Stack<>();
        this.termSortCheckFlags.push(true);

        this.baseVarPattern = Pattern.compile("^\\?(__|[A-Za-z_][A-Za-z0-9]*)$");
        this.indexedVarPattern = Pattern.compile("^\\?(__|[A-Za-z_][A-Za-z0-9]*)_([0-9]+)$");

        IPPrintConfig pprintConfig = new PPrintConfig();
        this.pprintBase = new PPrintBase(System.err, pprintConfig, 0);
    }

    @Override
    public String getModuleName() {
        return moduleName;
    }

    @Override
    public Set<IClause> getProof() {
        return this.proof;
    }

    @Override
    public void resetProof() {
        this.proof.clear();
    }

    @Override
    public void resetTermVariableContext() {
        this.termVariableContext = new TermVariableContext();
        this.baseVars = new ConcurrentHashMap<>();
        this.indexedVars = new ConcurrentHashMap<>();
    }

    @Override
    public INamedTerm popTerm() {
        IBaseExpression<ITermNonVariableExtension> termExpression
                = this.termStack.pop();
        return new NamedTerm(termExpression, this.termVariableContext);
    }

    @Override
    public INamedLiteral popLiteral() {
        IBaseExpression<ILiteralNonVariableExtension> literalExpression
                = this.literalStack.pop();
        return new NamedLiteral(literalExpression, this.termVariableContext);
    }

    @Override
    public INamedClause popClause() {
        IBaseExpression<ILiteralNonVariableExtension> conclusion
                = this.literalStack.pop();
        List<IBaseExpression<ILiteralNonVariableExtension>> premises
                = Collections.synchronizedList(new ArrayList<>());
        while (this.literalStack.size() > 0) {
            IBaseExpression<ILiteralNonVariableExtension> premise
                    = this.literalStack.pop();
            premises.add(0, premise);
        }
        IClause clause = new Clause(conclusion, premises);
        return new NamedClause(clause, this.termVariableContext);
    }

    @Override
    public void exitModule_decl(PelParser.Module_declContext ctx) {
        Token keyToken = ctx.SymbolToken(0).getSymbol();
        Token valToken = ctx.SymbolToken(1).getSymbol();
        String keyText = keyToken.getText();
        String valText = valToken.getText();
        IModule thisModule = new Module();
        PelThisListener pelThisListener = new PelThisListener(thisModule, valText);
        try {
            CharStream charStream = AntlrHelper.getLogicCharStream(valText);
            AntlrHelper.parseLogic(pelThisListener, charStream);
        } catch (IOException ex) {
            printErr_LeadingLine_SingleToken(valToken, "module " + valText + " could not be read.");
        }
        Map<String, IModule> moduleMap = this.module.getImports();
        if (moduleMap.containsKey(keyText)) {
            printErr_LeadingLine_SingleToken(keyToken, "qualifier " + keyText + " already declared.");
        } else {
            moduleMap.put(keyText, thisModule);
        }
    }

    @Override
    public void exitModule_eq(PelParser.Module_eqContext ctx) {
        List<IModule> modules
                = Collections.synchronizedList(ctx.args
                        .parallelStream()
                        .map(m -> derefModule(m))
                        .collect(Collectors.toList()));
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
    }

    @Override
    public void exitSort_decl(PelParser.Sort_declContext ctx) {
        Token sortToken = ctx.SymbolToken().getSymbol();
        String sortText = sortToken.getText();
        Map<String, IBaseExpression<ITrivialExtension>> sortsMap = this.module.getSorts();
        if (sortsMap.containsKey(sortText)) {
            printErr_LeadingLine_SingleToken(sortToken, "sort " + sortText + " already declared.");
        } else {
            IVariable<ITrivialExtension> sortExpression = new Variable<>();
            sortsMap.put(sortText, sortExpression);
        }
    }

    @Override
    public void exitOperation_decl(PelParser.Operation_declContext ctx) {
        Token operationToken = ctx.SymbolToken().getSymbol();
        String operationText = operationToken.getText();
        Map<String, IOperationExpression> operationsMap = this.module.getOperations();
        if (operationsMap.containsKey(operationText)) {
            printErr_LeadingLine_SingleToken(operationToken, "operation " + operationText + " already declared.");
        } else {
            List<IBaseExpression<ITrivialExtension>> domain
                    = Collections.synchronizedList(ctx.lhs
                            .parallelStream()
                            .map(c -> derefSort(c))
                            .collect(Collectors.toList()));
            IBaseExpression<ITrivialExtension> range = derefSort(ctx.rhs);
            IOperation operation = new Operation(range, domain);
            IBaseExpression<ITrivialExtension> baseExpression = new Variable<>();
            IOperationExpression operationExpression = new OperationExpression(operation, baseExpression);
            operationsMap.put(operationText, operationExpression);
        }
    }

    @Override
    public void exitPredicate_decl(PelParser.Predicate_declContext ctx) {
        Token predicateToken = ctx.SymbolToken().getSymbol();
        String predicateText = predicateToken.getText();
        Map<String, IPredicateExpression> predicatesMap = this.module.getPredicates();
        if (predicatesMap.containsKey(predicateText)) {
            printErr_LeadingLine_SingleToken(predicateToken, "predicate " + predicateText + " already declared.");
        } else {
            List<IBaseExpression<ITrivialExtension>> domain
                    = Collections.synchronizedList(ctx.args
                            .parallelStream()
                            .map(c -> derefSort(c))
                            .collect(Collectors.toList()));
            IPredicate predicate = new Predicate(domain);
            IBaseExpression<ITrivialExtension> baseExpression = new Variable<>();
            IPredicateExpression predicateExpression = new PredicateExpression(predicate, baseExpression);
            predicatesMap.put(predicateText, predicateExpression);
        }
    }

    @Override
    public void enterTerm_decl(PelParser.Term_declContext ctx) {
        this.resetTermVariableContext();
        this.inStack.push(null);
    }

    @Override
    public void exitTerm_decl(PelParser.Term_declContext ctx) {
        Token termToken = ctx.SymbolToken().getSymbol();
        String termText = termToken.getText();
        Map<String, INamedTerm> termsMap = this.module.getTerms();
        INamedTerm namedTerm = this.popTerm();
        if (termsMap.containsKey(termText)) {
            printErr_LeadingLine_SingleToken(termToken, "term " + termText + " already declared.");
        } else {
            termsMap.put(termText, namedTerm);
        }
    }

    @Override
    public void enterVariable_decl(PelParser.Variable_declContext ctx) {
        this.resetTermVariableContext();
    }

    @Override
    public void exitVariable_decl(PelParser.Variable_declContext ctx) {
        Token variableToken = ctx.SymbolToken().getSymbol();
        String variableText = variableToken.getText();
        Map<String, INamedTerm> termsMap = this.module.getTerms();
        boolean errorMode = false;
        if (termsMap.containsKey(variableText)) {
            printErr_LeadingLine_SingleToken(variableToken, "variable " + variableText + " already declared as term.");
            errorMode = true;
        }
        if (this.baseVars.containsKey(variableText)) {
            printErr_LeadingLine_SingleToken(variableToken, "variable " + variableText + " already declared as variable.");
            errorMode = true;
        }
        if (!errorMode) {
            IBaseExpression<ITrivialExtension> sort = this.derefSort(ctx.symbol());
            IVariable<ITermNonVariableExtension> variable
                    = this.termVariableContext.createVariable(sort, variableText);
            this.baseVars.put(variableText, variable);
            INamedTerm namedTerm = new NamedTerm(variable, this.termVariableContext);
            termsMap.put(variableText, namedTerm);
        }
    }

    @Override
    public void enterLiteral_decl(PelParser.Literal_declContext ctx) {
        this.resetTermVariableContext();
    }

    @Override
    public void exitLiteral_decl(PelParser.Literal_declContext ctx) {
        Token literalToken = ctx.SymbolToken().getSymbol();
        String literalText = literalToken.getText();
        Map<String, INamedLiteral> literalsMap = this.module.getLiterals();
        INamedLiteral namedLiteral = this.popLiteral();
        if (literalsMap.containsKey(literalText)) {
            printErr_LeadingLine_SingleToken(literalToken, "literal " + literalText + " already declared.");
        } else {
            literalsMap.put(literalText, namedLiteral);
        }
    }

    @Override
    public void exitAnotherClause(PelParser.AnotherClauseContext ctx) {
        this.proof.add(this.popClause().getClause());
    }

    @Override
    public void enterAxiom_decl(PelParser.Axiom_declContext ctx) {
        this.resetTermVariableContext();
    }

    @Override
    public void exitAxiom_decl(PelParser.Axiom_declContext ctx) {
        Token axiomToken = ctx.SymbolToken().getSymbol();
        String axiomText = axiomToken.getText();
        Map<String, INamedClause> axiomsMap = this.module.getAxioms();
        INamedClause namedClause = this.popClause();
        if (axiomsMap.containsKey(axiomText)) {
            printErr_LeadingLine_SingleToken(axiomToken, "axiom " + axiomText + " already declared.");
        } else {
            axiomsMap.put(axiomText, namedClause);
        }
    }

    @Override
    public void exitLiteralConstant(PelParser.LiteralConstantContext ctx) {
        INamedLiteral namedLiteral = this.derefLiteral(ctx.symbol());
        IBaseExpression<ILiteralNonVariableExtension> literal
                = namedLiteral == null ? null : namedLiteral.getLiteral();
        this.literalStack.push(literal);
    }

    @Override
    public void enterLiteralExpression(PelParser.LiteralExpressionContext ctx) {
        PelParser.SymbolContext symbol = ctx.symbol();
        IPredicateExpression predicate = this.derefPredicate(symbol);
        boolean tscf = predicate != null;
        this.termSortCheckFlags.push(tscf);
        if (tscf) {
            List<IBaseExpression<ITrivialExtension>> domain = predicate.getExtension().getDomain();
            for (int i = domain.size() - 1; i >= 0; i--) {
                this.inStack.push(domain.get(i));
            }
        }
    }

    @Override
    public void exitLiteralExpression(PelParser.LiteralExpressionContext ctx) {
        List<IBaseExpression<ITermNonVariableExtension>> args
                = Collections.synchronizedList(new ArrayList<>());
        for (int i = 0; i < ctx.args.size(); i++) {
            args.add(0, this.termStack.pop());
        }
        boolean tscf = this.termSortCheckFlags.pop();
        IPredicateExpression predicate = null;
        if (tscf) {
            predicate = this.derefPredicate(ctx.symbol());
        }
        ILiteralNonVariableExtension literalNonVariableExtension
                = new LiteralNonVariableExtension(predicate, args);
        IBaseExpression<ILiteralNonVariableExtension> nonVariableLiteral
                = new NonVariable<>(
                        literalNonVariableExtension,
                        this.literalNonVariableExtensionVariableOccurenceChecker,
                        this.literalNonVariableExtensionCopy,
                        this.literalNonVariableExtensionUnification);
        this.literalStack.push(nonVariableLiteral);
    }

    @Override
    public void exitTermConstant(PelParser.TermConstantContext ctx) {
        PelParser.SymbolContext symbol = ctx.symbol();
        INamedTerm namedTerm = this.derefTerm(symbol);
        IBaseExpression<ITrivialExtension> bbSort = this.inStack.pop();
        IBaseExpression<ITermNonVariableExtension> term = null;
        if (namedTerm != null) {
            term = namedTerm.getTerm();
            if (this.termSortCheckFlags.peek()) {
                IBaseExpression<ITrivialExtension> baSort = namedTerm.getSort();
                if (!baSort.eq(bbSort)) {
                    IBackReference bref = new BackReference();
                    ModuleHelper.getBackReference(this.module, bref, null);
                    Map<IBaseExpression<ITrivialExtension>, String> sortRef = bref.getSortRef();
                    String baRef = sortRef.get(baSort);
                    String bbRef = sortRef.get(bbSort);
                    this.printErr_LeadingLine_SingleToken(symbol.SymbolToken, symbol.getText() + " has wrong type (" + baRef + "); expected: (" + bbRef + ")");
                }
            }
        }
        this.termStack.push(term);
    }

    @Override
    public void enterTermExpression(PelParser.TermExpressionContext ctx) {
        PelParser.SymbolContext symbol = ctx.symbol();
        IOperationExpression operation = this.derefOperation(symbol);
        boolean tscf = operation != null;
        this.termSortCheckFlags.push(tscf);
        if (tscf) {
            List<IBaseExpression<ITrivialExtension>> domain = operation.getExtension().getDomain();
            for (int i = domain.size() - 1; i >= 0; i--) {
                this.inStack.push(domain.get(i));
            }
        }
    }

    @Override
    public void exitTermExpression(PelParser.TermExpressionContext ctx) {
        List<IBaseExpression<ITermNonVariableExtension>> args
                = Collections.synchronizedList(new ArrayList<>());
        for (int i = 0; i < ctx.args.size(); i++) {
            args.add(0, this.termStack.pop());
        }
        boolean tscf = this.termSortCheckFlags.pop();
        IOperationExpression operation = null;
        if (tscf) {
            operation = this.derefOperation(ctx.symbol());
        }
        ITermNonVariableExtension termNonVariableExtension
                = new TermNonVariableExtension(operation, args);
        IBaseExpression<ITrivialExtension> baSort = tscf ? operation.getExtension().getRange() : null;
        IBaseExpression<ITermNonVariableExtension> nonVariableTerm
                = new NonVariable<>(
                        termNonVariableExtension,
                        this.termNonVariableExtensionVariableOccurenceChecker,
                        this.termNonVariableExtensionCopy,
                        this.termNonVariableExtensionUnification);
        this.termStack.push(nonVariableTerm);
        if (tscf && this.termSortCheckFlags.peek()) {
            IBaseExpression<ITrivialExtension> bbSort = this.inStack.pop();
            if (bbSort != null) {
                if (!baSort.eq(bbSort)) {
                    IBackReference bref = new BackReference();
                    ModuleHelper.getBackReference(this.module, bref, null);
                    Map<IBaseExpression<ITrivialExtension>, String> sortRef = bref.getSortRef();
                    String baRef = sortRef.get(baSort);
                    String bbRef = sortRef.get(bbSort);
                    this.printErr_LeadingLine_Region(ctx.start, ctx.stop, "Following term has wrong type (" + baRef + "); expected: (" + bbRef + "):");
                    INamedTerm namedTerm = new NamedTerm(nonVariableTerm, this.termVariableContext);
                    IConstructionPPrint termConstructionPPrint = new TermConstructionPPrint(bref, namedTerm);
                    termConstructionPPrint.pprint(this.pprintBase);
                    this.pprintBase.printNewLine();
                }
            }
        }
    }

    @Override
    public void exitTermVariable(PelParser.TermVariableContext ctx) {
        IVariable<ITermNonVariableExtension> term = null;
        if (this.termSortCheckFlags.peek()) {
            String variableText = ctx.variable().getText();
            String baseVariableText = null;
            IBaseExpression<ITrivialExtension> sort = inStack.pop();
            if (sort == null) {
                this.printErr_LeadingLine_SingleToken(ctx.start, "no sort derivable from variable " + baseVariableText + ".");
            }
            {
                Matcher m = this.baseVarPattern.matcher(variableText);
                if (m.matches()) {
                    baseVariableText = m.group(1);
                    if (baseVariableText.equals("__")) {
                        baseVariableText = "_";
                    }
                    if (this.baseVars.containsKey(baseVariableText)) {
                        term = this.baseVars.get(baseVariableText);
                    } else {
                        term = this.termVariableContext.createVariable(sort, baseVariableText);
                        this.baseVars.put(baseVariableText, term);
                    }
                }
            }
            {
                Matcher m = this.indexedVarPattern.matcher(variableText);
                if (m.matches()) {
                    baseVariableText = m.group(1);
                    if (baseVariableText.equals("__")) {
                        baseVariableText = "_";
                    }
                    String indexText = m.group(2);
                    Integer index = Integer.parseInt(indexText);
                    Map<Integer, IVariable<ITermNonVariableExtension>> varIndex
                            = null;
                    if (this.indexedVars.containsKey(baseVariableText)) {
                        varIndex = this.indexedVars.get(baseVariableText);
                    } else {
                        varIndex = new ConcurrentHashMap<>();
                        this.indexedVars.put(baseVariableText, varIndex);
                    }
                    if (varIndex.containsKey(index)) {
                        term = varIndex.get(index);
                    } else {
                        term = this.termVariableContext.createVariable(sort, baseVariableText);
                        varIndex.put(index, term);
                    }
                }
            }
        }
        this.termStack.push(term);
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

    private IModule derefModule(PelParser.SymbolContext ctx) {
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
        return retval;
    }

    private INamedClause derefClause(PelParser.SymbolContext ctx) {
        List<Token> quals = ctx.quals;
        Token base = ctx.base;
        String baseText = base.getText();
        List<String> qualificator
                = Collections.synchronizedList(quals
                        .parallelStream()
                        .map(token -> token.getText())
                        .collect(Collectors.toList()));
        INamedClause retval = null;
        try {
            IModule baseModule = this.module.derefModule(qualificator).get();
            Map<String, INamedClause> axiomsMap = baseModule.getAxioms();
            if (axiomsMap.containsKey(baseText)) {
                retval = axiomsMap.get(baseText);
            } else {
                this.printErr_LeadingLine_SingleToken(base, "base " + baseText + " not found");
            }
        } catch (QualificatorException ex) {
            this.printErr_LeadingLine_Region(ctx.start, ctx.stop, ex.getMessage());
        }
        return retval;
    }

    private INamedLiteral derefLiteral(PelParser.SymbolContext ctx) {
        List<Token> quals = ctx.quals;
        Token base = ctx.base;
        String baseText = base.getText();
        List<String> qualificator
                = Collections.synchronizedList(quals
                        .parallelStream()
                        .map(token -> token.getText())
                        .collect(Collectors.toList()));
        INamedLiteral retval = null;
        try {
            IModule baseModule = this.module.derefModule(qualificator).get();
            Map<String, INamedLiteral> literalsMap = baseModule.getLiterals();
            if (literalsMap.containsKey(baseText)) {
                retval = literalsMap.get(baseText);
            } else {
                this.printErr_LeadingLine_SingleToken(base, "base " + baseText + " not found");
            }
        } catch (QualificatorException ex) {
            this.printErr_LeadingLine_Region(ctx.start, ctx.stop, ex.getMessage());
        }
        return retval;
    }

    private IOperationExpression derefOperation(PelParser.SymbolContext ctx) {
        List<Token> quals = ctx.quals;
        Token base = ctx.base;
        String baseText = base.getText();
        List<String> qualificator
                = Collections.synchronizedList(quals
                        .parallelStream()
                        .map(token -> token.getText())
                        .collect(Collectors.toList()));
        IOperationExpression retval = null;
        try {
            IModule baseModule = this.module.derefModule(qualificator).get();
            Map<String, IOperationExpression> operationsMap = baseModule.getOperations();
            if (operationsMap.containsKey(baseText)) {
                retval = operationsMap.get(baseText);
            } else {
                this.printErr_LeadingLine_SingleToken(base, "base " + baseText + " not found");
            }
        } catch (QualificatorException ex) {
            this.printErr_LeadingLine_Region(ctx.start, ctx.stop, ex.getMessage());
        }
        return retval;
    }

    private IPredicateExpression derefPredicate(PelParser.SymbolContext ctx) {
        List<Token> quals = ctx.quals;
        Token base = ctx.base;
        String baseText = base.getText();
        List<String> qualificator
                = Collections.synchronizedList(quals
                        .parallelStream()
                        .map(token -> token.getText())
                        .collect(Collectors.toList()));
        IPredicateExpression retval = null;
        try {
            IModule baseModule = this.module.derefModule(qualificator).get();
            Map<String, IPredicateExpression> predicatesMap = baseModule.getPredicates();
            if (predicatesMap.containsKey(baseText)) {
                retval = predicatesMap.get(baseText);
            } else {
                this.printErr_LeadingLine_SingleToken(base, "base " + baseText + " not found");
            }
        } catch (QualificatorException ex) {
            this.printErr_LeadingLine_Region(ctx.start, ctx.stop, ex.getMessage());
        }
        return retval;
    }

    private IBaseExpression<ITrivialExtension> derefSort(PelParser.SymbolContext ctx) {
        List<Token> quals = ctx.quals;
        Token base = ctx.base;
        String baseText = base.getText();
        List<String> qualificator
                = Collections.synchronizedList(quals
                        .parallelStream()
                        .map(token -> token.getText())
                        .collect(Collectors.toList()));
        IBaseExpression<ITrivialExtension> retval = null;
        try {
            IModule baseModule = this.module.derefModule(qualificator).get();
            Map<String, IBaseExpression<ITrivialExtension>> sortsMap = baseModule.getSorts();
            if (sortsMap.containsKey(baseText)) {
                retval = sortsMap.get(baseText);
            } else {
                this.printErr_LeadingLine_SingleToken(base, "base " + baseText + " not found");
            }
        } catch (QualificatorException ex) {
            this.printErr_LeadingLine_Region(ctx.start, ctx.stop, ex.getMessage());
        }
        return retval;
    }

    private INamedTerm derefTerm(PelParser.SymbolContext ctx) {
        List<Token> quals = ctx.quals;
        Token base = ctx.base;
        String baseText = base.getText();
        List<String> qualificator
                = Collections.synchronizedList(quals
                        .parallelStream()
                        .map(token -> token.getText())
                        .collect(Collectors.toList()));
        INamedTerm retval = null;
        try {
            IModule baseModule = this.module.derefModule(qualificator).get();
            Map<String, INamedTerm> termsMap = baseModule.getTerms();
            if (termsMap.containsKey(baseText)) {
                retval = termsMap.get(baseText);
            } else {
                this.printErr_LeadingLine_SingleToken(base, "base " + baseText + " not found");
            }
        } catch (QualificatorException ex) {
            this.printErr_LeadingLine_Region(ctx.start, ctx.stop, ex.getMessage());
        }
        return retval;
    }

}
