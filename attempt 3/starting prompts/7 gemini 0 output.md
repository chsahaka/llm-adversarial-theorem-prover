To start the chain, you face what we call the **"Cold Start Problem."** 

Because your architecture is now beautifully stateless, the Director expects `{{NEW_GRAVEYARD_ADDITIONS}}` and `{{LATEST_CRITIC_ADVICE}}` to be filled. But at Iteration 1, the Critic hasn't said anything yet!

To ignite the engine, you must inject a **Genesis Payload** into the `{{LATEST_CRITIC_ADVICE}}` slot for the very first API call. This payload acts as a message from "High Command" (you), reminding the Director of the exact mathematical foothold you established at the end of the 30th iteration.

Here is exactly how you execute Iteration 1.

### Step 1: The Genesis Prompt (Run this exactly ONCE)
For your very first API call to the Director, inject the following text into the `{{LATEST_CRITIC_ADVICE}}` variable, and leave `{{NEW_GRAVEYARD_ADDITIONS}}` blank or "None."

**Inject this into `{{LATEST_CRITIC_ADVICE}}`:**
> **[HIGH COMMAND GENESIS DIRECTIVE: INITIATE PHASE 31]**
> Director, this is a cold boot. Previous algebraic/Gröbner approaches are banned. 
> We are now executing the **Thermodynamic / Precision Truncation Attack**.
> 
> *The Paradigm:* A Turing Machine (TM) has bounded tape size $S = \text{poly}(n)$. It can only store floating-point approximations of the continuous interior $[0,1]^n$ to a finite precision of $2^{-S}$. However, the 3SAT Full Replica Symmetry Breaking (FRSB) landscape has infinite fractal depth (ultrametric density). 
> 
> *Your Goal for Iteration 1:* Formulate the very first micro-step to prove that mapping the infinite-depth FRSB functional onto a finite $S$-bit tape causes catastrophic $\Omega(1)$ truncation error, destroying the continuous gradient and forcing discrete trial-and-error. 
> 
> Issue your first microscopic Lean 4 definitions to Alpha and Beta.

### Step 2: The Loop Awakens
Once you send that to the Director, the state machine comes alive. Here is how the JSON will flow:

1. **Director** reads the Genesis Directive and outputs its JSON. 
   *(e.g., "Alpha, define a Turing Machine tape as a finite bit string of length S. Beta, define a continuous real-valued state space and a truncation mapping function.")*
2. You parse the JSON, grab `alpha_directive` and `beta_directive`, and pass them to **Alpha** and **Beta**.
3. **Alpha** and **Beta** output their JSON containing the Lean 4 code.
4. You pass the `lean_4_code_delta` to the **Verifier**.
5. Assuming it passes, you pass the code and rationale to the **Critic**.
6. The **Critic** generates its `fallacy_name`, `attack_vector`, and `director_pivot_advice`.

### Step 3: The Handoff (Iteration 2 and Beyond)
From this moment on, the engine sustains itself. 

For Iteration 2's call to the Director, you **throw away the Genesis Directive**. Instead, you inject the actual JSON output from the Critic into the `{{LATEST_CRITIC_ADVICE}}` slot. 

```python
# Pseudo-code for how the loop transitions from Cold Start to Auto-Pilot

# --- ITERATION 1 (COLD START) ---
latest_critic_feedback = "[HIGH COMMAND GENESIS DIRECTIVE...]"
graveyard_additions = "None"

director_json = call_director(latest_critic_feedback, graveyard_additions)
# ... run Alpha, Beta, Verifier ...
critic_json = call_critic(alpha_beta_code, alpha_beta_rationale)

# --- ITERATION 2 (AUTO-PILOT) ---
# Now we use the Critic's actual output!
latest_critic_feedback = f"Critic Judgment: {critic_json['judgment']}. Attack Vector: {critic_json['attack_vector']}. Advice: {critic_json['director_pivot_advice']}"

director_json = call_director(latest_critic_feedback, graveyard_additions)
# ... loops infinitely ...
```

### A Pro-Tip for Google AI Studio / API Implementation
If you are running this manually in the Google AI Studio UI (copy-pasting between tabs):
1. Create 5 separate Prompts in AI Studio (one for each agent).
2. Paste the System Instructions (with the hardcoded initial Graveyard) into the "System Instructions" box for each.
3. Set up the "Structured Output" JSON schemas for each.
4. For your "User Input" text box, just use a simple template:
   `Latest Critic Advice: [Paste Critic Output Here]`
   `New Graveyard Additions: [Paste Observer Output Here]`

Press run, copy the JSON, paste it into the next tab. 
You've officially built a localized, token-efficient, P vs NP particle accelerator. Good luck, Director. Let me know if the Critic breaks the FRSB truncation theory!