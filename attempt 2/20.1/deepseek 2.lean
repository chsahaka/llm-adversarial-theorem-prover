import Mathlib.Data.Fintype.Basic
import Mathlib.Data.Matrix.Basic

/-- Tape symbols (finite alphabet) -/
inductive Symbol where | zero | one | blank deriving DecidableEq, Fintype

/-- Internal states of the TM (including halting states) -/
inductive State where | q0 | q1 | qAccept | qReject deriving DecidableEq, Fintype

/-- Head movement directions -/
inductive Dir where | L | R | N deriving DecidableEq

/-- Configuration of a single tape cell at a fixed time -/
abbrev Cell := Symbol × Option State   -- (symbol, head presence with state)

/-- 2D Tableau: T time steps, S spatial positions -/
def Tableau (T : ℕ) (S : Type*) [Fintype S] [DecidableEq S] :=
  Matrix (Fin T) S Cell

/-- Local transition function type:
    Input: left symbol, current symbol, right symbol, current state (if head present)
    Output: new symbol, new state (None if head moves away), head movement -/
structure LocalTransition where
  δ : Symbol → Symbol → Symbol → State → (Symbol × Option State × Dir)

/-- Global transition for the whole tape, given successor/predecessor functions on S -/
def globalTransition {S : Type*} [Fintype S] [DecidableEq S]
    (δ : LocalTransition) (succ pred : S → S)
    (config : S → Cell) : S → Cell :=
  fun p =>
    let left_sym  := (config (pred p)).1
    let mid_sym   := (config p).1
    let right_sym := (config (succ p)).1
    -- Determine current head state at this cell (if any)
    let head_state : State :=
      match config p with
      | (_, some q) => q
      | (_, none)   => State.q0  -- dummy, ignored when head absent
    let (new_sym, new_head_opt, move) := δ.δ left_sym mid_sym right_sym head_state
    -- Determine final head presence at cell p based on movement from neighbours.
    -- A cell acquires the head if the head moves from left (R) or from right (L).
    let head_from_left  : Option State :=
      match config (pred p) with
      | (_, some q) => if δ.δ (config (pred (pred p))).1 left_sym mid_sym q = (_, _, Dir.R)
                       then some q else none
      | _ => none
    let head_from_right : Option State :=
      match config (succ p) with
      | (_, some q) => if δ.δ mid_sym right_sym (config (succ (succ p))).1 q = (_, _, Dir.L)
                       then some q else none
      | _ => none
    let final_head : Option State :=
      if new_head_opt.isSome then new_head_opt   -- head stayed here
      else if head_from_left.isSome then head_from_left
      else if head_from_right.isSome then head_from_right
      else none
    (new_sym, final_head)

/-- Theorem: For a fixed deterministic TM and initial tape configuration,
    there exists exactly one tableau extending the initial configuration. -/
theorem tableau_unique {S : Type*} [Fintype S] [DecidableEq S]
    (δ : LocalTransition) (succ pred : S → S)
    (init : S → Cell) (T : ℕ) :
    ∃! (tab : Tableau T S),
      (∀ p, tab 0 p = init p) ∧
      (∀ t : Fin (T-1), tab t.succ = globalTransition δ succ pred (tab t)) := by
  -- The proof is by straightforward induction on T using the deterministic
  -- nature of globalTransition, which is a pure function.
  apply existsUnique_of_exists_unique
  · -- Existence: construct tableau by recursion
    exact ⟨fun t p => Nat.recOn t (fun _ => init p) (fun n rec => globalTransition δ succ pred rec) p,
           by simp, by simp⟩
  · -- Uniqueness: any two tableaus satisfying the recurrence must be equal
    intro tab1 tab2 h1 h2
    ext t p
    induction t with
    | zero => simp [h1.1, h2.1]
    | succ n ih =>
      have := congrFun (h1.2 n) p
      have := congrFun (h2.2 n) p
      simp [ih, this]
  done
