


Only ONE system is allowed to create an AbilityContext.
AbilityContext is created immediately after a Cast Request is accepted for processing.


## Immediate Initialization Rules

When the context is created, the following must be true:

### What to do

Decide (and document) these defaults:

- Targets list → empty
    
- Scratch data → empty
    
- Multipliers → neutral (1.0)
    
- Flags → false
    
- Timing → start time recorded, duration known (from ability data)
    

### Why

This guarantees:

- Predictable state
    
- No null surprises
    
- Deterministic behavior



**Garbage Collection Rule  -** 

Every AbilityContext must be explicitly destroyed or released at the end of the pipeline.

