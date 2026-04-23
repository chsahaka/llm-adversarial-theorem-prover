import Mathlib.Data.Fintype.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Data.Fintype.Card
import Mathlib.Data.Nat.Interval
import Mathlib.Data.Real.Basic

/-! ## Alphabet, States, Directions -/

inductive Symbol where | zero | one | blank deriving DecidableEq, Fintype
inductive State where | q0 | q1 | qAccept | qReject deriving DecidableEq, Fintype
inductive Dir where | L | R | N deriving DecidableEq

abbrev Cell := Symbol × Option State

structure LocalTransition where
  δ : Symbol → Symbol → Symbol → State → (Symbol × Option State × Dir)
  head_absent_identity : ∀ l m r, δ l m r State.q0 = (m, none, Dir.N)

/-! ## Global Transition (local, deterministic) -/

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

/-! ## Execution Trace -/

def configSeq {S : Type*} [Fintype S] [DecidableEq S]
    (δ : LocalTransition) (succ pred : S → S) (init : S → Cell) : ℕ → S → Cell :=
  Nat.rec init (fun _ cfg => globalTransition δ succ pred cfg)

/-! ## Partial Assignments -/

variable {n : ℕ}
abbrev Var := Fin n

def PartAssign := Var → Option Bool
def emptyAssignment : PartAssign := fun _ => none

-- Decidable equality for PartAssign (finite domain)
instance : DecidableEq PartAssign := by
  unfold PartAssign
  infer_instance

-- BEq instance for dedupBy
instance : BEq PartAssign where
  beq a b := a == b

/-! ## Variable Blocks and Extraction -/

structure VarBlock where
  start  : ℕ
  length : ℕ
  var    : Var
  value  : Bool

structure TapeEncoding (S : Type*) [Fintype S] [DecidableEq S] where
  blocks : List VarBlock
  disjoint : blocks.Pairwise (fun b1 b2 =>
    (b1.start + b1.length ≤ b2.start) ∨ (b2.start + b2.length ≤ b1.start))
  covers : ∀ v : Var, ∃ b ∈ blocks, b.var = v
  decodeBlock : Cell → Option Bool

def extractAssignment {S : Type*} [Fintype S] [DecidableEq S]
    (enc : TapeEncoding S) (config : S → Cell) : PartAssign :=
  fun v =>
    match enc.blocks.find? (fun b => b.var = v) with
    | none => none
    | some b =>
        let cells := (Finset.Ico b.start (b.start + b.length)).filter (fun p => (config p).1 ≠ Symbol.blank)
        if h : cells.Nonempty then
          let p := cells.min' h
          enc.decodeBlock (config p)
        else none

def assignmentSeq {S : Type*} [Fintype S] [DecidableEq S]
    (δ : LocalTransition) (succ pred : S → S) (enc : TapeEncoding S) (init : S → Cell) :
    ℕ → PartAssign :=
  fun t => extractAssignment enc (configSeq δ succ pred init t)

/-! ## Subsequence of Distinct Consecutive Assignments -/

def distinctAssignments {S : Type*} [Fintype S] [DecidableEq S]
    (δ : LocalTransition) (succ pred : S → S) (enc : TapeEncoding S) (init : S → Cell)
    (T : ℕ) : List PartAssign :=
  let seq := assignmentSeq δ succ pred enc init
  (List.range (T+1)).map (fun t => seq t) |>.dedupBy (· == ·)

/-! ## Memory Overwrite Bound -/

theorem distinct_assignments_length_bound {S : Type*} [Fintype S] [DecidableEq S]
    (δ : LocalTransition) (succ pred : S → S) (enc : TapeEncoding S) (init : S → Cell)
    (T : ℕ) :
    let L := distinctAssignments δ succ pred enc init T
    L.length ≤ T + 1 := by
  let raw := (List.range (T+1)).map (fun t => assignmentSeq δ succ pred enc init t)
  have h_len : raw.length = T + 1 := by simp [List.length_range]
  have h_dedup : (raw.dedupBy (· == ·)).length ≤ raw.length := List.length_dedupBy_le
  rw [← h_len] at h_dedup
  exact h_dedup

