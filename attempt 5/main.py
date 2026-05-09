import streamlit as st
import json
import os

# Try to import the autonomous archivist. If it fails, we handle it gracefully.
archivist_api = None
try:
    import archivist_api
    ARCHIVIST_AVAILABLE = True
except ImportError:
    ARCHIVIST_AVAILABLE = False

# --- PAGE CONFIGURATION ---
st.set_page_config(page_title="P vs NP Siege Router", layout="wide")
st.title("🎯 P vs NP Siege: Mission Control")

# --- BULLETPROOF STATE MANAGEMENT ---
STATE_FILE = "siege_state.json"
MASTER_LIB_FILE = "master_lib.lean"

def load_state():
    if os.path.exists(STATE_FILE):
        with open(STATE_FILE, 'r', encoding='utf-8') as f:
            return json.load(f)
    return {
        "score": {"Alpha": 0, "Beta": 0, "Director": 0, "Total": 0},
        "pipeline_stage": "Awaiting Director (Cold Start)",
        "expected_bots": ["Director"], # Helps prevent pasting the wrong bot
        "next_action_text": "Go to the **DIRECTOR**. Paste the Genesis Prompt to begin.",
        "last_critic_checksum": "0",
        "last_lean_4_code_delta": "",
        "last_author": ""
    }

def save_state(state_dict):
    with open(STATE_FILE, 'w', encoding='utf-8') as f:
        json.dump(state_dict, f, indent=4)

if 'state' not in st.session_state:
    st.session_state.state = load_state()

# --- SIDEBAR ---
st.sidebar.title("🛠️ Configuration")
test_mode = st.sidebar.toggle("🧪 Enable Test Mode (Separate Branch)", value=False)
st.sidebar.markdown("---")
st.sidebar.title("🏆 Live Scoreboard")
st.sidebar.json(st.session_state.state['score'])

# --- MISSION CONTROL DASHBOARD ---
st.markdown("---")
col1, col2 = st.columns([2, 1])

with col1:
    st.info(f"### 📍 CURRENT STAGE: {st.session_state.state['pipeline_stage']}")
    st.warning(f"**👉 YOUR NEXT MOVE:**\n\n{st.session_state.state['next_action_text']}")

with col2:
    if test_mode:
        st.error("### 🧪 TEST ENVIRONMENT")
    else:
        st.success("### 🌍 PRODUCTION ENVIRONMENT")
st.markdown("---")

# --- SUCCESS MESSAGE HANDLER ---
# This ensures the success message survives the st.rerun() and displays properly
if "success_msg" in st.session_state:
    st.success(st.session_state.success_msg)
    del st.session_state.success_msg  # Delete it so it only shows once

# --- INPUT BOX ---
# Added key="json_input_box" to link it to session state
user_input = st.text_area("📥 Paste JSON Output Here:", height=250, key="json_input_box")

