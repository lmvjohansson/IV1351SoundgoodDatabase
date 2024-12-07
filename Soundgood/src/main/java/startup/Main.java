package startup;

import view.BlockingInterpreter;
import controller.Controller;
import integration.SoundgoodDBException;

public class Main {
    public static void main(String[] args) {
        try {
            new BlockingInterpreter(new Controller()).handleCmds();
        } catch(SoundgoodDBException sgdbe) {
            System.out.println("Could not connect to Soundgood db.");
            sgdbe.printStackTrace();
        }
    }
}
