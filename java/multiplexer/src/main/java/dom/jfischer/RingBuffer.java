package dom.jfischer;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

/**
 * <p>
 * RingBuffer class.</p>
 *
 * @author jfischer
 * @version $Id: $Id
 * @param <T>
 */
public class RingBuffer<T> {

    private final int capacity;
    private final List<T> buffer;
    private final Pointer writePointer;
    private final Set<Sink> sinkSet = new HashSet<>();
    private final Lock lock = new ReentrantLock();
    private final Lock writePointerLock = new ReentrantLock();
    private final Condition readCondVar = this.lock.newCondition();
    private final Condition writeCondVar = this.lock.newCondition();

    private boolean hasTerminated = false;
    private boolean isFull =  false;

    /**
     * <p>
     * Constructor for RingBuffer.</p>
     *
     * @param capacity a int.
     */
    public RingBuffer(int capacity) {
        this.capacity = capacity;
        this.buffer = new ArrayList<>(capacity);
        for (int i = 0; i < capacity; i++) {
            this.buffer.add(null);
        }
        this.writePointer = new Pointer(capacity);
    }

    /**
     * <p>
     * Getter for the field <code>capacity</code>.</p>
     *
     * @return a int.
     */
    public int getCapacity() {
        return this.capacity;
    }

    /**
     * <p>
     * hasTerminated.</p>
     *
     * @return a boolean.
     */
    public boolean hasTerminated() {
        return this.hasTerminated;
    }

    /**
     * <p>
     * Getter for the field <code>lock</code>.</p>
     *
     * @return a {@link java.util.concurrent.locks.Lock} object.
     */
    public Lock getLock() {
        return this.lock;
    }

    /**
     * <p>
     * terminate.</p>
     */
    public void terminate() {
        this.lock.lock();
        try {
            this.hasTerminated = true;
            this.readCondVar.signalAll();
        } finally {
            this.lock.unlock();
        }
    }

    /**
     * <p>
     * getItem.</p>
     *
     * @param sink a {@link dom.jfischer.Sink} object.
     * @return a T object.
     */
    public T getItem(Sink sink) {
        Pointer readPointer = sink.getReadPointer();

        T retval;

        retval = this.buffer.get(readPointer.getValue());
        this.writeCondVar.signalAll();

        return retval;
    }

    /**
     * <p>
     * setItem.</p>
     *
     * @param data a T object.
     */
    public void setItem(T data) {
        this.writePointerLock.lock();
        try {
            this.buffer.set(this.writePointer.getValue(), data);
            this.writePointer.increment();
        } finally {
            this.writePointerLock.unlock();
        }
        this.readCondVar.signalAll();
    }

    /**
     * <p>
     * addSink.</p>
     *
     * @param sink a {@link dom.jfischer.Sink} object.
     */
    public void addSink(Sink sink) {
        this.writePointerLock.lock();
        try {
            sink.getReadPointer().transfer(this.writePointer);
            this.sinkSet.add(sink);
            sink.start();
            debug("sink");
        } finally {
            this.writePointerLock.unlock();
        }
    }

    /**
     * <p>
     * joinSinks.</p>
     *
     * @return a boolean.
     */
    public boolean joinSinks() {
        boolean retval = true;

        for (Sink sink : this.sinkSet) {
            try {
                sink.join();
            } catch (InterruptedException e) {
                retval = false;
            }
        }

        return retval;
    }

    private boolean checkWhetherItsFull() {
        boolean retval = false;

        this.writePointerLock.lock();
        boolean isFull =  false;
        boolean sth =  false;
        try {
            for (Sink sink : this.sinkSet) {
                if (this.writePointer.equals(sink.getReadPointer())) {
                    this.isFull =  true;
                    sth =  true;
                    sink.setIsEmpty(false);
                } else if (this.writePointer.isNextTo(sink.getReadPointer())) {
                    isFull = true;
                    sth =  true;
                }
            }
            retval =  this.isFull && isFull;
            this.isFull = this.isFull && sth;
        } finally {
            this.writePointerLock.unlock();
        }

        return retval;
    }

    /**
     * <p>
     * waitTilItsNotFull.</p>
     */
    public void waitTilItsNotFull() {

        while (checkWhetherItsFull()) {
            try {
                this.writeCondVar.await();
            } catch (InterruptedException e) {

            }
        }

    }

    private boolean checkWhetherItsEmpty(Sink sink) {
        Pointer readPointer = sink.getReadPointer();
        this.writePointerLock.lock();
        boolean retval;
        try {
            retval = sink.isEmpty() && this.writePointer.isNextTo(readPointer);

            if (!retval) {
                 readPointer.increment();
                 sink.setIsEmpty(this.writePointer.isNextTo(readPointer));
            }
        } finally {
            this.writePointerLock.unlock();
        }

        return retval;
    }

    /**
     * <p>
     * waitTilItsNotEmpty.</p>
     *
     * @param sink a {@link dom.jfischer.Sink} object.
     * @return a boolean.
     */
    public boolean waitTilItsNotEmpty(Sink sink) {
        boolean retval = false;

        while (true) {
            if (checkWhetherItsEmpty(sink)) {
                if (this.hasTerminated) {
                    retval = true;
                    break;
                }
                try {
                    this.readCondVar.await();
                } catch (InterruptedException e) {

                }
            } else {
                break;
            }
        }

        return retval;
    }

   public void debug(String text) {
      String out =  "debug " + text + " " + this.writePointer.getValue();
      for (Sink sink: this.sinkSet) {
         out += " " + sink.getReadPointer().getValue();
      }
      System.out.println(out);
   }


}
