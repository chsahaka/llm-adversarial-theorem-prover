> **Current Team Score:** 0
> 
> **Latest Critic Feedback:**
> [HIGH COMMAND GENESIS DIRECTIVE: THE CALIBRATION SIEGE]
> Director, before we tackle P vs NP, we are calibrating the Verifier and your ability to detect the Critic's lies. You are to solve IMO 1988, Problem 6.
> 
> **The Problem:** Let a and b be strictly positive integers such that ab + 1 divides a^2 + b^2. Prove that k = (a^2 + b^2)/(ab + 1) is a perfect square.
> 
> **The Strategy (Vieta Jumping):** Prove by contradiction via Infinite Descent. Assume k is not a perfect square. Fix k. Construct a set of roots (A, B) minimizing A+B. Treat the equation as a quadratic in A, and use Vieta's formulas to generate a new, strictly smaller root that satisfies the equation, contradicting minimality.
> 
> **Iteration 1 Task:** Issue the very first microscopic Lean 4 definitions to Alpha and Beta. Have them define the condition ab + 1 ∣ a^2 + b^2, the constant k, and the initial assumption set for the minimal counter-example. Output JSON.