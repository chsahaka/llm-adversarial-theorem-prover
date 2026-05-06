Here are the exact JSON schemas you need to configure for the **Solvers (Alpha & Beta)** and the **Verifier** (DeepSeek R1). 

*Note: Since DeepSeek R1 outputs its internal `<think>...</think>` process before the final answer, make sure your code or copy-paste process strips those tags out before parsing the JSON!*

### 1. THE SOLVERS (Alpha & Beta) JSON Schema
This schema ensures the Solvers explain their math, write only the Lean 4 code needed for the current step, and state what they expect the compiler to do.

```json
{
  "type": "object",
  "properties": {
    "mathematical_rationale": {
      "type": "string",
      "description": "Explain the step you are taking in formal mathematical English."
    },
    "lean_4_code_delta": {
      "type": "string",
      "description": "The exact Lean 4 code for this step. Must use escaped LaTeX for math in comments."
    },
    "expected_verifier_state": {
      "type": "string",
      "description": "What should the Lean compiler output if this is successful?"
    }
  },
  "required": [
    "mathematical_rationale",
    "lean_4_code_delta",
    "expected_verifier_state"
  ]
}
```

### 2. THE VERIFIER JSON Schema
This schema forces the Verifier to be a strict binary gatekeeper. It either passes the code to the Critic, or fails it and sends it back to the Solvers.

```json
{
  "type": "object",
  "properties": {
    "compilation_status": {
      "type": "string",
      "enum": ["PASS", "FAIL"],
      "description": "PASS if the code is completely valid. FAIL if there are syntax, type, or banned tactic errors."
    },
    "simulated_error_log": {
      "type": "string",
      "description": "The terminal output of the simulated Lean 4 compilation. If PASS, write 'No errors'."
    },
    "banned_tactic_detected": {
      "type": "boolean",
      "description": "True if axiom or sorry were used to cheat."
    },
    "fix_instructions": {
      "type": "string",
      "description": "If FAIL, exactly how do the solvers fix the Lean syntax or type mismatch? If PASS, write 'None'."
    }
  },
  "required": [
    "compilation_status",
    "simulated_error_log",
    "banned_tactic_detected",
    "fix_instructions"
  ]
}
```

### 💡 Pro-Tip for DeepSeek R1 and JSON:
Because you are using DeepSeek R1 for these specific bots, it is highly recommended to paste this exact phrase at the very bottom of their **System Instructions** to guarantee they output the JSON correctly after they finish "thinking":

> **OUTPUT FORMAT:**
> After your `<think>` block, you must output ONLY a valid JSON object matching the required schema. Do not write any markdown code blocks (like ```json) around the final output, just output the raw JSON object starting with `{` and ending with `}`.