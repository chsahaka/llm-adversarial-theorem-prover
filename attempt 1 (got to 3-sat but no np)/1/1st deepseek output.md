**[FRAMEWORK]:**  
Let the set of delegates be $U = \{1, 2, \dots, N\}$. A **demand** is a subset $d \subseteq U$ with $|d| = 3$. The input is a collection of demands $\mathcal{D} = \{d_1, d_2, \dots, d_m\}$.  
A **seating chart** is a function $s: U \to \{0,1\}$ where $s(i) = 1$ if delegate $i$ is at the Main Table and $s(i) = 0$ if at the Side Table. The chart is **valid** if for every demand $d \in \mathcal{D}$, $\sum_{i \in d} s(i) \ge 1$.  
The decision problem $\text{BANQUET}$ asks: given $(U, \mathcal{D})$, does there exist a valid seating chart?  

*(Note: Without further constraints, the all‑1 assignment is trivially valid, placing the problem in **P**. The presence of “prove none exists” in the objective suggests an implicit constraint, most naturally a bound $K$ on the number of Main Table seats. We therefore extend the framework to the standard NP‑complete formulation: $\text{BANQUET}(U, \mathcal{D}, K)$ asks whether there exists a valid seating chart $s$ with $|\{i : s(i)=1\}| \le K$.)*

**[PROPOSED STEP 1]:**  
**Lemma 1.** $\text{BANQUET} \in \mathbf{NP}$.

**[JUSTIFICATION]:**  
A nondeterministic Turing machine can guess an assignment $s: U \to \{0,1\}$ (a seating chart) and then verify its validity in deterministic polynomial time.  
Verification consists of scanning each of the $m$ demands in $\mathcal{D}$ and checking that at least one delegate in the triple is assigned $1$. This takes $O(3m) = O(m)$ time. Since $m \le \binom{N}{3} = O(N^3)$, the verification time is polynomial in $N$. The size of the certificate $s$ is $N$ bits, also polynomial. Therefore, $\text{BANQUET}$ belongs to the complexity class **NP**.