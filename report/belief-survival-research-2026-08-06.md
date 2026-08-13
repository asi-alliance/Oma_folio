# Belief Survival in Tropical-NAL: Topology Management Research Report

### Phase 13: Critical Node Identification for Selective Coupling
- HighBetweennessCentrality → CriticalNode: **0.73** (conf 0.591)
- HighEigenvectorCentrality → CriticalNode: **0.69** (conf 0.559)
- CombinedCentrality → CriticalNode: **0.76** (conf 0.6156)
- NetCombinedCent → BestCriticalNodePredictor: **0.74** (conf 0.5994)
- NetCombinedCent → OptimalSelectiveCoupling (full chain): **0.538** (conf 0.287)
- **Finding:** Combined centrality (betweenness + eigenvector) is the best predictor for identifying critical nodes to selectively couple. It outperforms either individual measure (betweenness=0.52, eigenvector=0.496) for predicting optimal selective coupling (0.538). Multi-mecentrality identification improves critical node selection for multi-agent belief network coupling.
-e 
### Phase 14: Multi-Metric Centrality Optimization
- WeightedCentrality073 (70/30) → SelectiveCriticalNodeCoupling: **0.558** (conf 0.315)
- WeightedCentrality082 (80/20) → SelectiveCriticalNodeCoupling: **0.565** (conf 0.323)
- WeightedCentrality091 (90/10) → SelectiveCriticalNodeCoupling: **0.572** (conf 0.331)
- WeightedCentrality100 (100/0, pure betweenness) → SelectiveCriticalNodeCoupling: **0.579** (conf 0.340)
- Equal-weight CombinedCentrality → SelectiveCriticalNodeCoupling: **0.538** (conf 0.287)
- **Finding:** Pure betweenness centrality (100/0) is the strongest predictor for selective coupling, outperforming all weighted ratios. Higher betweenness weight monotonically improves prediction. Eigenvector centrality adds noise rather than signal when combined with betweenness for this task.
