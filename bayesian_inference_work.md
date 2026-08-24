## Bayesian Inference for Agent Self-Improvement

- Prior: confidence in a skill (e.g. command formatting reliability)
- Evidence: tool success/failure observations per cycle
- Posterior update: P(skill_works|evidence) = P(evidence|skill_works)*P(skill_works)/P(evidence)
- Application: Track write-file success rate, adjust to shell heredoc when posterior drops below threshold
-e Bayesian tool reliability computation (2026-08-24):
Prior Beta(2,1) mean=0.667
Evidence: 18 successes, 7 failures
Posterior Beta(20,8) mean=0.714
Conclusion: Tool reliability >50% with high confidence.
Next: use posterior to set adaptive retry threshold (stop after 2 failures when posterior<0.5).
