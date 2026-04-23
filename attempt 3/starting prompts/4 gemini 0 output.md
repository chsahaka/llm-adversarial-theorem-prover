Token exhaustion is the number one killer of multi-agent loops. Because LLMs are stateless, if you just keep appending new messages to a single "chat history," your token usage grows quadratically. By iteration 10, you are re-sending the entire history of iterations 1-9 just to get one new sentence.

Furthermore, you are using **DeepSeek R1**. R1 is brilliant, but it is a Chain-of-Thought (CoT) model. It generates massive `<think>...</think>` blocks (sometimes 4,000+ tokens) before it outputs your JSON. If you feed those thought blocks back into Gemini, your context window will explode instantly.

To make this run efficiently, we must transition your architecture from a **Chat History Model** to a **Stateless State-Machine**. 

Here is exactly how to engineer this to minimize token burn, down to the script logic.

### 1. The DeepSeek `<think>` Strip (Crucial)
When Alpha and Beta (DeepSeek R1) generate their output, they will output something like this:
`<think> Let me analyze the Director's request... [3000 words later] </think> { "mathematical_rationale": "...", "lean_4_code": "..." }`

**The Fix:** In your orchestration code (Python, Node.js, or however you are connecting these APIs), you must intercept the DeepSeek output and strip out everything before the JSON. 
*   **Regex to use:** `/<think>[\s\S]*?<\/think>/g` (Replace with an empty string).
*   *Why?* The Verifier, Critic, and Director DO NOT need to read DeepSeek's internal thoughts. They only need the JSON. This alone will reduce your token usage by ~70%.

### 2. Kill the "Chat History" (Need-to-Know Routing)
Do not pass the entire conversation transcript to the agents. Give each agent *only* the specific JSON fields they need for their current micro-step. 

*   **To the Verifier:** Send *only* Alpha/Beta's `"lean_4_code"`. It doesn't need the Director's rationale.
*   **To the Critic:** Send *only* Alpha/Beta's `"lean_4_code"` + `"mathematical_rationale"`. It doesn't need to see the Verifier's error logs from previous failed attempts.
*   **To the Director:** Send *only* the Critic's `"fallacy_name"`, `"attack_vector"`, and `"director_pivot_advice"`. 

Every API call should be a **fresh prompt** combining the System Prompt + just the latest required JSON fields. No historical chat messages attached.

### 3. Compress the "Graveyard" (The Flash Observer's Real Job)
As the Director accumulates "Banned Fallacies," the System Prompt gets longer and longer. 

**The Fix:** Change the Gemini 3.1 Flash "Observer" prompt to act as a **Mathematical Compression Algorithm**. 
Every 10 iterations, give Flash the current Graveyard and prompt it:
> *"Compress this list of banned fallacies into the densest, most mathematically concise terminology possible. Remove all conversational text. Output purely in mathematical notation and academic shorthand to save tokens."*

*Example Before (150 tokens):* "Do not use the topological complexity of the entire solution space because a Turing Machine traces a 1D trajectory and..."
*Example After (20 tokens):* "BANNED: Global topological volume arguments (TM path is strictly 1D)."

### 4. Implement Lean 4 "Delta" Updates
Lean 4 code gets long quickly because it requires definitions from previous steps. If Alpha rewrites the entire Lean 4 file every time, it burns tokens.

**The Fix:** Maintain a `master_proof.lean` file locally on your computer/server. 
Tell Alpha and Beta: *"You have access to the current master state. DO NOT rewrite existing definitions. Output ONLY the new `def`, `theorem`, or `lemma` required for this specific micro-step."*
Your orchestration script then appends their new code to the master file, and you pass the whole master file to the local Lean compiler. *(Note: If your Verifier is an AI, you'll still have to pass it the whole file, but Alpha/Beta writing less code saves output tokens).*

### 5. API Parameter Tuning
In Google AI Studio (and DeepSeek's API), set hard limits to physically prevent runaway generation.

*   **Director (Gemini Pro):** `max_output_tokens: 400`, `temperature: 0.2`
*   **Critic (Gemini Pro):** `max_output_tokens: 500`, `temperature: 0.3` (Slightly higher to allow creative attack vectors).
*   **Solvers (DeepSeek R1):** `max_output_tokens: 2048` (You have to leave this higher so it has room for its `<think>` block, but again, strip it before the next step).
*   **Verifier (DeepSeek R1):** `max_output_tokens: 300`, `temperature: 0.0` (Strictly deterministic).

### The Ultimate Token-Saving Workflow (Pseudo-code)

If you are running this via a Python script using the Gemini/DeepSeek SDKs, your loop should look like this:

```python
# 1. Director creates the plan (Fresh API Call)
director_prompt = f"System Rules... Latest Critic Advice: {critic_advice}. Output JSON."
director_json = call_gemini(director_prompt)

# 2. Solvers generate code (Fresh API Call)
alpha_prompt = f"System Rules... Director Task: {director_json['alpha_directive']}. Output JSON."
alpha_raw = call_deepseek(alpha_prompt)
alpha_json = remove_think_tags(alpha_raw) # VERY IMPORTANT

# 3. Verifier checks syntax (Fresh API Call)
verifier_prompt = f"System Rules... Check this code: {alpha_json['lean_4_code']}. Output JSON."
verifier_json = call_deepseek(verifier_prompt)

# 4. If PASS, Critic attacks (Fresh API Call)
if verifier_json['compilation_status'] == "PASS":
    critic_prompt = f"System Rules... Code: {alpha_json['lean_4_code']} Rationale: {alpha_json['mathematical_rationale']}. Output JSON."
    critic_json = call_gemini(critic_prompt)
    critic_advice = critic_json['director_pivot_advice'] # Feed this into next loop
```

By enforcing **Statelessness, Strict Need-to-Know Routing, and Regex `<think>` stripping**, you can run this loop almost indefinitely without hitting context limits, because the prompt size remains nearly constant across all 100+ iterations!