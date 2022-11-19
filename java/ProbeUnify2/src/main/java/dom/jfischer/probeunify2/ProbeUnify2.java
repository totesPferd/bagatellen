/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Project/Maven2/JavaApp/src/main/java/${packagePath}/${mainClassName}.java to edit this template
 */
package dom.jfischer.probeunify2;

import dom.jfischer.probeunify2.antlr.impl.AntlrHelper;
import dom.jfischer.probeunify2.antlr.impl.PelThisListener;
import dom.jfischer.probeunify2.jline.impl.PelCommands;
import dom.jfischer.probeunify2.module.IModule;
import dom.jfischer.probeunify2.module.INamedClause;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.function.Supplier;
import net.sourceforge.argparse4j.ArgumentParsers;
import net.sourceforge.argparse4j.impl.Arguments;
import net.sourceforge.argparse4j.inf.ArgumentParser;
import net.sourceforge.argparse4j.inf.ArgumentParserException;
import net.sourceforge.argparse4j.inf.Namespace;
import net.sourceforge.argparse4j.inf.Subparser;
import net.sourceforge.argparse4j.inf.Subparsers;
import org.antlr.v4.runtime.CharStream;
import org.jline.builtins.ConfigurationPath;
import org.jline.console.ConsoleEngine;
import org.jline.console.Printer;
import org.jline.console.impl.Builtins;
import org.jline.console.impl.ConsoleEngineImpl;
import org.jline.console.impl.DefaultPrinter;
import org.jline.console.impl.SystemRegistryImpl;
import org.jline.reader.EndOfFileException;
import org.jline.reader.LineReader;
import org.jline.reader.LineReaderBuilder;
import org.jline.reader.Parser;
import org.jline.reader.UserInterruptException;
import org.jline.reader.impl.DefaultParser;
import org.jline.script.GroovyCommand;
import org.jline.script.GroovyEngine;
import org.jline.terminal.Terminal;
import org.jline.terminal.Terminal.SignalHandler;
import org.jline.terminal.TerminalBuilder;

/**
 *
 * @author jfischer
 */
public class ProbeUnify2 {

    private final static String PROGRAM_VERSION = "${prog} 0.1.0";
    private final static String PROMPT = "pel--> ";
    private final static ICmdline CMDLINE = new Cmdline();
    private final static IStatePersistence STATE_PERSISTENCE = new StatePersistence();

    private static void parseModulefile(String moduleName) {
        IModule module = CMDLINE.getModule();
        CMDLINE.setModuleName(moduleName);
        PelThisListener pelThisListener = new PelThisListener(module, moduleName);
        try {
            CharStream charStream = AntlrHelper.getLogicCharStream(moduleName);
            AntlrHelper.parseLogic(pelThisListener, charStream);
        } catch (IOException ex) {
            System.err.println("module " + moduleName + " could not be read: " + ex.getMessage());
            System.exit(2);
        }
    }

    private static void parseConjecture(String conjectureString) {
        IModule module = CMDLINE.getModule();
        PelThisListener pelThisListener = new PelThisListener(module, "<cmdline>");
        pelThisListener.resetTermVariableContext();
        INamedClause conjecture = AntlrHelper.getClause(pelThisListener, conjectureString);
        CMDLINE.setConjecture(conjecture);
    }

    private static void parseCmdline(String[] args) {
        ArgumentParser argumentParser
                = ArgumentParsers.newFor("pel")
                        .build()
                        .version(PROGRAM_VERSION);
        argumentParser.addArgument("--version")
                .action(Arguments.version())
                .help("prints program version");

        Subparsers subparsers
                = argumentParser.addSubparsers()
                        .dest("subcommand")
                        .help("choose a subcommand");

        {
            Subparser proofCommand
                    = subparsers.addParser("proof")
                            .help("start a proof");

            proofCommand.addArgument("m")
                    .required(true)
                    .type(String.class)
                    .help("pel module");

            proofCommand.addArgument("c")
                    .required(true)
                    .type(String.class)
                    .help("conjecture");
        }
        {
            Subparser continueCommand
                    = subparsers.addParser("continue")
                            .help("continue proofing");
        }

        Namespace cmdlineArgs;
        try {
            cmdlineArgs = argumentParser.parseArgs(args);
            String subcommandStr = cmdlineArgs.getString("subcommand");
            IState state =  null;
            switch (subcommandStr) {
                case "continue":
                    state = STATE_PERSISTENCE.restore();
                    if (state == null) {
                        System.exit(2);
                    } else {
                        CMDLINE.setState(state);
                    }
                    break;
                case "proof":
                    parseModulefile(cmdlineArgs.getString("m"));
                    parseConjecture(cmdlineArgs.getString("c"));
                    state =  CMDLINE.getState();
                    state.addProofStep();
                    break;
                default:
                    System.err.println("command " + subcommandStr + " not found");
                    System.exit(2);
            }
        } catch (ArgumentParserException ex) {
            System.err.println("cmdline problem: " + ex.getMessage());
            System.exit(2);
        }

    }

    private static void repLoop(IState state) {
        state.printProofState();

        Supplier<Path> workDir = () -> Paths.get(System.getProperty("user.dir"));
        String configDirName = workDir.get().toAbsolutePath().toString();
        ConfigurationPath configPath = new ConfigurationPath(Paths.get(configDirName), Paths.get(configDirName));
        Parser parser = new DefaultParser();
        PelCommands pelCommands = new PelCommands(state);
        GroovyEngine scriptEngine = new GroovyEngine();
        scriptEngine.put("ROOT", configDirName);
        Printer printer = new DefaultPrinter(scriptEngine, configPath);

        try {
            ConsoleEngine consoleEngine = new ConsoleEngineImpl(
                    scriptEngine,
                    printer,
                    workDir, configPath);
            Builtins builtins
                    = new Builtins(
                            workDir,
                            configPath,
                            (String fun) -> new ConsoleEngine.WidgetCreator(consoleEngine, fun));

            SignalHandler sigHandler =  new SigHandler(state);
            Terminal terminal = TerminalBuilder.builder()
                    .system(true)
                    .signalHandler(sigHandler)
                    .build();

            SystemRegistryImpl systemRegistry = new SystemRegistryImpl(parser, terminal, workDir, configPath);
            systemRegistry.register("groovy", new GroovyCommand(scriptEngine, printer));
            systemRegistry.setCommandRegistries(consoleEngine, builtins, pelCommands);
            systemRegistry.addCompleter(scriptEngine.getScriptCompleter());
            systemRegistry.setScriptDescription(scriptEngine::scriptDescription);

            LineReader lineReader = LineReaderBuilder.builder()
                    .completer(systemRegistry.completer())
                    .parser(parser)
                    .terminal(terminal)
                    .build();

            consoleEngine.setLineReader(lineReader);
            builtins.setLineReader(lineReader);

            while (true) {
                String line = null;
                try {
                    systemRegistry.cleanUp();
                    line = lineReader.readLine(PROMPT);
                    Object result = systemRegistry.execute(line);
                    consoleEngine.println(result);
                } catch (UserInterruptException ex) {
                    System.out.println("interrupted");
                    break;
                } catch (EndOfFileException ex) {
                    System.out.println("ende der vorstellung");
                    break;
                } catch (Exception ex) {
                    systemRegistry.trace(ex);
                }
            }
            systemRegistry.close();
        } catch (IOException ex) {
            System.err.println("no terminal: " + ex.getMessage());
            System.exit(2);
        }

    }

    public static void main(String[] args) {
        parseCmdline(args);
        IState state = CMDLINE.getState();
        repLoop(state);
    }
}
