/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunifyfrontend1.antlr.impl;

import com.google.common.collect.BiMap;
import com.google.common.collect.Table;
import dom.jfischer.probeunify3.basic.ICheckVariableOccurence;
import dom.jfischer.probeunify3.basic.IClause;
import dom.jfischer.probeunify3.basic.ICopy;
import dom.jfischer.probeunify3.basic.ILeafCollecting;
import dom.jfischer.probeunify3.basic.INonVariable;
import dom.jfischer.probeunify3.basic.INonVariableXt;
import dom.jfischer.probeunify3.basic.ITNonVariableXt;
import dom.jfischer.probeunify3.basic.ITracker;
import dom.jfischer.probeunify3.basic.IUnification;
import dom.jfischer.probeunify3.basic.IVariable;
import dom.jfischer.probeunify3.basic.IVariableContext;
import dom.jfischer.probeunify3.basic.IXpr;
import dom.jfischer.probeunify3.basic.impl.Clause;
import dom.jfischer.probeunify3.basic.impl.NonVariable;
import dom.jfischer.probeunify3.basic.impl.TNonVariableXt;
import dom.jfischer.probeunify3.basic.impl.Variable;
import dom.jfischer.probeunify3.basic.impl.VariableContext;
import dom.jfischer.probeunify3.module.IModule;
import dom.jfischer.probeunify3.module.IModuleTracker;
import dom.jfischer.probeunify3.module.IObject;
import dom.jfischer.probeunify3.module.impl.Module;
import dom.jfischer.probeunify3.module.impl.ModuleTracker;
import dom.jfischer.probeunify3.module.impl.ObjectImpl;
import dom.jfischer.probeunifyfrontend1.antlr.IPELThisVisitor;
import dom.jfischer.probeunifyfrontend1.names.IOperationSignature;
import dom.jfischer.probeunifyfrontend1.names.IPELXt;
import dom.jfischer.probeunifyfrontend1.names.IPredicateSignature;
import dom.jfischer.probeunifyfrontend1.names.IVariableInfo;
import dom.jfischer.probeunifyfrontend1.names.IVariableNameInfo;
import dom.jfischer.probeunifyfrontend1.names.impl.OperationSignature;
import dom.jfischer.probeunifyfrontend1.names.impl.PELXt;
import dom.jfischer.probeunifyfrontend1.names.impl.PredicateSignature;
import dom.jfischer.probeunifyfrontend1.exceptions.QualificatorException;
import dom.jfischer.probeunifyfrontend1.names.IBaseSymbolBean;
import dom.jfischer.probeunifyfrontend1.names.IIndexedSymbolBean;
import dom.jfischer.probeunifyfrontend1.names.ITermVariableInfo;
import dom.jfischer.probeunifyfrontend1.names.impl.BaseSymbolBean;
import dom.jfischer.probeunifyfrontend1.names.impl.IndexedSymbolBean;
import dom.jfischer.probeunifyfrontend1.names.impl.VariableInfo;
import java.io.IOException;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.Token;

/**
 *
 * @author jfischer
 */
