import Mathlib.Data.Fintype.Basic
import Mathlib.Data.Matrix.Basic

/-! ## Alphabet, States, and Directions -/

inductive Symbol where | zero | one | blank deriving DecidableEq, Fintype

inductive State where | q0 | q1 | qAccept | qReject deriving DecidableEq, Fintype

inductive Dir where | L | R | N deriving DecidableEq

/-! ## Tape Cell and Tableau -/

abbrev Cell := Symbol × Option State

def Tableau (T : ℕ) (S : Type*) [Fintype S] [DecidableEq S] :=
  Matrix (Fin T) S Cell

/-! ## Local Transition Function -/

structure LocalTransition where
  δ : Symbol → Symbol → Symbol → State → (Symbol × Option State × Dir)

/-! ## Global Transition (deterministic, local, 3‑neighbourhood) -/

def globalTransition {S : Type*} [Fintype S] [DecidableEq S]
    (δ : LocalTransition) (succ pred : S → S)
    (config : S → Cell) : S → Cell :=
  fun p =>
    let left_sym  := (config (pred p)).1
    let mid_sym   := (config p).1
    let right_sym := (config (succ p)).1
    let cur_head : Option State := (config p).2
    let cur_state : State := cur_head.getD State.q0
    let (new_sym, new_head_opt, move) := δ.δ left_sym mid_sym right_sym cur_state
    let left_cell := config (pred p)
    let right_cell := config (succ p)
    let left_state := left_cell.2
    let right_state := right_cell.2
    let head_from_left : Option State :=
      if left_state.isSome then
        let l_l_sym := (config (pred (pred p))).1
        let l_m_sym := left_sym
        let l_r_sym := mid_sym
        let (_, _, l_move) := δ.δ l_l_sym l_m_sym l_r_sym left_state.getD State.q0
        if l_move = Dir.R then left_state else none
      else none
    let head_from_right : Option State :=
      if right_state.isSome then
        let r_l_sym := mid_sym
        let r_m_sym := right_sym
        let r_r_sym := (config (succ (succ p))).1
        let (_, _, r_move) := δ.δ r_l_sym r_m_sym r_r_sym right_state.getD State.q0
        if r_move = Dir.L then right_state else none
      else none
    let final_head : Option State :=
      if new_head_opt.isSome then new_head_opt
      else if head_from_left.isSome then head_from_left
      else if head_from_right.isSome then head_from_right
      else none
    (new_sym, final_head)

/-! ## Uniqueness of the Computation Tableau -/

theorem tableau_unique {S : Type*} [Fintype S] [DecidableEq S]
    (δ : LocalTransition) (succ pred : S → S)
    (init : S → Cell) (T : ℕ) :
    ∃! (tab : Tableau T S),
      (∀ p, tab 0 p = init p) ∧
      (∀ t : Fin (T-1), tab t.succ = globalTransition δ succ pred (tab t)) := by
  -- Define the sequence of configurations by primitive recursion
  let configSeq : ℕ → (S → Cell) :=
    Nat.rec init (fun _ cfg => globalTransition δ succ pred cfg)
  -- Build the tableau from the sequence
  let tab : Tableau T S := fun i p => configSeq i.val p
  -- Verify the defining properties
  have h_init : ∀ p, tab 0 p = init p := by
    intro p
    simp [tab, configSeq]
  have h_step : ∀ t : Fin (T-1), tab t.succ = globalTransition δ succ pred (tab t) := by
    intro t
    ext p
    simp [tab, configSeq]
    rfl
  -- Existence
  have h_ex : ∃ tab, (∀ p, tab 0 p = init p) ∧
      (∀ t : Fin (T-1), tab t.succ = globalTransition δ succ pred (tab t)) :=
    ⟨tab, h_init, h_step⟩
  -- Uniqueness
  apply existsUnique_of_exists_unique h_ex
  intro tab1 tab2 h1 h2
  ext i p
  induction i using Fin.induction with
  | zero =>
      simp [h1.1 p, h2.1 p]
  | succ i hi =>
      have : i.val < T - 1 := by
        have : i.val + 1 < T := i.succ.isLt
        omega
      let i' : Fin (T-1) := ⟨i.val, this⟩
      specialize hi p
      rw [← h1.2 i', ← h2.2 i'] at hi
      exact hi
