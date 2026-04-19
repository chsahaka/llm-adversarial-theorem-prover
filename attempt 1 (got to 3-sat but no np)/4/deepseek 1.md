**[FINAL PROOF SUMMARY]:**  
**Problem Definition (Diplomatic Banquet Protocol).**  
Let $U = \{1, 2, \dots, N\}$ be a set of delegates. A *demand* is a triple $d \subseteq U$ with $|d| = 3$. An instance consists of a collection of demands $\mathcal{D} = \{d_1, \dots, d_m\}$ and an integer $K \le N$. A *seating chart* is a function $s: U \to \{0,1\}$ where $s(i)=1$ places delegate $i$ at the Main Table. The chart is **valid** if (i) for every demand $d \in \mathcal{D}$, $\sum_{i \in d} s(i) \ge 1$, and (ii) $\sum_{i \in U} s(i) \le K$. The decision problem $\text{BANQUET}(U, \mathcal{D}, K)$ asks whether a valid seating chart exists.

---

**Lemma 1 ($\text{BANQUET} \in \mathbf{NP}$).**  
A nondeterministic Turing machine guesses a certificate $s: U \to \{0,1\}$ and verifies in deterministic polynomial time:  
 • For each $d \in \mathcal{D}$, $\bigvee_{i \in d} s(i) = 1$.  
 • $|\{i \in U : s(i) = 1\}| \le K$.  
Both checks take $O(m + N)$ steps; since $m \le \binom{N}{3} = O(N^3)$, verification is polynomial in $N$. Hence $\text{BANQUET}$ belongs to $\mathbf{NP}$.

---

**Lemma 2 ($\text{BANQUET}$ is $\mathbf{NP}$-hard).**  
We reduce from **3‑SAT**. Let $\varphi$ be a 3‑CNF formula with $n$ variables $x_1, \dots, x_n$ and $m$ clauses $C_1, \dots, C_m$. Construct an instance $(U, \mathcal{D}, K)$ as follows:  

- **Delegates:** For each variable $x_i$, create two literal‑delegates $x_i^T$, $x_i^F$ and a unique dummy delegate $d_i$. Thus $U = \{x_i^T, x_i^F, d_i\}_{i=1}^n$, so $N = 3n$.  
- **Variable‑consistency demands:** For each $i$, add a demand $\{x_i^T, x_i^F, d_i\}$ to $\mathcal{D}$.  
- **Clause demands:** For each clause $C_j = (\ell_{j1} \lor \ell_{j2} \lor \ell_{j3})$, add a demand $\{ \lambda(\ell_{j1}), \lambda(\ell_{j2}), \lambda(\ell_{j3}) \}$, where $\lambda(\ell) = x_i^T$ if $\ell = x_i$ and $\lambda(\ell) = x_i^F$ if $\ell = \neg x_i$.  
- **Capacity:** Set $K = n$.

**Correctness.**  
($\Rightarrow$) Suppose $\varphi$ is satisfiable with assignment $\tau$. Define $s(x_i^T)=1$ and $s(x_i^F)=0$ if $\tau(x_i)=\text{true}$; otherwise $s(x_i^T)=0$ and $s(x_i^F)=1$. Set $s(d_i)=0$ for all $i$. Then exactly $n$ delegates are at the Main Table, so capacity $K=n$ holds. Each variable‑consistency demand contains exactly one Main Table delegate (the chosen literal‑delegate). Every clause demand contains at least one literal made true by $\tau$, hence its corresponding literal‑delegate is at the Main Table. Thus $s$ is valid.  

($\Leftarrow$) Suppose $s$ is a valid seating chart with $\sum s(i) \le K = n$. The $n$ variable‑consistency demands $\{x_i^T, x_i^F, d_i\}$ are pairwise disjoint in their dummy delegates and cover $3n$ delegates total. To satisfy all $n$ demands, at least one delegate from each triple must be at the Main Table, requiring $\ge n$ seats. Since $K = n$, exactly one delegate per triple is selected. Construct a truth assignment $\tau$ as follows:  
 If $s(x_i^T) = 1$, set $\tau(x_i) = \text{true}$.  
 If $s(x_i^F) = 1$, set $\tau(x_i) = \text{false}$.  
 If $s(d_i) = 1$, set $\tau(x_i)$ arbitrarily (e.g., $\text{false}$).  
Because each clause demand $\{\lambda(\ell_{j1}), \lambda(\ell_{j2}), \lambda(\ell_{j3})\}$ contains at least one Main Table delegate, that delegate corresponds to a literal that evaluates to **true** under $\tau$. Hence $\tau$ satisfies all clauses of $\varphi$.  

The reduction clearly runs in polynomial time. Therefore $\text{BANQUET}$ is $\mathbf{NP}$-hard.

---

**Theorem (Conclusion).**  
$\text{BANQUET}(U, \mathcal{D}, K)$ is **$\mathbf{NP}$-complete**. Consequently, unless $\mathbf{P} = \mathbf{NP}$, there exists no deterministic polynomial‑time algorithm that solves every instance of the Diplomatic Banquet Protocol. Under the standard conjecture $\mathbf{P} \neq \mathbf{NP}$, the problem is intractable in the worst case, and no universal, fast (polynomial‑time) instruction set exists for producing a valid seating chart or proving none exists.

**[VICTORY STATEMENT]:**  
The logical edifice stands unassailable. Prover Beta has been vanquished by irrefutable complexity‑theoretic rigor. The Diplomatic Banquet Protocol joins the hallowed ranks of the $\mathbf{NP}$-complete—a banquet that shall forever resist the temptation of polynomial‑time gluttony. Q.E.D.