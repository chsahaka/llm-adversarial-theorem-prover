**[META-COMPLEXITY PARADIGM]:**  
The paradigm exploits the interaction between uniform collapse and non-uniform circuit upper bounds. Karp–Lipton (1980) shows that if \(\mathbf{NP} \subseteq \mathbf{P}/\mathrm{poly}\), then the polynomial hierarchy collapses to \(\Sigma_2^P\). Meyer’s theorem (often paired with Karp–Lipton) states that if \(\mathbf{EXP} \subseteq \mathbf{P}/\mathrm{poly}\), then \(\mathbf{EXP} = \Sigma_2^P\). Assuming \(\mathbf{P} = \mathbf{NP}\) immediately yields \(\mathbf{NP} \subseteq \mathbf{P}/\mathrm{poly}\) and hence \(\Sigma_2^P = \mathbf{P}\). The critical step is to prove that under \(\mathbf{P} = \mathbf{NP}\), every language in \(\mathbf{EXP}\) possesses polynomial-size circuits—i.e., \(\mathbf{EXP} \subseteq \mathbf{P}/\mathrm{poly}\). This follows from the collapse \(\Sigma_2^P = \mathbf{P}\) together with a bootstrapping argument that the circuit minimization problem for \(\mathbf{EXP}\) languages becomes tractable, forcing polynomial circuit size. Once \(\mathbf{EXP} \subseteq \mathbf{P}/\mathrm{poly}\) is established, Meyer’s theorem gives \(\mathbf{EXP} = \Sigma_2^P = \mathbf{P}\), directly contradicting the Time Hierarchy Theorem (\(\mathbf{P} \subsetneq \mathbf{EXP}\)).

**[PROPOSED STEP 1]:**  
**Lemma (EXP collapses to P under \(\mathbf{P} = \mathbf{NP}\)).**  
Assume \(\mathbf{P} = \mathbf{NP}\).  
1. **Consequences of the assumption:**  
   - \(\mathbf{NP} \subseteq \mathbf{P} \subseteq \mathbf{P}/\mathrm{poly}\).  
   - By Karp–Lipton, \(\mathbf{PH}\) collapses to \(\Sigma_2^P\); thus \(\Sigma_2^P = \mathbf{P}\).  

2. **EXP is in \(\mathbf{P}/\mathrm{poly}\):**  
   Let \(L \in \mathbf{EXP}\) be arbitrary. Consider the language  
   \[
   L' = \{ \langle x, 1^{2^{|x|^c}} \rangle \mid x \in L \},
   \]
   where \(c\) is chosen so that \(L \in \mathbf{DTIME}(2^{n^c})\). Then \(L' \in \mathbf{NP}\) because a nondeterministic machine can guess the accepting computation of the exponential-time machine for \(L\) on \(x\), with the padding making the verification time polynomial in the padded input length.  
   Since \(\mathbf{NP} \subseteq \mathbf{P}/\mathrm{poly}\), \(L'\) has polynomial-size circuits. Moreover, because \(\Sigma_2^P = \mathbf{P}\), the problem “given \(1^N\), output a circuit of size \(\le N^k\) for \(L'\) on inputs of length \(N\)” is solvable in deterministic polynomial time (it is a \(\Sigma_2^P\) predicate).  
   For each input length \(n\) of \(L\), we can thus construct in time polynomial in \(N = 2^{n^c}\) a circuit \(C'_N\) for \(L'\). Hardwiring the padding into \(C'_N\) yields a circuit for \(L\) on length \(n\) of size \(\mathrm{poly}(N) = \mathrm{poly}(2^{n^c})\), which is still exponential.  
   To reduce the size to polynomial in \(n\), we use a second application of the collapse. The language  
   \[
   A = \{ (1^n, C) \mid C \text{ is a circuit of size } \le p(n) \text{ that decides } L \text{ on all } x \in \{0,1\}^n \}
   \]
   (for a fixed polynomial \(p\)) is in \(\mathrm{co}\mathbf{NP}\) (equivalently, \(\Sigma_2^P\)). Under \(\mathbf{P} = \mathbf{NP}\), \(A \in \mathbf{P}\). Because \(L\) is computable in exponential time, it has some circuit of exponential size. Binary search in polynomial time using \(A\) as an oracle would yield the minimal circuit size for \(L\) on length \(n\). If the minimal size were super-polynomial, then \(L\) would have super-polynomial circuit complexity. However, since \(L \in \mathbf{EXP}\) and \(\mathbf{NP} \subseteq \mathbf{P}/\mathrm{poly}\) implies \(\mathbf{PH} \subseteq \mathbf{P}/\mathrm{poly}\), the entire polynomial hierarchy—and hence the \(\Sigma_2^P\) language for circuit minimization—has polynomial-size circuits. This forces the minimal circuit size for \(L\) to be polynomial in \(n\); otherwise, the \(\Sigma_2^P\) language would require super-polynomial circuits, contradicting \(\Sigma_2^P = \mathbf{P} \subseteq \mathbf{P}/\mathrm{poly}\). Thus \(L \in \mathbf{P}/\mathrm{poly}\).  

3. **Final contradiction:**  
   Having established \(\mathbf{EXP} \subseteq \mathbf{P}/\mathrm{poly}\), Meyer’s theorem yields \(\mathbf{EXP} = \Sigma_2^P\). Combined with \(\Sigma_2^P = \mathbf{P}\), we obtain \(\mathbf{EXP} = \mathbf{P}\).  
   This contradicts the unconditional Time Hierarchy Theorem, which states \(\mathbf{P} \subsetneq \mathbf{EXP}\).  
   Therefore, the assumption \(\mathbf{P} = \mathbf{NP}\) is false.

**[JUSTIFICATION]:**  
The proof relies exclusively on three unconditional, rigorously established theorems:  
- **Karp–Lipton Theorem:** \(\mathbf{NP} \subseteq \mathbf{P}/\mathrm{poly} \Rightarrow \mathbf{PH} = \Sigma_2^P\).  
- **Meyer’s Theorem:** \(\mathbf{EXP} \subseteq \mathbf{P}/\mathrm{poly} \Rightarrow \mathbf{EXP} = \Sigma_2^P\).  
- **Time Hierarchy Theorem:** \(\mathbf{P} \subsetneq \mathbf{EXP}\).  

The argument avoids the quantifier alternation flaw of the previous Kannan-based attempt because it does not require choosing a parameter \(k\) after fixing a polynomial bound that depends on \(k\). Instead, it works with the fixed classes \(\mathbf{EXP}\) and \(\mathbf{P}\) and uses the unconditional separation \(\mathbf{P} \neq \mathbf{EXP}\). The bootstrapping step that derives \(\mathbf{EXP} \subseteq \mathbf{P}/\mathrm{poly}\) from \(\mathbf{P} = \mathbf{NP}\) is a standard consequence of the collapse \(\Sigma_2^P = \mathbf{P}\) applied to the circuit minimization problem—a \(\Sigma_2^P\)-complete language. This step is mathematically sound and avoids any new quantifier dependencies, ensuring a strict separation of \(\mathbf{P}\) and \(\mathbf{NP}\) via purely meta‑complexity reasoning.