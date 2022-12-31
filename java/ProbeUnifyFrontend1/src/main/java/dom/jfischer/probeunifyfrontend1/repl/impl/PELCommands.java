/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunifyfrontend1.repl.impl;

import dom.jfischer.probeunifyfrontend1.exceptions.QualificatorException;
import dom.jfischer.probeunifyfrontend1.repl.IState;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import org.jline.builtins.Options;
import org.jline.console.CommandInput;
import org.jline.console.CommandMethods;
import org.jline.console.impl.JlineCommandRegistry;

import org.jline.console.CommandRegistry;

/**
 *
 * @author jfischer
 */
public class PELCommands extends JlineCommandRegistry implements CommandRegistry {
    
    private final IState proofState;
    
    public PELCommands(IState proofState) {
        this.proofState = proofState;
        
        {
            Map<String, CommandMethods> commandsMap = new ConcurrentHashMap<>();
            
            commandsMap.put("apply", new CommandMethods(this::apply, this::defaultCompleter));
            commandsMap.put("assume", new CommandMethods(this::assume, this::defaultCompleter));
            commandsMap.put("resolve", new CommandMethods(this::resolve, this::defaultCompleter));
            commandsMap.put("save", new CommandMethods(this::save, this::defaultCompleter));
            commandsMap.put("saveState", new CommandMethods(this::saveState, this::defaultCompleter));
            commandsMap.put("showAssumptions", new CommandMethods(this::showAssumptions, this::defaultCompleter));
            commandsMap.put("undo", new CommandMethods(this::undo, this::defaultCompleter));
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
                
                if (!this.proofState.checkGoalNr(goalNr - 1)) {
                    System.err.println("first parameter in assume out of range.");
                    errorMode = true;
                } else if (!this.proofState.checkPremiseNr(goalNr - 1, premiseNr - 1)) {
                    System.err.println("second parameter in assume out of range.");
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
                    if (!errorMode && !this.proofState.resolve(goalNr - 1, args.get(1))) {
                        System.err.println("could not be unified.");
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
    
    private void showAssumptions(CommandInput input) {
        String[] usage = {
            "showAssumptions - show assumptions",
            "Usage: showAssumptions [goalNr]",
            "  -? --help                       Displays command help"
        };
        try {
            Options opt = parseOptions(usage, input.xargs());
            List<String> args = opt.args();
            if (args.size() != 1) {
                System.err.println("showAssumptions takes one parameter. " + args.size() + " given.");
            } else {
                Integer goalNr = Integer.parseInt(args.get(0));
                boolean errorMode = false;
                if (!this.proofState.checkGoalNr(goalNr - 1)) {
                    System.err.println("first parameter in showAssumptions out of range.");
                    errorMode = true;
                }
                if (!errorMode) {
                    this.proofState.printAssumptions(goalNr - 1);
                }
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
    
}
