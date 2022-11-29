/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.jline.impl;

import dom.jfischer.probeunify2.IState;
import dom.jfischer.probeunify2.exception.QualificatorException;
import dom.jfischer.probeunify2.pel.INamedClause;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;
import org.jline.builtins.Options;
import org.jline.console.CommandInput;
import org.jline.console.CommandMethods;
import org.jline.console.impl.JlineCommandRegistry;

import org.jline.console.CommandRegistry;
import org.jline.reader.Completer;
import org.jline.reader.impl.completer.NullCompleter;
import org.jline.reader.impl.completer.StringsCompleter;

/**
 *
 * @author jfischer
 */
public class PelCommands extends JlineCommandRegistry implements CommandRegistry {

    private final IState proofState;

    public PelCommands(IState proofState) {
        super();

        this.proofState = proofState;

        {
            Map<String, CommandMethods> commandsMap = new ConcurrentHashMap<>();
            commandsMap.put("apply", new CommandMethods(this::apply, this::applyCompleter));
            commandsMap.put("aa", new CommandMethods(this::assumeAll, this::defaultCompleter));
            commandsMap.put("assume", new CommandMethods(this::assume, this::assumeCompleter));
            commandsMap.put("resolve", new CommandMethods(this::resolve, this::resolveCompleter));
            commandsMap.put("save", new CommandMethods(this::save, this::saveCompleter));
            commandsMap.put("ss", new CommandMethods(this::saveState, this::defaultCompleter));
            commandsMap.put("undo", new CommandMethods(this::undo, this::undoCompleter));
            commandsMap.put("vars", new CommandMethods(this::vars, this::defaultCompleter));
            this.registerCommands(commandsMap);
        }
    }

    private void apply(CommandInput input) {
        String[] usage = {
            "apply - apply proof",
            "Usage: apply [goal] [proof]",
            "  -? --help                       Displays command help"
        };
        try {
            Options opt = parseOptions(usage, input.xargs());
            List<String> args = opt.args();
            if (args.size() != 2) {
                System.err.println("apply takes 2 parameters. " + args.size() + " given.");
            } else {
                Integer goalNr = Integer.parseInt(args.get(0));
                boolean errorMode = false;
                if (!this.proofState.checkGoalNr(goalNr - 1)) {
                    System.err.println("first parameter in apply out of range.");
                    errorMode = true;
                }
                if (!errorMode) {
                    String proofName = args.get(1);
                    try {
                        this.proofState.apply(goalNr - 1, proofName);
                    } catch (IOException ex) {
                        System.err.println("problem during reading proof " + proofName + ": " + ex.getMessage());
                    }
                }
            }
        } catch (Options.HelpException ex) {
            System.err.println("help exception: " + ex.getMessage());
        }
    }

    private void assume(CommandInput input) {
        String[] usage = {
            "assume - apply premise",
            "Usage: assume [goal] [premise]",
            "  -? --help                       Displays command help"
        };
        try {
            Options opt = parseOptions(usage, input.xargs());
            List<String> args = opt.args();
            if (args.size() != 2) {
                System.err.println("assume takes 2 parameters. " + args.size() + " given.");
            } else {
                Integer premiseNr = Integer.parseInt(args.get(1));
                Integer goalNr = Integer.parseInt(args.get(0));
                boolean errorMode = false;
                if (!this.proofState.checkPremiseNr(premiseNr - 1)) {
                    System.err.println("second parameter in assume out of range.");
                    errorMode = true;
                }
                if (!this.proofState.checkGoalNr(goalNr - 1)) {
                    System.err.println("first parameter in assume out of range.");
                    errorMode = true;
                }
                if (!errorMode && !this.proofState.assume(goalNr - 1, premiseNr - 1)) {
                    System.err.println("could not be unified.");
                }
            }
        } catch (Options.HelpException ex) {
            System.err.println("help exception: " + ex.getMessage());
        }
    }

    private void assumeAll(CommandInput input) {
        String[] usage = {
            "aa - apply as much premises as possible",
            "Usage: aa",
            "  -? --help                       Displays command help"
        };
        try {
            Options opt = parseOptions(usage, input.xargs());
            List<String> args = opt.args();
            if (args.size() != 0) {
                System.err.println("aa does not take any parameter. " + args.size() + " given.");
            } else {
                this.proofState.assumeAll();
            }
        } catch (Options.HelpException ex) {
            System.err.println("help exception: " + ex.getMessage());
        }
    }

