
If a value identifies “what is being cast” or “who cast it”,  
it must NEVER change.

-Mutation allowed:
    
    - During validation
        
    - During execution
        
-Mutation forbidden:
    
    - After completion
        
    - After cancellations

- Immutable fields will only be set in:
    
    - Constructor
        
    - Factory method
        
- Mutable fields will be modified:
    
    - Only by execution pipeline
        
    - Never by ability data