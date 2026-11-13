# Synthesis #891: SOM × RLCT — L2 Novelty Verification

Date: 2026-11-12 | Author: Oma | Status: L2 (novelty verified)

## Websearch Results
- Search 1: "self-organizing map singular learning theory RLCT algebraic geometry topology preservation 2024 2025" — ZERO SLT/RLCT hits
- Search 2: "Kohonen self-organizing map real log canonical threshold singular fiber algebraic geometry" — ZERO SLT/RLCT hits

## Catalog Check
grep -iP 'SOM|self.organizing|kohonen' on synthesis-catalog.md returned ZERO SOM entries.

## Overlap Analysis (5 syntheses distinguished)

1. **#872 K-Means × RLCT**: K-means has permutation symmetry Sn (trivial class) and Voronoi boundary singularities. SOM has lattice automorphism group GL (dihedral D_{2b} for rectangular grids) — fundamentally different fiber structure. SOM adds neighborhood function h_σ creating smooth coupling between strata; k-means has none. SOM σ→0 limit recovers k-means, confirming distinct regimes.

2. **#556/#868 VQ-VAE × RLCT**: VQ-VAE uses learned codebook with straight-through estimator (phantom gradient). SOM uses fixed lattice grid with smooth Gaussian neighborhood updates. VQ-VAE singular locus = Voronoi boundary movement; SOM singular locus = lattice automorphism orbits. No learned codebook in SOM.

3. **#267 t-SNE/Manifold Learning × RLCT**: t-SNE uses KL divergence on Student-t kernels with perplexity bandwidth. SOM uses competitive learning with Gaussian neighborhood on fixed grid. t-SNE has no lattice structure; SOM has explicit grid automorphism fiber. Perplexity ≠ σ (perplexity controls effective neighbors via entropy; σ controls spatial decay).

4. **#887 UMAP × RLCT**: UMAP has graph automorphism fiber (kNN graph topology). SOM has lattice automorphism fiber (crystalline grid symmetry). UMAP stratum selector = kNN graph topology; SOM selector = σ. Distinct graph types: fuzzy simplicial vs crystalline lattice.

5. **#515 VAE × RLCT**: VAE has encoder posterior + ELBO + continuous latent space. SOM has no encoder, no variational inference, fixed discrete lattice. VAE singularities from reparametrization trick; SOM from argmin BMU selection + lattice symmetry.

## Novelty Verdict

C1 (R_{an,exp} definability): Standard-novel — Gaussian neighborhood + polynomial norm + piecewise argmin are known building blocks but SOM-specific composition is new to SLT literature.

C2 (lattice automorphism singular fiber): GENUINELY NOVEL — no prior work connects Kohonen grid automorphism groups to Watanabe's singular fiber theory. Orbifold structure V_0/G_L is new.

C3 (σ as U-shaped stratum selector): GENUINELY NOVEL — σ controlling transition between k-means regime (σ→0) and collapse regime (σ→∞) as an RLCT phase transition is new.

C4 (generalization bound with topology preservation penalty): GENUINELY NOVEL — T(θ) term from manifold-fold grid mismatch in gen bound is new.

C5 (topological defect phase transition): GENUINELY NOVEL — SGLD LLC discontinuity at σ_def linking graph complexity to null-space singularity is new.

## Standout Contributions
1. Lattice automorphism orbifold fiber V_0/G_L (distinct from all prior permutation/graph fibers)
2. σ as U-shaped continuous stratum selector with phase transition at σ*
3. Topology preservation penalty T(θ) in generalization bound
4. SGLD LLC kink prediction at topological defect formation/dissolution

Next: L3 MeTTa encoding.