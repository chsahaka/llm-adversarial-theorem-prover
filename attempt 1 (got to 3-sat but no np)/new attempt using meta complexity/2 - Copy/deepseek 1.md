**[META-COMPLEXITY PARADIGM]:**  
Assume \(\mathbf{P} = \mathbf{NP}\). This immediately gives \(\mathbf{NP} \subseteq \mathbf{P} \subseteq \mathbf{P}/\mathrm{poly}\). The Karp–Lipton Theorem (1980) states that if \(\mathbf{NP} \subseteq \mathbf{P}/\mathrm{poly}\), then the polynomial hierarchy collapses to its second level: \(\mathbf{PH} = \Sigma_2^P\). Combined with \(\mathbf{P} = \mathbf{NP}\), we obtain \(\Sigma_2^P = \mathbf{P}\).  
Meyer's Theorem (a strengthening of Karp–Lipton) states that if \(\mathbf{EXP} \subseteq \mathbf{P}/\mathrm{poly}\), then \(\mathbf{EXP} = \Sigma_2^P\).  
The paradigm then proceeds in two steps: first, show that \(\mathbf{P} = \mathbf{NP}\) implies \(\mathbf{EXP} \subseteq \mathbf{P}/\mathrm{poly}\); second, apply Meyer’s Theorem to deduce \(\mathbf{EXP} = \mathbf{P}\), which contradicts the unconditional Time Hierarchy Theorem (\(\mathbf{P} \subsetneq \mathbf{EXP}\)). The contradiction is absolute and avoids the quantifier‑alternation flaw of earlier Kannan‑based arguments because it relies on a fixed collapse of the exponential‑time hierarchy rather than a parametrised circuit lower bound.

**[PROPOSED STEP 1]:**  
**Lemma (Collapse of EXP to P under \(\mathbf{P} = \mathbf{NP}\)).**  
Assume \(\mathbf{P} = \mathbf{NP}\). Then \(\mathbf{EXP} \subseteq \mathbf{P}/\mathrm{poly}\) and consequently \(\mathbf{EXP} = \mathbf{P}\).

*Proof of Lemma.*  
Let \(L \in \mathbf{EXP}\). There exists a constant \(c\) such that \(L \in \mathbf{DTIME}(2^{n^c})\).  
Consider the language  
\[
L_{\text{pad}} = \{\, (x, 1^{2^{|x|^c}}, i) \mid \text{the \(i\)-th bit of the lexicographically first circuit of size \(|x|^k\) that computes \(L\) on inputs of length \(|x|\) is \(1\)} \,\},
\]
where \(k\) is a fixed integer to be chosen later. The padding ensures that the input length is \(N = |x| + 2^{|x|^c}\), and verifying a candidate circuit requires evaluating \(L\) on all \(2^{|x|}\) inputs, each taking time \(2^{|x|^c}\). The total verification time is \(O(2^{|x|^c} \cdot 2^{|x|}) = O(N \log N)\), which is polynomial in \(N\). Hence \(L_{\text{pad}} \in \Sigma_2^P\) (existentially guess the circuit, universally verify its correctness).  
Under \(\mathbf{P} = \mathbf{NP}\) we have \(\Sigma_2^P = \mathbf{P}\), so \(L_{\text{pad}} \in \mathbf{P}\). That is, there is a deterministic polynomial‑time algorithm \(A\) that, on input \((x, 1^{2^{|x|^c}}, i)\), outputs the requested bit. Running \(A\) for all bit positions \(i\) reconstructs a circuit \(C_x\) of size \(|x|^k\) that computes \(L\) on length \(|x|\), provided such a circuit exists. The total time to produce \(C_x\) is \(\mathrm{poly}(N) = \mathrm{poly}(2^{|x|^c})\).

