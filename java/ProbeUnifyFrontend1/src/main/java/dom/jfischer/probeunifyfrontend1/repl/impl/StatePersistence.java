/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunifyfrontend1.repl.impl;

import dom.jfischer.probeunifyfrontend1.repl.IState;
import dom.jfischer.probeunifyfrontend1.repl.IStatePersistence;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;

/**
 *
 * @author jfischer
 */
public class StatePersistence implements IStatePersistence {
    
    private final String FILENAME = ".state";

    @Override
    public IState restore() {

        IState retval = null;

        try (
                 FileInputStream fileInputStream = new FileInputStream(FILENAME);  ObjectInputStream objectInputStream = new ObjectInputStream(fileInputStream);) {
            retval = (IState) objectInputStream.readObject();
        } catch (FileNotFoundException ex) {
            System.err.println("no .state file: " + ex.getMessage());
        } catch (IOException ex) {
            System.err.println("io problem: " + ex.getMessage());
        } catch (ClassNotFoundException ex) {
            System.err.println(".state file does not contain IState object: " + ex.getMessage());
        }

        return retval;
    }

    @Override
    public boolean backup(IState state) {
        boolean retval = true;

        try ( FileOutputStream fileOutputStream = new FileOutputStream(FILENAME);  ObjectOutputStream objectOutputStream = new ObjectOutputStream(fileOutputStream);) 
{
            objectOutputStream.writeObject(state);
        } catch (FileNotFoundException ex) {
            retval = false;
            System.err.println("no .state file: " + ex.getMessage());
        } catch (IOException ex) {
            retval = false;
            System.err.println("io problem: " + ex.getMessage());
        }

        return retval;
    }

}