    private void resolve(CommandInput input) {
        String[] usage = {
            "resolve - apply axiom",
            "Usage: resolve [goal] [axiom]",
            "  -? --help                       Displays command help"
        };
        try {
            Options opt = parseOptions(usage, input.xargs());
            List<String> args = opt.args();
            if (args.size() != 2) {
                System.err.println("resolve takes 2 parameters. " + args.size() + " given.");
            } else {
                Integer goalNr = Integer.parseInt(args.get(0));
                boolean errorMode = false;
                if (!this.proofState.checkGoalNr(goalNr - 1)) {
                    System.err.println("first parameter in resolve out of range.");
                    errorMode = true;
                }
                try {
                    Optional<INamedClause> optNamedClause
                            = this.proofState.parseClauseSelector(args.get(1));
                    if (optNamedClause.isPresent()) {
                        INamedClause namedClause
                                = optNamedClause.get();
                        if (!errorMode && !this.proofState.resolve(goalNr - 1, namedClause)) {
                            System.err.println("could not be unified.");
                        }
                    } else {
                        System.err.println(args.get(1) + " does not point to an axiom.");
                    }
                } catch (QualificatorException ex) {
                    System.err.println(args.get(1) + " does not point to a module.");
                }
            }
        } catch (Options.HelpException ex) {
            System.err.println("help exception: " + ex.getMessage());
        }
    }

    private void save(CommandInput input) {
        String[] usage = {
            "save - save proof",
            "Usage: save [proof]",
            "  -? --help                       Displays command help"
        };
        try {
            Options opt = parseOptions(usage, input.xargs());
            List<String> args = opt.args();
            if (args.size() != 1) {
                System.err.println("save takes one parameter. " + args.size() + " given.");
            } else {
                String proofName = args.get(0);
                try {
                    this.proofState.save(proofName);
                } catch (FileNotFoundException ex) {
                    System.err.println("problem during save operation: " + ex.getMessage());
                }
            }
        } catch (Options.HelpException ex) {
            System.err.println("help exception: " + ex.getMessage());
        }
    }

    private void saveState(CommandInput input) {
        String[] usage = {
            "ss - save program state",
            "Usage: ss",
            "  -? --help                       Displays command help"
        };
        try {
            Options opt = parseOptions(usage, input.xargs());
            List<String> args = opt.args();
            if (args.size() != 0) {
                System.err.println("aa does not take any parameter. " + args.size() + " given.");
            } else {
                this.proofState.saveState();
            }
        } catch (Options.HelpException ex) {
            System.err.println("help exception: " + ex.getMessage());
        }
    }

    private void undo(CommandInput input) {
        String[] usage = {
            "undo - bring back former proof steps",
            "Usage: undo [proof step]",
            "  -? --help                       Displays command help"
        };
        try {
            Options opt = parseOptions(usage, input.xargs());
            List<String> args = opt.args();
            if (args.size() != 1) {
                System.err.println("undo takes 1 parameters. " + args.size() + " given.");
            } else {
                Integer proofStepNr = Integer.parseInt(args.get(0));
                boolean errorMode = false;
                if (!this.proofState.checkProofStepNr(proofStepNr - 1)) {
                    System.err.println("first parameter in undo out of range.");
                    errorMode = true;
                }
                if (!errorMode) {
                    this.proofState.undo(proofStepNr - 1);
                }
            }
        } catch (Options.HelpException ex) {
            System.err.println("help exception: " + ex.getMessage());
        }
    }

    private void vars(CommandInput input) {
        String[] usage = {
            "vars - assignment of term variables",
            "Usage: vars",
            "  -? --help                       Displays command help"
        };
        try {
            Options opt = parseOptions(usage, input.xargs());
            List<String> args = opt.args();
            if (!args.isEmpty()) {
                System.err.println("do not call vars command with args!");
            } else {
                this.proofState.printVariables();
            }
        } catch (Options.HelpException ex) {
            System.err.println("help exception: " + ex.getMessage());
        }
    }

    private List<Completer> applyCompleter(String command) {
        List<Completer> retval = new ArrayList<>();
        retval.add(NullCompleter.INSTANCE);
        retval.add(NullCompleter.INSTANCE);
        return retval;
    }

    private List<Completer> assumeCompleter(String command) {
        List<Completer> retval = new ArrayList<>();
        retval.add(NullCompleter.INSTANCE);
        retval.add(NullCompleter.INSTANCE);
        return retval;
    }

    private List<Completer> resolveCompleter(String command) {
        Set<String> axioms
                = Collections.synchronizedSet(this.proofState.getBackReference().getAxiomRef().values()
                        .parallelStream()
                        .collect(Collectors.toSet()));
        List<Completer> retval = new ArrayList<>();
        retval.add(NullCompleter.INSTANCE);
        retval.add(new StringsCompleter(axioms));
        return retval;
    }

    private List<Completer> saveCompleter(String command) {
        List<Completer> retval = new ArrayList<>();
        retval.add(NullCompleter.INSTANCE);
        return retval;
    }

    private List<Completer> undoCompleter(String command) {
        List<Completer> retval = new ArrayList<>();
        retval.add(NullCompleter.INSTANCE);
        return retval;
    }

}
