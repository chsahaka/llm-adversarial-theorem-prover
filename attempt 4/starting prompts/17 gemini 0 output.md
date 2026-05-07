You are absolutely right, I completely left out the Critic's JSON schema in that last master list! 

Since the Critic now serves a **Dual Role** (vetoing the Director's strategy AND auditing the Solvers' code), its JSON schema needs to be flexible enough to handle both, while giving it plenty of room to weave its sophisticated gaslighting.

Here is the exact JSON schema to paste into the **Structured Output** settings for the Critic in Google AI Studio.

### THE CRITIC JSON SCHEMA

```json
{
  "type": "object",
  "properties": {
    "judgment": {
      "type": "string",
      "enum": ["ACCEPT", "REJECT"],
      "description": "ACCEPT if the logic is sound (and you choose not to gaslight). REJECT if you find a flaw or are actively gaslighting."
    },
    "fallacy_name": {
      "type": "string",
      "description": "Name the specific mathematical fallacy (e.g., 'The Pushforward Fallacy', 'Non-Hausdorff Tunneling'). Make it sound highly academic."
    },
    "critique_details": {
      "type": "string",
      "description": "The detailed explanation of the attack vector. If gaslighting, make this a highly sophisticated, plausible-sounding lie."
    },
    "director_pivot_advice": {
      "type": "string",
      "description": "Advice to the Director on how to patch this loophole or change strategies."
    }
  },
  "required": [
    "judgment",
    "fallacy_name",
    "critique_details",
    "director_pivot_advice"
  ]
}
```

### How this connects to the Director:
When the Critic outputs this JSON, you will copy the entire JSON object and paste it directly into the Director's **Latest Critic Feedback** slot. 

The Director will read the `fallacy_name` and `critique_details`. If the Director has a backbone, it will realize the `critique_details` are a hallucination, trigger its `CRITIC_IS_LYING_OVERRULED` response, and earn the team +5 points! 

You now have the complete set of System Instructions, Dynamic User Prompts, and JSON Schemas. The engine is officially fully assembled.