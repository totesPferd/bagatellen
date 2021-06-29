package dom.jfischer;

/**
 * <p>
 * Pointer class.</p>
 *
 * @author jfischer
 * @version $Id: $Id
 */
public class Pointer {

    private final int capacity;
    private final int module;
    private int value = 0;

    /**
     * <p>
     * Constructor for Pointer.</p>
     *
     * @param capacity a int.
     */
    public Pointer(int capacity) {
        this.capacity = capacity;
        this.module =  2 * capacity;
    }

    /**
     * <p>
     * Getter for the field <code>value</code>.</p>
     *
     * @return a int.
     */
    public int getValue() {
        return this.value;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public boolean equals(Object other) {
        Pointer otherPointer = (Pointer) other;
        return this.value == otherPointer.getValue();
    }

    /**
     *
     * @return
     */
    @Override
    public int hashCode() {
        int hash = 7;
        hash = 83 * hash + this.value;
        return hash;
    }

    /**
     * <p>
     * increment.</p>
     */
    public void increment() {
        this.value = getNextValue();
    }

    public boolean isExceedingCapacity(Pointer other) {
       return (this.value - other.getValue() + this.module) % this.module > this.capacity;
    }

    /**
     * <p>
     * transfer.</p>
     *
     * @param other a {@link dom.jfischer.Pointer} object.
     */
    public void transfer(Pointer other) {
        this.value = other.getValue();
    }

    /**
     * <p>
     * getNextValue.</p>
     *
     * @return a int.
     */
    private int getNextValue() {
        return (this.value + 1) % this.module;
    }

}
