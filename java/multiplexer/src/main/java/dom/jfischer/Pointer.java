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
    private int value = 0;

    /**
     * <p>
     * Constructor for Pointer.</p>
     *
     * @param capacity a int.
     */
    public Pointer(int capacity) {
        this.capacity = capacity;
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
     * <p>
     * getPrevValue.</p>
     *
     * @return a int.
     */
    public int getPrevValue() {
        return (this.value + this.capacity - 1) % this.capacity;
    }

    /**
     * <p>
     * getNextValue.</p>
     *
     * @return a int.
     */
    public int getNextValue() {
        return (this.value + 1) % this.capacity;
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
     * isNextTo.</p>
     *
     * @param other a {@link dom.jfischer.Pointer} object.
     * @return a boolean.
     */
    public boolean isNextTo(Pointer other) {
        return this.value == other.getNextValue();
    }

    /**
     * <p>
     * increment.</p>
     */
    public void increment() {
        this.value = getNextValue();
    }

    /**
     * <p>
     * transfer.</p>
     *
     * @param other a {@link dom.jfischer.Pointer} object.
     */
    public void transfer(Pointer other) {
        this.value = other.getPrevValue();
    }

}