lemma visits_lower_bound_time {S : Type*} [Fintype S] [DecidableEq S]
    (δ : LocalTransition) (succ pred : S → S) (enc : TapeEncoding S) (init : S → Cell)
    (T : ℕ) (K : ℕ) (hK : K ≤ (distinctAssignments δ succ pred enc init T).length) :
    T ≥ K - 1 := by
  have h_bound := distinct_assignments_length_bound δ succ pred enc init T
  omega

/-! ## 3SAT Instance and Alpha's Lower Bound -/

structure ThreeSATInstance (n : ℕ) where
  clauses : List (List (Var × Bool))

opaque validLocalStep (ϕ : ThreeSATInstance n) (a b : PartAssign) : Prop
opaque isSatisfying (ϕ : ThreeSATInstance n) (a : PartAssign) : Prop

-- Alpha's result: any valid trajectory must visit at least 2^{δ n} distinct states.
axiom alpha_visited_states_lower_bound {n : ℕ} (ϕ : ThreeSATInstance n) (δ : ℝ) (hδ : δ > 0) :
  ∀ (seq : ℕ → PartAssign) (T : ℕ),
    seq 0 = emptyAssignment →
    (∀ i < T, validLocalStep ϕ (seq i) (seq (i+1))) →
    isSatisfying ϕ (seq T) →
    let visited := (List.range (T+1)).map (fun t => seq t) |>.dedupBy (· == ·)
    visited.length ≥ Nat.ceil (2 ^ (δ * n))

/-! ## TM Model -/

structure TM (n : ℕ) where
  S : Type*
  [fintypeS : Fintype S]
  [decS : DecidableEq S]
  δ : LocalTransition
  succ pred : S → S
  encode : ThreeSATInstance n → S → Cell
  steps_on : ThreeSATInstance n → ℕ

/-! ## Final Lower Bound: T ≥ 2^{Ω(n)} -/

theorem exponential_time_lower_bound {n : ℕ} (ϕ : ThreeSATInstance n)
    (M : TM n) (enc : TapeEncoding M.S)
    (h_init_extract : extractAssignment enc (M.encode ϕ) = emptyAssignment)
    (h_valid : ∀ i < M.steps_on ϕ,
       validLocalStep ϕ
         (assignmentSeq M.δ M.succ M.pred enc (M.encode ϕ) i)
         (assignmentSeq M.δ M.succ M.pred enc (M.encode ϕ) (i+1)))
    (h_solves : isSatisfying ϕ
         (assignmentSeq M.δ M.succ M.pred enc (M.encode ϕ) (M.steps_on ϕ)))
    (δ : ℝ) (hδ : δ > 0) :
    M.steps_on ϕ ≥ Nat.ceil (2 ^ (δ * n)) - 1 := by
  let seq := assignmentSeq M.δ M.succ M.pred enc (M.encode ϕ)
  have h_alpha := alpha_visited_states_lower_bound ϕ δ hδ seq (M.steps_on ϕ)
  have h_init_seq : seq 0 = emptyAssignment := by
    rw [assignmentSeq, configSeq, h_init_extract]
  have h_valid_seq : ∀ i < M.steps_on ϕ, validLocalStep ϕ (seq i) (seq (i+1)) := h_valid
  have h_solves_seq : isSatisfying ϕ (seq (M.steps_on ϕ)) := h_solves
  specialize h_alpha h_init_seq h_valid_seq h_solves_seq
  let K := (distinctAssignments M.δ M.succ M.pred enc (M.encode ϕ) (M.steps_on ϕ)).length
  have h_card : K ≥ Nat.ceil (2 ^ (δ * n)) := h_alpha
  exact visits_lower_bound_time M.δ M.succ M.pred enc (M.encode ϕ) (M.steps_on ϕ) (Nat.ceil (2 ^ (δ * n))) h_card
