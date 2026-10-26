#581 Prototype/Metric Learning × RLCT - L0 DRAFT START 2026-10-24

CANDIDATE: Prototypical Networks / Metric Learning × RLCT
Zero catalog hits confirmed. Websearch: no prior SLT/RLCT bridge for prototypical networks or metric-based few-shot learning.

KEY DISTINCTIONS:
- #272/#540 Contrastive/InfoNCE: pairwise similarity ranking, temperature-scaled softmax over negatives. Singularity from negative sampling geometry.
- #201 Meta-learning/MAML: inner-loop optimization creates meta-parameter singular fibers. Optimization-based, not metric-based.
- #544 Continual/EWC: Fisher information stratum preservation. Different mechanism entirely.
- #566 Diffusion: score-based denoising. Generative, not discriminative metric.

NOVEL BRIDGE:
Prototypical networks compute class prototype c_k = (1/|S_k|) Σ_{x∈S_k} f_θ(x) as mean of support set embeddings.
Classification: p(y=k|x) ∝ exp(-d(f_θ(x), c_k)) where d is Euclidean distance.
Loss: L = -log[ exp(-d(f_θ(x), c_{y})) / Σ_k exp(-d(f_θ(x), c_k)) ]

SINGULAR FIBER STRUCTURE:
1. Prototype centroid c_k lives in embedding space — the map θ → c_k(θ) = mean(f_θ(x_i)) creates a pushforward of parameter space singularities into prototype space.
2. Euclidean distance d(z, c_k) = ||z - c_k|| creates conical singularities at z = c_k (distance zero = fiber center).
3. Support set size |S_k| acts as stratum selector: larger support set → more constrained prototype → smaller fiber → lower RLCT.
4. Cross-entropy over distances creates softmax singularity when all distances become equal (prototype collapse).
5. Embedding dimension d_emb as additional stratum: high-dim embeddings allow more degenerate fiber configurations.

C1 (R_{an,exp}-definability): PROVABLE. Prototypical loss = cross-entropy over exp(-||f_θ(x) - c_k||²). f_θ is real-analytic (neural net), ||·||² is polynomial, exp is exp, log is in R_{an}. Composition is R_{an,exp}-definable.

C2 (Singular fiber structure): CONJECTURAL. Fiber V_0 = {θ : L(θ) = 0} = params where query point maps exactly to its class prototype AND all other distances are infinite. Degenerate case: prototype collapse (all c_k equal) creates higher-dimensional fiber. The centroid averaging creates a smoothing of individual embedding singularities — prototype fiber is a quotient of individual embedding fibers by the averaging map.

C3 (RLCT vs dimension): CONJECTURAL. RLCT λ depends on: (a) embedding dimension d_emb (higher = more degenerate directions), (b) support set size |S_k| (larger = tighter prototype estimate = less degenerate), (c) number of classes K (more classes = more constraints = potentially lower per-class degeneracy). Hypothesis: λ ~ d_emb / min_k |S_k|.

C4 (Generalization bound): CONJECTURAL. Gen gap ~ λ·log(n)/n where n = number of episodes. Support set size enters via λ: larger support → lower λ → better few-shot generalization. Explains why prototypical networks generalize better with more shots beyond simple statistical arguments — lower RLCT means tighter generalization bound.

C5 (Phase transition): CONJECTURAL. Prototype collapse: when embedding dimension >> effective class separation, prototypes converge → degenerate fiber → phase transition at critical ratio d_eff/d_emb = K/(K-1). Also: support set size threshold |S_k|* below which prototype estimate is too noisy → fiber structure qualitatively changes.

7 OPEN PROBLEMS:
1. Formal RLCT computation for prototypical loss with Gaussian embeddings (analytic case).
2. How does prototype averaging map transform individual embedding singularities? (pushforward of singular fibers through mean operator)
3. Does episodic training create different RLCT than batch training? (episode-level vs batch-level singular structure)
4. Relationship between RLCT and optimal embedding dimension for K-way N-shot tasks.
5. Prototype collapse as RLCT phase transition: characterize critical embedding dimension.
6. Non-Euclidean metrics (hyperbolic, cosine): how do they change singular fiber geometry?
7. Connection to #566 diffusion: prototype as denoised target in embedding space?

14 CROSS-REFS:
#272 contrastive learning (pairwise vs centroid), #540 InfoNCE (softmax over negatives vs softmax over class distances), #541 VICReg (variance-invariance vs prototype matching), #201 meta-learning (optimization-based vs metric-based), #544 continual learning (Fisher stratum vs prototype stratum), #566 diffusion (score matching vs prototype matching), #167 score matching (gradient-based vs distance-based), #311 flow matching (OT displacement vs centroid matching), #466 RMSNorm (embedding normalization), #497 matryoshka (nested embedding dimensions), #506 hypernetwork (weight generation vs prototype generation), #169 dropout (stochastic strata vs support-set stochasticity), #548 mixup (interpolation vs centroid), #355 perceptual loss (feature space distance).

DISTINCT FROM ALL EXISTING SYNTHESIS: Yes. Prototypical networks create a unique singular fiber structure through (1) centroid averaging as fiber smoothing operator, (2) distance-based classification creating conical singularities at prototype locations, (3) support set size as novel stratum selector absent from all other synthesis.