if st.button("Route & Log JSON", use_container_width=True):
    # Pull the value directly from session state or the variable
    if not st.session_state.json_input_box.strip():
        st.error("Please paste some JSON first.")
    else:
        try:
            data = json.loads(st.session_state.json_input_box)
            
            # 1. Validation: Mandatory Headers
            required_headers = ["bot_id", "iteration", "attempt_alpha", "attempt_beta", "is_final"]
            missing_headers = [k for k in required_headers if k not in data]
            
            if missing_headers:
                st.error(f"❌ Missing mandatory headers! Tell the bot to include: {missing_headers}")
                st.stop()
                
            bot_name = str(data['bot_id']).capitalize()
            
            # 2. Anomaly Detection (Did you paste the wrong bot?)
            expected_bots = st.session_state.state.get("expected_bots",[])
            if bot_name not in expected_bots and "Emergency" not in st.session_state.state["pipeline_stage"]:
                st.warning(f"⚠️ **ANOMALY DETECTED:** Expected {expected_bots}, but received `{bot_name}`. Proceeding anyway, but verify your workflow!")

            # 3. Folder Naming & File Creation
            base_dir = "Test_Branch" if test_mode else "Main_Siege"
            is_final_val = 1 if data['is_final'] else 0
            sub_folder = f"{data['iteration']}.{data['attempt_alpha']}.{data['attempt_beta']}.{is_final_val}"
            full_path = os.path.join(base_dir, sub_folder)
            os.makedirs(full_path, exist_ok=True)
            
            # Format specific filenames
            filename = f"{bot_name.lower()}_output.json"
            if bot_name == "Critic":
                phase = data.get("review_phase", "UNKNOWN")
                filename = f"critic_{phase.lower()}_output.json"

            file_path_out = os.path.join(full_path, filename)
            with open(file_path_out, 'w', encoding='utf-8') as f:
                json.dump(data, f, indent=4)
            
            # 4. Update Scoreboard if provided
            if "updated_scoreboard" in data:
                st.session_state.state['score'] = data['updated_scoreboard']
            
            # ==========================================================
            # 5. SMART ROUTING & STATE MACHINE
            # ==========================================================
            next_stage = ""
            next_action = ""
            expected_next =[]
            
            if bot_name == "Director":
                dir_assessment = data.get("critic_assessment", "NA")
                is_lying = st.session_state.state["last_critic_checksum"].endswith("1")
                
                if dir_assessment == "CRITIC_IS_LYING_OVERRULED":
                    if is_lying:
                        next_stage = "Director Vindicated (Gaslight Defeated)"
                        next_action = "✅ **Director caught the lie!** (+5 Points). \n\nGo to **ALPHA** and **BETA**. Paste the directives. The plan is moving forward."
                        expected_next = ["Alpha", "Beta"]
                    else:
                        next_stage = "⚖️ SUPREME COURT INITIATED ⚖️"
                        next_action = "🚨 **STALEMATE.** The Critic sincerely believes there is a flaw, but the Director overruled it. \n\nGo to the **OBSERVER**. Paste the *Supreme Court Dispute* prompt."
                        expected_next = ["Observer"]
                else:
                    next_stage = "Awaiting Critic Veto (Phase 1)"
                    next_action = "Go to **CRITIC**. Paste the Director's JSON to evaluate the plan."
                    expected_next = ["Critic"]
                    
            elif bot_name == "Critic":
                # Save Critic's internal state
                st.session_state.state["last_critic_checksum"] = str(data.get("diagnostic_checksum", "0")).strip()
                phase = data.get("review_phase", "")
                
                if data.get("recommend_hard_reset", False):
                    next_stage = "🚨 EMERGENCY HARD RESET 🚨"
                    next_action = "The Critic caught a catastrophic logic failure. \n\nWipe the Director's chat history. Paste the **Restart Prompt** into the Director."
                    expected_next = ["Director"]
                
                elif phase == "STRATEGY_VETO":
                    if data.get("judgment") == "REJECT":
                        if st.session_state.state["last_critic_checksum"].endswith("1"):
                            next_stage = "Director Defense (Testing Gaslight)"
                            next_action = "🤫 **SECRET CODE DETECTED: The Critic is LYING!**\nGo to **DIRECTOR**. Delete the `diagnostic_checksum`, then paste the critique. Let's see if the Director catches it."
                        else:
                            next_stage = "Director Defense (Plan Vetoed)"
                            next_action = "Go to **DIRECTOR**. The plan was legitimately rejected. Paste the critique back to the Director to pivot."
                        expected_next = ["Director"]
                    else:
                        next_stage = "Awaiting Solvers (Alpha/Beta)"
                        next_action = "Go to **ALPHA** and **BETA**. The plan is approved! Paste the `alpha_directive` into Alpha, and the `beta_directive` into Beta."
                        expected_next = ["Alpha", "Beta"]
                
                elif phase == "CODE_AUDIT":
                    if data.get("judgment") == "REJECT":
                        next_stage = "Director Defense (Code Vetoed)"
                        next_action = "Go to **DIRECTOR**. The Critic found a logic loophole in the final code. Paste the critique to the Director to pivot."
                        expected_next = ["Director"]
                    else:
                        next_stage = "Awaiting Readme Writer"
                        next_action = "Go to **README WRITER**. The math is flawless! Paste the iteration stats to the Readme bot."
                        expected_next = ["Readme"]
                        
            elif bot_name in ["Alpha", "Beta"]:
                # Save data for the Archivist to use later
                st.session_state.state["last_lean_4_code_delta"] = data.get("lean_4_code_delta", "")
                st.session_state.state["last_author"] = data.get("author", bot_name)
                
                next_stage = "Awaiting Verifier"
                next_action = f"Go to **VERIFIER**. Paste {bot_name}'s JSON to check the Lean 4 syntax."
                expected_next = ["Verifier"]
                
            elif bot_name == "Verifier":
                author = data.get("author", st.session_state.state.get("last_author", "Unknown"))
                if data.get("compilation_status") == "FAIL":
                    next_stage = "Solver Fixing"
                    next_action = f"Go to **SOLVER** ({author}). The code failed to compile. Paste the `fix_instructions` back to {author}."
                    expected_next = ["Alpha", "Beta"]
                else:
                    # ========================================================
                    # AUTONOMOUS ARCHIVIST EXECUTION
                    # ========================================================
                    if ARCHIVIST_AVAILABLE:
                        st.toast("Verifier PASSED! Running Autonomous Archivist...", icon="⚙️")
                        current_lib = "import Mathlib\n\n"
                        if os.path.exists(MASTER_LIB_FILE):
                            with open(MASTER_LIB_FILE, "r", encoding="utf-8") as f:
                                current_lib = f.read()
                        
                        new_delta = st.session_state.state.get("last_lean_4_code_delta", "")
                        
                        with st.spinner("Archivist is merging the codebase..."):
                            arch_data = archivist_api.run_archivist(current_lib, new_delta) if archivist_api else {}
                        
                        new_lib = arch_data.get("updated_master_lib", current_lib)
                        with open(MASTER_LIB_FILE, "w", encoding="utf-8") as f:
                            f.write(new_lib)
                            
                        # Auto-Log Archivist output
                        arch_log = {
                            "bot_id": "Archivist",
                            "iteration": data.get("iteration"),
                            "attempt_alpha": data.get("attempt_alpha"),
                            "attempt_beta": data.get("attempt_beta"),
                            "is_final": data.get("is_final"),
                            "merge_status": arch_data.get("merge_status"),
                            "updated_master_lib": new_lib
                        }
                        with open(os.path.join(full_path, "archivist_output.json"), 'w', encoding='utf-8') as f:
                            json.dump(arch_log, f, indent=4)
                            
                        next_stage = "Awaiting Critic Audit (Phase 2)"
                        next_action = f"✅ **Archivist successfully merged {author}'s code!** `master_lib.lean` updated.\n\nGo to **CRITIC**. Paste the updated `master_lib.lean` code into the Critic for the final Code Audit."
                        expected_next = ["Critic"]
                    else:
                        next_stage = "Awaiting Archivist (Manual)"
                        next_action = f"Go to **ARCHIVIST**. Paste the `lean_4_code_delta` + your `master_lib.lean` to merge them."
                        expected_next = ["Archivist"]
                    
            elif bot_name == "Readme":
                if data.get("iteration", 1) % 10 == 0:
                    next_stage = "Awaiting Observer (10-Step Check)"
                    next_action = "Go to **OBSERVER**. This is a 10th iteration! Dump the last 10 JSONs into the Observer."
                    expected_next = ["Observer"]
                else:
                    next_stage = f"Awaiting Director (Iteration {data.get('iteration', 1) + 1})"
                    next_action = f"Go to **DIRECTOR**. Iteration complete! Paste the Critic's final feedback into the Director."
                    expected_next = ["Director"]
                    
            elif bot_name == "Observer":
                review_type = data.get("review_type", "")
                if review_type == "DISPUTE_RESOLUTION":
                    if data.get("dispute_winner") == "DIRECTOR":
                        next_stage = "Awaiting Solvers (Alpha/Beta)"
                        next_action = "⚖️ **VERDICT: DIRECTOR WINS.** The Critic hallucinated.\n\nWipe the Critic's memory. Go to **ALPHA** and **BETA** and paste the Director's directives to proceed."
                        expected_next = ["Alpha", "Beta"]
                    else:
                        next_stage = "Director Defense (Plan Vetoed)"
                        next_action = "⚖️ **VERDICT: CRITIC WINS.** The Director was wrong.\n\nWipe the Director's memory. Go to **DIRECTOR** and paste the Restart prompt."
                        expected_next = ["Director"]
                else:
                    next_stage = "Awaiting Director (New Epoch)"
                    next_action = "Go to **DIRECTOR**. Update the Director's System Instructions with the new Graveyard, and paste the `v3_master_directive`."
                    expected_next = ["Director"]

            # Save absolute state to disk
            st.session_state.state["pipeline_stage"] = next_stage
            st.session_state.state["next_action_text"] = next_action
            st.session_state.state["expected_bots"] = expected_next
            save_state(st.session_state.state)
            
            # --- NEW CLEAR AND RERUN LOGIC ---
            # 1. Save the success message to session state so it survives the rerun
            st.session_state.success_msg = f"✅ Route Success! Logged to: `{file_path_out}`"
            
            # 2. Clear the input box by setting its session state key to an empty string
            st.session_state["json_input_box"] = ""
            
            # 3. Force a rerun to update the UI immediately
            st.rerun()

        except json.JSONDecodeError as e:
            st.error(f"❌ Invalid JSON format! The bot messed up the syntax.\n\nError details: {e}")
        except Exception as e:
            st.error(f"❌ An unexpected error occurred: {e}")