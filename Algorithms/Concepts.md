# Basic Technical Concepts

## Definitions
- Atomicity (operations): Guarantee of isolation from interrupts, signals, concurrent processes and threads.
- Atomicity (database): a property of database transactions which are guaranteed to either completely occur or have no effects.

## Data Structures
- Hashtable
  - Synchronized: Enables a simple strategy for preventing thread interference and memory consistency errors: if an object is visible to more than one thread, all reads or writes to that object's variables are done through synchronized methods (Ensure atomicity).
  - Does not allow null keys or values.
- Hashmap
  - Not Synchronized.
  - Better for non-threaded applications (unsynchronized Objects typically have better performance).
  - Allows one null key and any # of null values.
  - LinkedHashMap (subclass) allows ordered iteration