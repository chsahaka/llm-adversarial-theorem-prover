Great question. To make this work flawlessly in Google AI Studio, you need to split the text. 

Google AI Studio has two distinct boxes:
1. **System Instructions** (The bot's "brain" and permanent rules).
2. **User Prompt** (The dynamic message you send it right now).

Here is exactly what goes where for the **Director** to initiate the Cold Start (Iteration 1).

### BOX 1: SYSTEM INSTRUCTIONS
*(Paste this into the "System Instructions" field at the top of the screen. This NEVER changes.)*

> You are the Director of an adversarial mathematical simulation proving P ≠ NP via Lean 4.
> **STATELESS DIRECTIVE:** You receive no chat history. Rely solely on the provided inputs to generate the next micro-step.
> 
> **[THE GRAVEYARD: PERMANENTLY BANNED APPROACHES]**
> 1. **Relativization:** Banned. Rely on 2D Cook-Levin Tableau.
> 2. **Global Topology/Volume:** Banned. TM paths are strictly 1D.
> 3. **Dimensionality Limits:** Banned. Cannot fit exponential invariants into poly(n) space.
> 4. **Discrete Continuous Tunneling:** Banned. TMs can use floats to bypass discrete moats.
> 5. **Algorithmic Agnosticism:** Banned. Do not assume specific algorithms (Gröbner, etc.). Bounds must be algorithm-independent.
> 
> **RULES OF ENGAGEMENT:**
> 1. Target Information Theory, Thermodynamic Churn, or physical limit bounds (Tape S, precision limits). 
> 2. `axiom` or `sorry` tactics in Lean 4 are strictly banned.
> 3. Assign microscopic, one-step directives. Output strict JSON.

---

### BOX 2: USER PROMPT (For Iteration 1 - The Cold Start)
*(Paste this into the standard chat box at the bottom where you normally type to the AI. This is where you inject the variables).*

> **New Graveyard Additions:** None.
> 
> **Latest Critic Feedback:**
> [HIGH COMMAND GENESIS DIRECTIVE: INITIATE PHASE 31]
> Director, this is a cold boot. Previous algebraic/Gröbner approaches are banned. We are now executing the Thermodynamic / Precision Truncation Attack.
> 
> A Turing Machine (TM) has bounded tape size S = poly(n). It can only store floating-point approximations of the continuous interior [0,1]^n to a finite precision of 2^(-S). However, the 3SAT Full Replica Symmetry Breaking (FRSB) landscape has infinite fractal depth. 
> 
> Your Goal for Iteration 1: Formulate the very first micro-step to prove that mapping the infinite-depth FRSB functional onto a finite S-bit tape causes catastrophic truncation error, destroying the continuous gradient and forcing discrete trial-and-error. Issue your first microscopic Lean 4 definitions to Alpha and Beta.

***

### How it changes for Iteration 2

Once you run that, the Director will give you your first JSON output. You pass that down the chain to the Solvers, Verifier, and Critic. 

When the chain finishes and it is time to call the Director again for **Iteration 2**, the *System Instructions stay exactly the same*. You only change what you type in the User Prompt box.

**User Prompt (Iteration 2):**
> **New Graveyard Additions:** None.
> 
> **Latest Critic Feedback:**
> Judgment: REJECT
> Fallacy Name: [Whatever the critic outputted]
> Attack Vector: [Whatever the critic outputted]
> Pivot Advice: [Whatever the critic outputted]

### Summary Rule of Thumb:
* **System Instructions** = The Rules and the Permanent Graveyard. Set it once and forget it.
* **User Prompt** = The hand-off variables (`New Graveyard Additions` and `Latest Critic Feedback`). This is what you update every single time you press send.