public class PELThisVisitor extends PelBaseVisitor<Object> implements
        IPELThisVisitor {

    private final IModule<IPELXt> module;
    private final String moduleName;
    private final IVariableInfo variableInfo;
    private final IVariableNameInfo variableNameInfo;
    private final ITermVariableInfo termVariableInfo;
    private final IVariableContext<ITNonVariableXt> variableContext;
    private final ICheckVariableOccurence<ITNonVariableXt, ITNonVariableXt> nonVariableXtVariableOccurenceChecker;
    private final ICopy<ITNonVariableXt, ITracker<IXpr<ITNonVariableXt>>> nonVariableXtCopy;
    private final ILeafCollecting<ITNonVariableXt, ITNonVariableXt> nonVariableXtLeafCollecting;
    private final IUnification<ITNonVariableXt> nonVariableXtUnification;
    private final ICopy<IXpr<ITNonVariableXt>, ITracker<IXpr<ITNonVariableXt>>> itemCopier;
    private final ICheckVariableOccurence<ITNonVariableXt, IXpr<ITNonVariableXt>> itemVariableOccurenceChecker;
    private final ICopy<IModule<IPELXt>, IModuleTracker<IPELXt>> moduleCopier;
    private final IUnification<IXpr<ITNonVariableXt>> itemUnification;
    private final IUnification<IModule<IPELXt>> moduleUnification;
    private final Map<String, IModule<IPELXt>> moduleRegister;
    private final IVariableContext<ITNonVariableXt> freeVariables;

    public PELThisVisitor(IModule<IPELXt> module, String moduleName, IVariableInfo variableInfo, IVariableNameInfo variableNameInfo, ITermVariableInfo termVariableInfo, IVariableContext<ITNonVariableXt> variableContext, ICheckVariableOccurence<ITNonVariableXt, ITNonVariableXt> nonVariableXtVariableOccurenceChecker, ICopy<ITNonVariableXt, ITracker<IXpr<ITNonVariableXt>>> nonVariableXtCopy, ILeafCollecting<ITNonVariableXt, ITNonVariableXt> nonVariableXtLeafCollecting, IUnification<ITNonVariableXt> nonVariableXtUnification, ICopy<IXpr<ITNonVariableXt>, ITracker<IXpr<ITNonVariableXt>>> itemCopier, ICheckVariableOccurence<ITNonVariableXt, IXpr<ITNonVariableXt>> itemVariableOccurenceChecker, ICopy<IModule<IPELXt>, IModuleTracker<IPELXt>> moduleCopier, IUnification<IXpr<ITNonVariableXt>> itemUnification, IUnification<IModule<IPELXt>> moduleUnification, Map<String, IModule<IPELXt>> moduleRegister) {
        this.module = module;
        this.moduleName = moduleName;
        this.variableInfo = variableInfo;
        this.variableNameInfo = variableNameInfo;
        this.termVariableInfo = termVariableInfo;
        this.variableContext = variableContext;
        this.nonVariableXtVariableOccurenceChecker = nonVariableXtVariableOccurenceChecker;
        this.nonVariableXtCopy = nonVariableXtCopy;
        this.nonVariableXtLeafCollecting = nonVariableXtLeafCollecting;
        this.nonVariableXtUnification = nonVariableXtUnification;
        this.itemCopier = itemCopier;
        this.itemVariableOccurenceChecker = itemVariableOccurenceChecker;
        this.moduleCopier = moduleCopier;
        this.itemUnification = itemUnification;
        this.moduleUnification = moduleUnification;
        this.moduleRegister = moduleRegister;
        this.freeVariables = new VariableContext<>(itemCopier);
    }

    @Override
    public Object visitProof(PelParser.ProofContext ctx) {
        List<PelParser.ClauseContext> clausesContext = ctx.clauses;
        clausesContext
                .parallelStream()
                .forEach(clause -> clause.variableContext = this.variableContext);
        clausesContext
                .parallelStream()
                .forEach(clause -> clause.variableInfo = this.variableInfo);
        Set<IClause> proof = clausesContext
                .stream()
                .map(clause -> this.visit(clause))
                .map(obj -> (IClause) obj)
                .collect(Collectors.toSet());
        return (Object) proof;
    }

    @Override
    public Object visitLogic(PelParser.LogicContext ctx) {
        visitChildren(ctx);
        this.moduleRegister.put(moduleName, this.module);
        return null;
    }

    @Override
    public Object visitModule_decl(PelParser.Module_declContext ctx) {
        Token qualToken = ctx.SymbolToken(0).getSymbol();
        String qualText = qualToken.getText();
        BiMap<String, IObject> qualMap = this.module.getXt().getQuals();
        if (qualMap.containsKey(qualText)) {
            printErr_LeadingLine_SingleToken(qualToken, "qual " + qualText + " already in use.");
        } else {
            Token baseModuleSymbol = ctx.SymbolToken(1).getSymbol();
            String baseModuleSymbolText = baseModuleSymbol.getText();
            try {
                IModule<IPELXt> templateModule
                        = this.getTemplateModule(baseModuleSymbolText);
                IModuleTracker<IPELXt> moduleTracker = new ModuleTracker<>();
                IModule<IPELXt> baseModule = this.moduleCopier.copy(moduleTracker, templateModule);
                IObject baseModuleObject = new ObjectImpl();
                qualMap.put(qualText, baseModuleObject);
                this.module.getImports().put(baseModuleObject, baseModule);
            } catch (IOException ex) {
                this.printErr_LeadingLine_Region(ctx.start, ctx.stop, "no module " + baseModuleSymbolText + " found.");
            }
        }
        return null;
    }

    @Override
    public Object visitModule_eq(PelParser.Module_eqContext ctx) {
        List<PelParser.SymbolContext> symbolContexts = ctx.symbol();
        List<IModule<IPELXt>> modules = symbolContexts
                .stream()
                .map(symbol -> this.visit(symbol))
                .map(outData -> (IModule<IPELXt>) ((Object[]) outData)[0])
                .collect(Collectors.toList());
        IModule<IPELXt> refModule = modules.get(0);
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
        BiMap<String, IObject> sortsMap
                = this.module.getXt().getSorts();
        if (sortsMap.containsKey(sortText)) {
            printErr_LeadingLine_SingleToken(sortToken, "sort " + sortText + " already in use.");
        } else {
            IObject sortObject = new ObjectImpl();
            sortsMap.put(sortText, sortObject);
            IXpr<INonVariableXt> sortXpr = new Variable<>();
            this.module.getCs().put(sortObject, sortXpr);
        }
        return null;
    }

    @Override
    public Object visitPredicate_decl(PelParser.Predicate_declContext ctx) {
        Token predicateToken = ctx.SymbolToken().getSymbol();
        String predicateText = predicateToken.getText();
        BiMap<String, IObject> predicatesMap
                = this.module.getXt().getPredicates();
        if (predicatesMap.containsKey(predicateText)) {
            printErr_LeadingLine_SingleToken(predicateToken, "predicate " + predicateText + " already in use.");
        } else {
            IObject predicateObject = new ObjectImpl();
            predicatesMap.put(predicateText, predicateObject);
            IXpr<INonVariableXt> predicateXpr = new Variable<>();
            this.module.getCs().put(predicateObject, predicateXpr);
            List<IXpr<INonVariableXt>> domainSortObjects = ctx.args
                    .stream()
                    .map(symbol -> (Object[]) this.visit(symbol))
                    .map(s -> this.derefSort(s))
                    .collect(Collectors.toList());
            IPredicateSignature predicateSignature
                    = new PredicateSignature(domainSortObjects);
            this.module.getXt().getPredicateSignatures().put(predicateObject, predicateSignature);
        }
        return null;
    }

    @Override
    public Object visitOperation_decl(PelParser.Operation_declContext ctx) {
        Token operationToken = ctx.SymbolToken().getSymbol();
        String operationText = operationToken.getText();
        BiMap<String, IObject> operationsMap
                = this.module.getXt().getOperations();
        if (operationsMap.containsKey(operationText)) {
            printErr_LeadingLine_SingleToken(operationToken, "operation " + operationText + " already in use.");
        } else {
            IObject operationObject = new ObjectImpl();
            operationsMap.put(operationText, operationObject);
            IXpr<INonVariableXt> operationXpr = new Variable<>();
            this.module.getCs().put(operationObject, operationXpr);
            List<IXpr<INonVariableXt>> domainSortObjects = ctx.lhs
                    .stream()
                    .map(symbol -> (Object[]) this.visit(symbol))
                    .map(s -> this.derefSort(s))
                    .collect(Collectors.toList());
            Object[] rangeSObject
                    = (Object[]) this.visit(ctx.rhs);
            IXpr<INonVariableXt> rangeSortObject
                    = this.derefSort(rangeSObject);
            IOperationSignature operationSignature
                    = new OperationSignature(
                            domainSortObjects,
                            rangeSortObject
                    );
            this.module.getXt().getOperationSignatures().put(operationObject, operationSignature);
        }
        return null;
    }

    @Override
    public Object visitAxiom_decl(PelParser.Axiom_declContext ctx) {
        Token axiomToken = ctx.SymbolToken().getSymbol();
        String axiomText = axiomToken.getText();
        BiMap<String, IObject> axiomsMap
                = this.module.getXt().getAxioms();
        if (axiomsMap.containsKey(axiomText)) {
            printErr_LeadingLine_SingleToken(axiomToken, "axiom " + axiomText + " already in use.");
        } else {
            IObject axiomObject = new ObjectImpl();
            axiomsMap.put(axiomText, axiomObject);
            PelParser.ClauseContext clauseContext = ctx.clause();
            clauseContext.variableContext = this.variableContext;
            clauseContext.variableInfo = this.variableInfo;
            IClause axiom = (IClause) this.visit(clauseContext);
            if (axiom != null) {
                this.module.getAxioms().put(axiomObject, axiom);
            }
        }
        return null;
    }

    @Override
    public Object visitLiteralVariable(PelParser.LiteralVariableContext ctx) {
        PelParser.Literal_variableContext literalVariableContext
                = ctx.literal_variable();
        literalVariableContext.variableContext = ctx.variableContext;
        literalVariableContext.variableInfo = ctx.variableInfo;
        return visitChildren(ctx);
    }

    @Override
    public Object visitTermVariable(PelParser.TermVariableContext ctx) {
        PelParser.Term_variableContext termVariableContext
                = ctx.term_variable();
        termVariableContext.expectedSort = ctx.expectedSort;
        termVariableContext.variableContext = ctx.variableContext;
        termVariableContext.variableInfo = ctx.variableInfo;
        return visitChildren(ctx);
    }

    @Override
    public Object visitLiteralExpression(PelParser.LiteralExpressionContext ctx) {
        PelParser.SymbolContext predicateSymbol = ctx.symbol();
        Object[] predicateVisit = (Object[]) this.visit(predicateSymbol);
        INonVariable<ITNonVariableXt> retval = null;
        IObject predicateObject = null;
        if (predicateVisit[0] != null) {
            predicateObject = this.derefPredicate(predicateVisit);
        }
        if (predicateObject != null) {
            IModule<IPELXt> baseModule = (IModule<IPELXt>) predicateVisit[0];
            IPredicateSignature predicateSignature
                    = baseModule.getXt().getPredicateSignatures().get(predicateObject);
            List<IXpr<INonVariableXt>> expectedDomainObject
                    = predicateSignature.getDomain();
            int expectedSize = expectedDomainObject.size();
            int realSize = ctx.args.size();
            if (expectedSize == realSize) {
                ctx.args
                        .parallelStream()
                        .forEach(arg -> arg.variableContext = ctx.variableContext);
                ctx.args
                        .parallelStream()
                        .forEach(arg -> arg.variableInfo = ctx.variableInfo);
                for (int i = 0; i < expectedSize; i++) {
                    ctx.args.get(i).expectedSort
                            = expectedDomainObject.get(i);
                }
                List<IXpr<ITNonVariableXt>> arguments = ctx.args
                        .stream()
                        .map(arg -> (IXpr<ITNonVariableXt>) this.visit(arg))
                        .collect(Collectors.toList());
                boolean argumentsOK = arguments
                        .parallelStream()
                        .allMatch(arg -> arg != null);
                if (argumentsOK) {
                    ITNonVariableXt nonVariableXt
                            = new TNonVariableXt(
                                    baseModule.getCs().get(predicateObject),
                                    arguments
                            );
                    retval = new NonVariable<>(
                            this.nonVariableXtVariableOccurenceChecker,
                            this.nonVariableXtLeafCollecting,
                            this.nonVariableXtUnification,
                            nonVariableXt
                    );
                }
            } else {
                String predicateName
                        = baseModule.getXt().getPredicates().inverse().get(predicateObject);
                this.printErr_LeadingLine_Region(ctx.start, ctx.stop, "" + expectedSize + " args expected for " + predicateName + ".  " + realSize + " found.");
            }
        }

        return (Object) retval;
    }

    @Override
    public Object visitTermExpression(PelParser.TermExpressionContext ctx) {
        PelParser.SymbolContext operationSymbol = ctx.symbol();
        Object[] operationVisit = (Object[]) this.visit(operationSymbol);

        INonVariable<ITNonVariableXt> retval = null;
        IObject operationObject = null;
        if (operationVisit[0] != null) {
            operationObject = this.derefOperation(operationVisit);
        }
        if (operationObject != null) {
            IModule<IPELXt> baseModule = (IModule<IPELXt>) operationVisit[0];
            IOperationSignature operationSignature
                    = baseModule.getXt().getOperationSignatures().get(operationObject);
            IXpr<INonVariableXt> expectedRange
                    = operationSignature.getRange();
            List<IXpr<INonVariableXt>> expectedDomainObject
                    = operationSignature.getDomain();
            int expectedSize = expectedDomainObject.size();
            int realSize = ctx.args.size();
            boolean errorMode = expectedSize != realSize;
            if (!expectedRange.eq(ctx.expectedSort)) {
                errorMode = true;
                this.printErr_LeadingLine_Region(ctx.start, ctx.stop, "arg having other sort expected.");
            }
            if (!errorMode) {
                ctx.args
                        .parallelStream()
                        .forEach(arg -> arg.variableContext = ctx.variableContext);
                ctx.args
                        .parallelStream()
                        .forEach(arg -> arg.variableInfo = ctx.variableInfo);
                for (int i = 0; i < expectedSize; i++) {
                    ctx.args.get(i).expectedSort
                            = expectedDomainObject.get(i);
                }
                List<IXpr<ITNonVariableXt>> arguments = ctx.args
                        .stream()
                        .map(arg -> (IXpr<ITNonVariableXt>) this.visit(arg))
                        .collect(Collectors.toList());
                boolean argumentsOK = arguments
                        .parallelStream()
                        .allMatch(arg -> arg != null);
                if (argumentsOK) {
                    ITNonVariableXt nonVariableXt
                            = new TNonVariableXt(
                                    baseModule.getCs().get(operationObject),
                                    arguments
                            );
                    retval = new NonVariable<>(
                            this.nonVariableXtVariableOccurenceChecker,
                            this.nonVariableXtLeafCollecting,
                            this.nonVariableXtUnification,
                            nonVariableXt
                    );
                }
            } else {
                String operationName
                        = baseModule.getXt().getOperations().inverse().get(operationObject);
                this.printErr_LeadingLine_Region(ctx.start, ctx.stop, "" + expectedSize + " args expected for " + operationName + ".  " + realSize + " found.");
            }
        }

        return (Object) retval;
    }

    @Override
    public Object visitAxiomConstant(PelParser.AxiomConstantContext ctx) {
        PelParser.SymbolContext symbol = ctx.symbol();
        Object[] axiomConstantVisit = (Object[]) this.visit(symbol);

        IClause retval = null;

        if (axiomConstantVisit[0] != null && axiomConstantVisit[1] != null) {
            IModule<IPELXt> baseModule = (IModule<IPELXt>) axiomConstantVisit[0];
            IObject axiomConstantObject = (IObject) axiomConstantVisit[1];
            if (baseModule.getAxioms().containsKey(axiomConstantObject)) {
                retval = baseModule.getAxioms().get(axiomConstantObject);
            } else {
                String axiomName = baseModule.getXt().getAxioms().inverse().get(axiomConstantObject);
                this.printErr_LeadingLine_Region(ctx.start, ctx.stop, "axiom " + axiomName + " not declared.");
            }
        }

        return (Object) retval;
    }

    @Override
    public Object visitAxiomExpression(PelParser.AxiomExpressionContext ctx) {
        PelParser.Variable_ctxContext variable_ctxContext
                = ctx.variable_ctx();
        Set<IVariable<ITNonVariableXt>> variables
                = Collections.synchronizedSet(new HashSet());
        IVariableContext<ITNonVariableXt> nextLevelVariableContext
                = new VariableContext<>(
                        ctx.variableContext,
                        variables,
                        this.itemCopier
                );
        IVariableInfo nextLevelVariableInfo
                = new VariableInfo(
                        ctx.variableInfo
                );
        variable_ctxContext.variableContext = nextLevelVariableContext;
        variable_ctxContext.variableInfo = nextLevelVariableInfo;
        this.visit(variable_ctxContext);
        PelParser.LiteralContext conclusionContext
                = ctx.conclusion;
        conclusionContext.variableContext = nextLevelVariableContext;
        conclusionContext.variableInfo = nextLevelVariableInfo;
        IXpr<ITNonVariableXt> conclusion
                = (IXpr<ITNonVariableXt>) this.visit(conclusionContext);
        List<PelParser.ClauseContext> premisesContextList
                = ctx.premises;
        premisesContextList
                .parallelStream()
                .forEach(premiseContext -> premiseContext.variableContext = nextLevelVariableContext);
        premisesContextList
                .parallelStream()
                .forEach(premiseContext -> premiseContext.variableInfo = nextLevelVariableInfo);

        List<IClause> premises = premisesContextList
                .stream()
                .map(premiseContext -> (IClause) this.visit(premiseContext))
                .collect(Collectors.toList());
        boolean premisesOK = premises
                .parallelStream()
                .allMatch(premise -> premise != null);

        IClause retval = null;
        if (conclusion != null && premisesOK) {
            retval = new Clause(nextLevelVariableContext, premises, conclusion);
        }

        return (Object) retval;
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
            IModule<IPELXt> retModule = null;
            try {
                retModule = this.derefModule(qualificator);
            } catch (QualificatorException ex) {
                this.printErr_LeadingLine_Region(quals.get(0), quals.get(quals.size() - 1), ex.getMessage());
            }

            outData[0] = (Object) retModule;
        }
        outData[1] = (Object) ctx.base;
        return (Object) outData;

    }

    @Override
    public Object visitLiteralBaseVariable(PelParser.LiteralBaseVariableContext ctx) {
        IVariable<ITNonVariableXt> retval = null;

        IBaseSymbolBean symbolBean = new BaseSymbolBean();
        if (symbolBean.parseName(ctx.getText())) {
            String symbol = symbolBean.getSymbol();
            retval = ctx.variableInfo.lookupBaseVars(symbolBean);
            if (retval == null) {
// free variables.
                Map<String, IVariableContext<ITNonVariableXt>> baseCtxMap
                        = ctx.variableInfo.getBaseCtx();
                baseCtxMap.put(symbolBean.getSymbol(), this.freeVariables);
                retval = ctx.variableInfo.createBaseVar(symbolBean);
                this.variableNameInfo.addVariable(symbol, retval);
            }
        }

        return (Object) retval;
    }

    @Override
    public Object visitLiteralIndexedVariable(PelParser.LiteralIndexedVariableContext ctx) {
        IVariable<ITNonVariableXt> retval = null;

        IIndexedSymbolBean symbolBean = new IndexedSymbolBean();
        if (symbolBean.parseName(ctx.getText())) {
            String symbol = symbolBean.getSymbol();
            retval = ctx.variableInfo.lookupIndexedVars(symbolBean);
            if (retval == null) {
// free variables.
                Table<String, Integer, IVariableContext<ITNonVariableXt>> indexedCtxMap
                        = ctx.variableInfo.getIndexedCtx();
                indexedCtxMap.put(symbolBean.getSymbol(), symbolBean.getIndex(), this.freeVariables);
                retval = ctx.variableInfo.createIndexedVar(symbolBean);
                this.variableNameInfo.addVariable(symbol, retval);
            }
        }

        return (Object) retval;
    }

    @Override
    public Object visitTermBaseVariable(PelParser.TermBaseVariableContext ctx) {
        IVariable<ITNonVariableXt> retval = null;
        IBaseSymbolBean symbolBean = new BaseSymbolBean();

        if (symbolBean.parseName(ctx.getText())) {
            String symbol = symbolBean.getSymbol();
            retval = ctx.variableInfo.lookupBaseVars(symbolBean);
            Map<IVariable<ITNonVariableXt>, IXpr<INonVariableXt>> sortsMap
                    = this.termVariableInfo.getSorts();
            if (retval == null) {
// free variables.
                Map<String, IVariableContext<ITNonVariableXt>> baseCtxMap
                        = ctx.variableInfo.getBaseCtx();
                baseCtxMap.put(symbolBean.getSymbol(), this.freeVariables);
                retval = ctx.variableInfo.createBaseVar(symbolBean);
                this.variableNameInfo.addVariable(symbol, retval);
                sortsMap.put(retval, ctx.expectedSort);
            } else if (!sortsMap.containsKey(retval)) {
                sortsMap.put(retval, ctx.expectedSort);
            } else if (!ctx.expectedSort.eq(sortsMap.get(retval))) {
                this.printErr_LeadingLine_Region(ctx.start, ctx.stop, "variable " + ctx.getText() + " introduced with other sort");
            }
        }

        return (Object) retval;
    }

    @Override
    public Object visitTermIndexedVariable(PelParser.TermIndexedVariableContext ctx) {
        IVariable<ITNonVariableXt> retval = null;

        IIndexedSymbolBean symbolBean = new IndexedSymbolBean();
        if (symbolBean.parseName(ctx.getText())) {
            String symbol = symbolBean.getSymbol();
            retval = ctx.variableInfo.lookupIndexedVars(symbolBean);
            Map<IVariable<ITNonVariableXt>, IXpr<INonVariableXt>> sortsMap
                    = this.termVariableInfo.getSorts();
            if (retval == null) {
// free variables.
                Table<String, Integer, IVariableContext<ITNonVariableXt>> indexedCtxMap
                        = ctx.variableInfo.getIndexedCtx();
                indexedCtxMap.put(symbolBean.getSymbol(), symbolBean.getIndex(), this.freeVariables);
                retval = ctx.variableInfo.createIndexedVar(symbolBean);
                this.variableNameInfo.addVariable(symbol, retval);
                sortsMap.put(retval, ctx.expectedSort);
            } else if (!sortsMap.containsKey(retval)) {
                sortsMap.put(retval, ctx.expectedSort);
            } else if (!ctx.expectedSort.eq(sortsMap.get(retval))) {
                this.printErr_LeadingLine_Region(ctx.start, ctx.stop, "variable " + ctx.getText() + " introduced with other sort");
            }
        }

        return (Object) retval;
    }

    @Override
    public Object visitVariable_ctx(PelParser.Variable_ctxContext ctx) {
        ctx.args
                .parallelStream()
                .forEach(arg -> arg.variableContext = ctx.variableContext);
        ctx.args
                .parallelStream()
                .forEach(arg -> arg.variableInfo = ctx.variableInfo);
        this.visitChildren(ctx);
        return null;
    }

    @Override
    public Object visitCtxBaseVariable(PelParser.CtxBaseVariableContext ctx) {
        IBaseSymbolBean symbolBean = new BaseSymbolBean();

        if (symbolBean.parseName(ctx.getText())) {
            Map<String, IVariableContext<ITNonVariableXt>> baseCtxMap
                    = ctx.variableInfo.getBaseCtx();
            baseCtxMap.put(symbolBean.getSymbol(), ctx.variableContext);
            IVariable<ITNonVariableXt> variable = ctx.variableInfo.createBaseVar(symbolBean);
            this.variableNameInfo.addVariable(symbolBean.getSymbol(), variable);
        }

        return null;
    }

    @Override
    public Object visitCtxIndexedVariable(PelParser.CtxIndexedVariableContext ctx) {
        IIndexedSymbolBean symbolBean = new IndexedSymbolBean();

        if (symbolBean.parseName(ctx.getText())) {
            Table<String, Integer, IVariableContext<ITNonVariableXt>> indexedCtxMap
                    = ctx.variableInfo.getIndexedCtx();
            indexedCtxMap.put(symbolBean.getSymbol(), symbolBean.getIndex(), ctx.variableContext);
            IVariable<ITNonVariableXt> variable = ctx.variableInfo.createIndexedVar(symbolBean);
            this.variableNameInfo.addVariable(symbolBean.getSymbol(), variable);
        }

        return null;
    }

    private PELThisVisitor copyVisitor(IModule<IPELXt> module, String moduleName) {
        return new PELThisVisitor(
                module,
                moduleName,
                this.variableInfo,
                this.variableNameInfo,
                this.termVariableInfo,
                this.variableContext,
                this.nonVariableXtVariableOccurenceChecker,
                this.nonVariableXtCopy,
                this.nonVariableXtLeafCollecting,
                this.nonVariableXtUnification,
                this.itemCopier,
                this.itemVariableOccurenceChecker,
                this.moduleCopier,
                this.itemUnification,
                this.moduleUnification,
                this.moduleRegister
        );
    }

    private IModule<IPELXt> derefModule(List<String> qualificator) throws QualificatorException {
        IModule<IPELXt> retval = this.module;

        for (String qualItem : qualificator) {
            BiMap<String, IObject> qualMap = retval.getXt().getQuals();
            if (qualMap.containsKey(qualItem)) {
                IObject qual = qualMap.get(qualItem);
                Map<IObject, IModule<IPELXt>> importsMap = retval.getImports();
                if (importsMap.containsKey(qual)) {
                    retval = importsMap.get(qual);
                } else {
                    throw new QualificatorException();
                }
            } else {
                throw new QualificatorException();
            }
        }

        return retval;
    }

    private IObject derefOperation(Object[] visit) {
        IModule<IPELXt> baseModule = (IModule<IPELXt>) visit[0];
        Token base = (Token) visit[1];
        String baseText = base.getText();

        BiMap<String, IObject> operationsMap = baseModule.getXt().getOperations();
        IObject retval = null;
        if (operationsMap.containsKey(baseText)) {
            retval = operationsMap.get(baseText);
        } else {
            this.printErr_LeadingLine_SingleToken(base, "base " + baseText + " not found");
        }
        return retval;
    }

    private IObject derefPredicate(Object[] visit) {
        IModule<IPELXt> baseModule = (IModule<IPELXt>) visit[0];
        Token base = (Token) visit[1];
        String baseText = base.getText();

        BiMap<String, IObject> predicatesMap = baseModule.getXt().getPredicates();
        IObject retval = null;
        if (predicatesMap.containsKey(baseText)) {
            retval = predicatesMap.get(baseText);
        } else {
            this.printErr_LeadingLine_SingleToken(base, "base " + baseText + " not found");
        }
        return retval;
    }

    private IXpr<INonVariableXt> derefSort(Object[] visit) {
        IModule<IPELXt> baseModule = (IModule<IPELXt>) visit[0];
        Token base = (Token) visit[1];
        String baseText = base.getText();

        BiMap<String, IObject> sortsMap = baseModule.getXt().getSorts();
        IXpr<INonVariableXt> retval = null;
        if (sortsMap.containsKey(baseText)) {
            IObject sortObject = sortsMap.get(baseText);
            retval = baseModule.getCs().get(sortObject);
        } else {
            this.printErr_LeadingLine_SingleToken(base, "base " + baseText + " not found");
        }
        return retval;
    }

    private IXpr<INonVariableXt> derefSymbol(IModule<IPELXt> baseModule, IObject symbol) {
        Map<IObject, IXpr<INonVariableXt>> cMap = baseModule.getCs();
        IXpr<INonVariableXt> retval = null;

        if (cMap.containsKey(symbol)) {
            retval = cMap.get(symbol).dereference();
        }

        return retval;
    }

    private IModule<IPELXt> getTemplateModule(String name) throws IOException {
        IModule<IPELXt> retval = null;

        if (this.moduleRegister.containsKey(name)) {
            retval = this.moduleRegister.get(name);
        } else {
            IPELXt templateModulePelXt = new PELXt();
            retval = new Module<>(templateModulePelXt);
            CharStream templateModuleCharStream
                    = AntlrHelper.getLogicCharStream(name);
            PELThisVisitor templateModuleVisitor = copyVisitor(retval, name);
            AntlrHelper.parseLogics(templateModuleCharStream, templateModuleVisitor);
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
