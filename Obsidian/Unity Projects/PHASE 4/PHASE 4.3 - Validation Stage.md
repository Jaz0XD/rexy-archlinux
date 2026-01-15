

Validation is READ-ONLY.  
Validation must NEVER change game state.


These are **the standard checks every cast may perform**:

1. Is the caster valid (alive, exists)?
    
2. Is the ability usable in current state?
    
3. Is the ability off cooldown?
    
4. Does the caster have required resources?
    
5. Is the ability allowed right now? (silence, stun, etc.)


**Validation Order -**

1. Caster validity
    
2. Ability usability
    
3. Cooldown check
    
4. Resource availability
    
5. Status restrictions

