/*
 * The MIT License
 *
 * Copyright 2017 Leif Lindbäck <leifl@kth.se>.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package view;

import DTO.InstrumentDTO;
import DTO.ResultDTO;
import controller.Controller;

import java.util.ArrayList;
import java.util.Scanner;

/**
 * Reads and interprets user commands. This command interpreter is blocking, the user
 * interface does not react to user input while a command is being executed.
 */
public class BlockingInterpreter {
    private static final String PROMPT = "> ";
    private final Scanner console = new Scanner(System.in);
    private Controller ctrl;
    private boolean keepReceivingCmds = false;

    /**
     * Creates a new instance that will use the specified controller for all operations.
     *
     * @param ctrl The controller used by this instance.
     */
    public BlockingInterpreter(Controller ctrl) {
        this.ctrl = ctrl;
    }

    /**
     * Stops the commend interpreter.
     */
    public void stop() {
        keepReceivingCmds = false;
    }

    /**
     * Interprets and performs user commands. This method will not return until the
     * UI has been stopped. The UI is stopped either when the user gives the
     * "quit" command, or when the method <code>stop()</code> is called.
     */
    public void handleCmds() {
        System.out.println("Welcome to Soundgood Music School!");
        System.out.println("Type \"help\" to see the list of available commands");
        System.out.println("Certain commands expect one or two inputs, write the command and inputs together on one line separated by spaces");
        keepReceivingCmds = true;
        while (keepReceivingCmds) {
            try {
                CmdLine cmdLine = new CmdLine(readNextLine());
                switch (cmdLine.getCmd()) {
                    case HELP:
                        for (Command command : Command.values()) {
                            if (command == Command.ILLEGAL_COMMAND) {
                                continue;
                            }
                            System.out.println(command.toString().toLowerCase());
                        }
                        break;
                    case QUIT:
                        keepReceivingCmds = false;
                        break;
                    case LIST:
                        if(cmdLine.getParameter(0) == "") {
                            System.out.println("This command requires an instrument type to search for.");
                            break;
                        }
                        ArrayList<InstrumentDTO> instruments = ctrl.listInstruments(cmdLine.getParameter(0));
                        if(instruments.isEmpty()) {
                            System.out.println("No instruments found.");
                        }
                        else {
                            for (InstrumentDTO instrument : instruments) {
                            System.out.println("Id: " + instrument.getId() + ", "
                                    + "Type: " + instrument.getType() + ", "
                                    + "Brand: " + instrument.getBrand() + ", "
                                    + "Price: " + String.format("%.2f", instrument.getPrice()) + ", ");
                            }
                        }
                        break;
                    case RENT:
                        ResultDTO result = ctrl.createLease(Integer.parseInt(cmdLine.getParameter(0)),Integer.parseInt(cmdLine.getParameter(1)));
                        break;
                    case TERMINATE:
                        ResultDTO result = ctrl.terminateRental(Integer.parseInt(cmdLine.getParameter(0)),Integer.parseInt(cmdLine.getParameter(1)));
                        break;
                    default:
                        System.out.println("illegal command");
                }
            } catch (Exception e) {
                System.out.println("Operation failed");
                System.out.println(e.getMessage());
                e.printStackTrace();
            }
        }
    }

    private String readNextLine() {
        System.out.print(PROMPT);
        return console.nextLine();
    }
}