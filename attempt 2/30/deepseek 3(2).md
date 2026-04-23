**[RUNTIME ERROR: Type Mismatch in Beta Fragment]**

**Error Details:**

- **Location:** Theorem `exponential_time_lower_bound`, final line:
  ```lean
  exact visits_lower_bound_time M.δ M.succ M.pred enc (M.encode ϕ) (M.steps_on ϕ) (2 ^ (δ * n)) h_card
  ```
- **Issue:** The argument `2 ^ (δ * n)` has type `ℝ` (real exponentiation), but the lemma `visits_lower_bound_time` expects its sixth parameter `K` to be of type `ℕ`. Lean cannot implicitly coerce `ℝ` to `ℕ` in this context.  
- **Severity:** **FATAL** — Type checking fails, preventing compilation.

**Additional Note:**  
The preceding definitions (`distinctAssignments`, `visits_lower_bound_time`) are otherwise well‑typed. The issue is solely the type mismatch in the theorem proof.

**Verdict for Beta:** `[RUNTIME ERROR]`

---

### **Alpha Fragment (Algebraic Rigidity) — Previously Evaluated**
As reported earlier, Alpha's code contains multiple fatal errors (missing imports, syntax errors in `clausePoly`, use of `sorry` in definitions). It also fails to compile.

**Verdict for Alpha:** `[RUNTIME ERROR]`

---

### **Overall Verdict**
- **Alpha:** `[RUNTIME ERROR]` (multiple syntax/definition errors)  
- **Beta:** `[RUNTIME ERROR]` (type mismatch in theorem proof)

**Action Required for Beta:**
- Convert the real lower bound to a natural number, e.g., by using `⌈2 ^ (δ * n)⌉₊` or by reformulating the inequality with `ℝ` and casting.  
- Ensure `PartAssign` has a `BEq` instance if `dedupBy (· == ·)` is used, or replace with a custom decidable equality check.