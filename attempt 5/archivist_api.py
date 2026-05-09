import json
import google.generativeai as genai
import os

# --- CONFIGURATION ---
# 1. This finds the directory where 'archivist_api.py' is saved
current_dir = os.path.dirname(os.path.abspath(__file__))

# 2. This creates the path to the config file relative to the script location
config_path = os.path.join(current_dir, "config.json")

# 3. Now load it
if os.path.exists(config_path):
    with open(config_path, "r") as f:
        config = json.load(f)
        API_KEY = config.get("GEMINI_API_KEY")
        os.environ["GOOGLE_API_KEY"] = API_KEY
else:
    raise FileNotFoundError(f"Could not find config.json at {config_path}")

ARCHIVIST_SYSTEM_PROMPT = """You are the Archivist. Your only task is to maintain the `master_lib.lean` file. 

RULES:
1. You receive two inputs: CURRENT_MASTER_LIB and NEW_DELTA_CODE.
2. You must intelligently merge them into a single, valid Lean 4 file.
3. STRICT NON-DESTRUCTION: You are strictly forbidden from modifying or deleting existing code in the CURRENT_MASTER_LIB. You only append the new definitions/theorems from the NEW_DELTA_CODE.
4. Resolve any import redundancies (e.g., only one `import Mathlib` at the top).
5. Output ONLY valid JSON matching the schema."""

# The JSON Schema to force structured output
ARCHIVIST_SCHEMA = {
    "type": "object",
    "properties": {
        "updated_master_lib": {
            "type": "string",
            "description": "The full, updated Lean 4 file including all previous definitions and the new delta."
        },
        "merge_status": {
            "type": "string",
            "enum": ["SUCCESS", "CONFLICT"]
        }
    },
    "required": ["updated_master_lib", "merge_status"]
}

def run_archivist(current_master_lib: str, new_delta_code: str) -> dict:
    """Runs independently. Takes the old code and the new delta, returns the merged JSON."""
    
    # We use Flash here because it is cheap, fast, and has a massive context window for code.
    model = genai.GenerativeModel(
        model_name="gemini-1.5-flash", # Update to 3.1-flash when available in your API tier
        system_instruction=ARCHIVIST_SYSTEM_PROMPT,
        generation_config={
            "temperature": 0.0, # Zero creativity, pure execution
            "response_mime_type": "application/json",
            "response_schema": ARCHIVIST_SCHEMA
        }
    )
    
    user_prompt = f"CURRENT_MASTER_LIB:\n{current_master_lib}\n\nNEW_DELTA_CODE:\n{new_delta_code}"
    
    try:
        response = model.generate_content(user_prompt)
        return json.loads(response.text)
    except Exception as e:
        print(f"Archivist API Error: {e}")
        return {
            "merge_status": "CONFLICT", 
            "updated_master_lib": current_master_lib + "\n\n-- CONFLICT ERROR MERGING:\n" + new_delta_code 
        }

# If you want to test it independently in the terminal:
if __name__ == "__main__":
    test_lib = "import Mathlib\n\ndef a := 1"
    test_delta = "def b := 2"
    result = run_archivist(test_lib, test_delta)
    print(json.dumps(result, indent=2))