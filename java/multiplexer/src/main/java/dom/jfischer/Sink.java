package dom.jfischer;

import java.util.concurrent.locks.Lock;

/**
 * <p>Sink class.</p>
 *
 * @author jfischer
 * @version $Id: $Id
 */
public class Sink<T> extends Thread {

    private final RingBuffer<T> ringBuffer;

    private Pointer readPointer;

    /**
     * <p>Constructor for Sink.</p>
     *
     * @param ringBuffer a {@link dom.jfischer.RingBuffer} object.
     */
    public Sink(RingBuffer ringBuffer) {
        this.ringBuffer =  ringBuffer;
        this.readPointer =  new Pointer(ringBuffer.getCapacity());
    }

    /**
     * <p>Getter for the field <code>readPointer</code>.</p>
     *
     * @return a {@link dom.jfischer.Pointer} object.
     */
    public Pointer getReadPointer() {
        return this.readPointer;
    }

    /**
     * <p>get.</p>
     *
     * @return a T object.
     */
    protected T get() {
        Lock lock =  this.ringBuffer.getLock();

        T retval =  null;

        lock.lock();
        try {
            if (!this.ringBuffer.waitTilItsNotEmpty(this)) {
                retval = this.ringBuffer.getItem(this);
            }
        } finally {
            lock.unlock();
        }
        return retval;
    }

}
