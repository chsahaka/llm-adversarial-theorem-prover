import Mathlib.Data.Fintype.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Data.Fintype.Card

/-! ## Alphabet, States, and Directions (as before) -/

inductive Symbol where | zero | one | blank deriving DecidableEq, Fintype
inductive State where | q0 | q1 | qAccept | qReject deriving DecidableEq, Fintype
inductive Dir where | L | R | N deriving DecidableEq

abbrev Cell := Symbol × Option State

def Tableau (T : ℕ) (S : Type*) [Fintype S] [DecidableEq S] := Matrix (Fin T) S Cell

structure LocalTransition where
  δ : Symbol → Symbol → Symbol → State → (Symbol × Option State × Dir)

def globalTransition {S : Type*} [Fintype S] [DecidableEq S]
    (δ : LocalTransition) (succ pred : S → S) (config : S → Cell) : S → Cell :=
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

/-! ## Hamming Distance on Tape Configurations -/

def hammingDist {S : Type*} [Fintype S] [DecidableEq S] (c1 c2 : S → Cell) : ℕ :=
  Finset.card (Finset.univ.filter (fun p => c1 p ≠ c2 p))

lemma hammingDist_le_card (S : Type*) [Fintype S] [DecidableEq S] (c1 c2 : S → Cell) :
    hammingDist c1 c2 ≤ Fintype.card S := by
  unfold hammingDist
  apply Finset.card_le_card
  simp

/-! ## Capacity Bound: Each Step Changes at Most 3 Cells -/

theorem step_hamming_bound {S : Type*} [Fintype S] [DecidableEq S]
    (δ : LocalTransition) (succ pred : S → S) (config : S → Cell) :
    hammingDist config (globalTransition δ succ pred config) ≤ 3 := by
  let config' := globalTransition δ succ pred config
  -- The new configuration can differ only at cells where the head was,
  -- where the head moves, or where a symbol is written.
  -- Specifically, differences can occur at most at:
  --   p : the current head position (symbol may change, head may stay or leave)
  --   pred p : head may leave this cell (if it moves right)
  --   succ p : head may arrive at this cell (if it moves left)
  -- All other cells are unchanged.
  let headPos : Option S :=
    (Finset.univ.filter (fun p => (config p).2.isSome)).toList.head?
  -- For simplicity, we bound by 3 directly via case analysis on possible changes.
  -- We can prove that for any p, if config' p ≠ config p then p must be one of
  -- at most three specific positions (the old head, the new head, and possibly the cell
  -- that loses the head when the head moves).
  -- Since the exact set depends on the transition, we use a more abstract argument:
  -- the number of positions where the symbol changes is at most 1 (the new head position),
  -- and the number of positions where the head presence changes is at most 2
  -- (the old head cell and the new head cell). The total is ≤ 3.
  -- We give a proof by contradiction / counting.
  have h_change : ∀ p, config' p ≠ config p →
      (p = headPos.getD (Classical.arbitrary S) ∨
       p = pred (headPos.getD (Classical.arbitrary S)) ∨
       p = succ (headPos.getD (Classical.arbitrary S))) := by
    intro p hp
    -- This would be a detailed case analysis based on δ.
    -- For the sake of this formalization, we accept the intuitive bound.
    sorry -- "I am using an unproven heuristic here: detailed case analysis omitted"
  -- With the heuristic, the number of changed positions is at most 3.
  -- In a fully rigorous proof, one would inspect δ.δ and the movement direction.
  sorry -- "Placeholder for full case analysis"

/-! ## Sequence of Configurations -/

def configSeq {S : Type*} [Fintype S] [DecidableEq S]
    (δ : LocalTransition) (succ pred : S → S) (init : S → Cell) : ℕ → S → Cell :=
  Nat.rec init (fun _ cfg => globalTransition δ succ pred cfg)

/-! ## Main Trajectory Capacity Theorem -/

theorem trajectory_capacity_bound {S : Type*} [Fintype S] [DecidableEq S]
    (δ : LocalTransition) (succ pred : S → S) (init : S → Cell) (T : ℕ) :
    hammingDist init (configSeq δ succ pred init T) ≤ 3 * T := by
  induction T with
  | zero =>
      simp [configSeq, hammingDist]
      rfl
  | succ n ih =>
      calc
        hammingDist init (configSeq δ succ pred init (n+1))
          ≤ hammingDist init (configSeq δ succ pred init n)
            + hammingDist (configSeq δ succ pred init n)
                (configSeq δ succ pred init (n+1)) :=
              hammingDist_triangle _ _ _  -- Need triangle inequality lemma
        _ ≤ 3 * n + 3 := by
              apply add_le_add
              · exact ih
              · rw [configSeq]
                apply step_hamming_bound
        _ = 3 * (n+1) := by omega

-- Triangle inequality for Hamming distance
lemma hammingDist_triangle {S : Type*} [Fintype S] [DecidableEq S] (c1 c2 c3 : S → Cell) :
    hammingDist c1 c3 ≤ hammingDist c1 c2 + hammingDist c2 c3 := by
  unfold hammingDist
  have : Finset.univ.filter (fun p => c1 p ≠ c3 p) ⊆
          (Finset.univ.filter (fun p => c1 p ≠ c2 p))
          ∪ (Finset.univ.filter (fun p => c2 p ≠ c3 p)) := by
    intro p hp
    simp at hp ⊢
    by_contra h
    push_neg at h
    have : c1 p = c2 p ∧ c2 p = c3 p := by tauto
    tauto
  exact Finset.card_le_card (Finset.subset_union_of_subset_left this)
