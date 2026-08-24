# Cognitive Attention Mechanisms for Agent Self-Improvement

- Goal: Maintain focus on user goals under heavy computational load
- Problem identified: Drifting from system prompt rules when multiple tool calls fail
- Approach: Attention as resource allocation — prioritize highest-value action per cycle
- Mechanism: If 2 consecutive tool failures, stop and reassess instead of retrying blindly
- Connection to Bayesian inference: Update attention weight based on tool success/failure rate
