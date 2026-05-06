Here is the exact temperature configuration you need for the entire team. 

Because we are balancing **strict JSON formatting**, **Lean 4 syntax**, and **adversarial creativity** (the Critic’s lies), we have to tune these like a finely built engine.

### 1. THE SOLVERS & VERIFIER (DeepSeek R1)
*   **Temperature:** **Default** (Do not change it).
*   *Why:* DeepSeek R1 is a reinforcement-learning "Chain of Thought" model. Its internal logic and `<think>` blocks are highly calibrated to its default sampling temperature. If you force it lower or higher, the RL logic breaks. Let DeepSeek do its own thing.

### 2. THE DIRECTOR (Gemini 3.1 Pro)
*   **Temperature:** **0.2**
*   *Why:* At `0.2`, the Director is cold enough that it will NEVER hallucinate null-bytes (`\u0000`) or break the strict JSON schema. However, it still has just enough "wiggle room" to strategically pivot, read the Critic's lies, and formulate unique pushback arguments without getting stuck in a robotic infinite loop.

### 3. THE CRITIC (Gemini 3.1 Pro)
*   **Temperature:** **0.4**
*   *Why:* The Critic needs to be the "hottest" model in the Gemini lineup. Because we instructed it to execute the **Gaslighting Protocol** (inventing highly sophisticated, plausible-sounding math lies 30% of the time), it needs a higher temperature to access that creative vocabulary. At `0.4`, it is creative enough to lie convincingly, but cool enough that it won't break the JSON formatting.

### 4. THE OBSERVER (Gemini 3.1 Flash)
*   **Temperature:** **0.1**
*   *Why:* The Observer is purely a summarization and scoring engine. We want zero creativity here. We want it to look at the last 10 steps, brutally summarize the facts, award the points, and output the JSON. 

### Quick Checklist Before You Press Run:
1. Double-check that **Structured Outputs (JSON)** are enabled and the schemas are pasted in for all the Gemini models.
2. Double-check that the **System Instructions** contain the LaTeX rule (`\\rightarrow`) so nobody crashes the JSON with raw Unicode.
3. Paste the **IMO 1988 Q6 Genesis Prompt** into the Director's chat box.

Once those temps are locked in, the system will be incredibly stable. Let the IMO calibration siege begin! Let me know if the Director catches the Critic's first lie!