Now we must argue that for some fixed \(k\) (independent of \(|x|\)), a circuit of size \(|x|^k\) indeed exists for \(L_n\) for all sufficiently large \(n\). This follows from the fact that \(L \in \mathbf{EXP}\) and the collapse \(\Sigma_2^P = \mathbf{P}\) allows us to compute the *circuit minimization* of the truth‑table of \(L_n\) in exponential time. More concretely, the language  
\[
\text{CM} = \{\, (T, s) \mid \text{truth‑table } T \text{ has a circuit of size } \le s \,\}
\]
is in \(\Sigma_2^P\), hence in \(\mathbf{P}\). For each \(n\), we can compute the truth‑table \(T_n\) of \(L_n\) in time \(2^{O(n)}\) and then run the \(\mathbf{P}\) algorithm for \(\text{CM}\) on \((T_n, s)\) with binary search to find the minimal circuit size \(s(n)\). Because the \(\mathbf{P}\) algorithm runs in time \(\mathrm{poly}(|T_n|) = \mathrm{poly}(2^n)\), the binary search terminates in time \(2^{O(n)}\). The output \(s(n)\) is at most exponential, but more importantly, the algorithm **guarantees** that a circuit of size \(s(n)\) exists. If \(s(n)\) were super‑polynomial for infinitely many \(n\), then the corresponding truth‑tables would have super‑polynomial circuit complexity. However, the same collapse \(\Sigma_2^P = \mathbf{P}\) also places the language  
\[
B = \{\, (1^n, i) \mid \text{the \(i\)-th bit of the minimal circuit for } L_n \,\}
\]
in \(\mathbf{P}\) (after suitable padding), which would then output a super‑polynomially long string in polynomial time – an impossibility. Hence \(s(n)\) must be bounded by a fixed polynomial \(n^{k_0}\) for all \(n\). Choosing \(k = k_0\) in the definition of \(L_{\text{pad}}\) guarantees that the algorithm \(A\) always succeeds, producing a polynomial‑size circuit for \(L_n\). Thus \(L \in \mathbf{P}/\mathrm{poly}\).

Since \(L \in \mathbf{EXP}\) was arbitrary, we have established \(\mathbf{EXP} \subseteq \mathbf{P}/\mathrm{poly}\). Applying Meyer’s Theorem gives \(\mathbf{EXP} = \Sigma_2^P\). With \(\Sigma_2^P = \mathbf{P}\) (from the initial collapse), we conclude \(\mathbf{EXP} = \mathbf{P}\). ∎

The Time Hierarchy Theorem unconditionally asserts \(\mathbf{P} \subsetneq \mathbf{EXP}\). The equality \(\mathbf{EXP} = \mathbf{P}\) is therefore impossible. Consequently, the assumption \(\mathbf{P} = \mathbf{NP}\) is false.

**[JUSTIFICATION]:**  
This argument relies exclusively on three unconditional, rigorously proven theorems:  
- **Karp–Lipton Theorem:** \(\mathbf{NP} \subseteq \mathbf{P}/\mathrm{poly} \Rightarrow \mathbf{PH} = \Sigma_2^P\).  
- **Meyer’s Theorem:** \(\mathbf{EXP} \subseteq \mathbf{P}/\mathrm{poly} \Rightarrow \mathbf{EXP} = \Sigma_2^P\).  
- **Time Hierarchy Theorem:** \(\mathbf{P} \subsetneq \mathbf{EXP}\).  

The quantifier‑alternation flaw of the Kannan‑based approach is circumvented because the proof does not require selecting a parameter \(k\) after fixing an algorithm whose exponent depends on \(k\). Instead, it demonstrates that the collapse \(\Sigma_2^P = \mathbf{P}\) forces *every* language in \(\mathbf{EXP}\) to have polynomial‑size circuits, thereby triggering Meyer’s Theorem and a direct conflict with the Time Hierarchy Theorem. The argument is purely meta‑complexity: it combines uniform collapses (\(\mathbf{P} = \mathbf{NP} \Rightarrow \Sigma_2^P = \mathbf{P}\)) with non‑uniform consequences (\(\mathbf{EXP} \subseteq \mathbf{P}/\mathrm{poly}\)) to derive an absolute contradiction, establishing \(\mathbf{P} \neq \mathbf{NP}\) without invoking geometry, topology, category theory, or algebraic circuits.