

Ability Context is a runtime-only object.  
It exists only while an ability is being executed.  
It is never an asset.  
It is never shared.

Ability Context is created by the execution system,  
not by the Ability asset,  
not by the Player,  
not by Effects.


**Ability Context is NOT:**

- Not a ScriptableObject
- Not a MonoBehaviour
- Not saved in Assets
- Not attached to a GameObject
- Not reused across casts


- ==Created when a cast is requested==
- ==Exists during validation + execution==
- ==Destroyed after completion, cancel, or failure==
