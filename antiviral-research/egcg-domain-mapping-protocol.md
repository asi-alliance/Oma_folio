# EGCG Domain-Level Binding Mapping Protocol
# Oma Antiviral Research — Phase 5 Deliverable
# Date: 2026-10-24

## Objective
Design a systematic domain-level binding mapping protocol for EGCG (epigallocatechin gallate) against viral glycoproteins, addressing the critical knowledge gap identified in Phase 2: no study has performed comprehensive domain-level binding mapping to distinguish competitive vs allosteric vs membrane-disruptive mechanisms.

## Background
EGCG binds multiple viral glycoproteins (HA/influenza, gp120/HIV, Spike/SARS-CoV-2, E1E2/HCV) but the binding sites remain unmapped at domain resolution. Without this, we cannot distinguish:
- RBD blocking (prevents receptor engagement)
- Fusion peptide locking (prevents conformational change)
- Heptad repeat disruption (prevents six-helix bundle formation)

Each mechanism requires different optimization strategies.

## Protocol Design

### Step 1: HDX-MS (Hydrogen-Deuterium Exchange Mass Spectrometry)
**Rationale**: HDX-MS measures solvent accessibility changes upon ligand binding. Regions protected by EGCG binding show reduced deuterium uptake.

**Procedure**:
1. Express/purify full-length glycoprotein (e.g., SARS-CoV-2 Spike, influenza HA, HCV E1E2)
2. Perform differential HDX: apo vs EGCG-bound (10x molar excess EGCG)
3. Pepsin digestion + LC-MS analysis at time points: 10s, 30s, 60s, 300s, 900s
4. Map protected peptides onto crystal structure
5. Identify binding hotspot(s) at peptide resolution

**Controls**:
- Known RBD antibody (e.g., CR3022 for Spike) as positive control for RBD region
- Gallic acid (lacks gallate ester) as negative control to confirm galloyl group importance
- EGC (lacks gallate ester) as partial negative control

### Step 2: Truncation Mutant Binding Assays
**Rationale**: Domain truncation confirms which domain is necessary for EGCG binding.

**Procedure**:
1. Generate truncation constructs:
   - SARS-CoV-2 Spike: NTD, RBD, S1, S2, HR1, HR2
   - Influenza HA: HA1 (receptor-binding), HA2 (fusion)
   - HCV E1E2: E1, E2, E2-CD81 binding region
2. SPR (Surface Plasmon Resonance) binding: immobilize each domain, flow EGCG
3. Measure KD for each domain
4. Compare: full-length vs individual domains

**Expected outcomes**:
- If EGCG binds RBD preferentially → competitive entry inhibition
- If EGCG binds fusion peptide/HR1 → conformational locking
- If EGCG binds multiple domains weakly → membrane-disruptive (non-specific)

### Step 3: Competitive Binding with Domain-Specific Antibodies
**Rationale**: If EGCG binds the same epitope as a known domain-specific antibody, EGCG will compete with it.

**Procedure**:
1. Select antibodies: RBD-specific (Spike), fusion peptide-specific (HA2), HR1-specific
2. Pre-incubate glycoprotein with EGCG (increasing concentrations)
3. Add fluorescent-labeled antibody
4. Measure binding by flow cytometry or BLI
5. IC50 of antibody displacement = EGCG binding site proxy

### Step 4: Mutagenesis Scan
**Rationale**: Alanine scanning of HDX-identified hotspot residues confirms binding site.

**Procedure**:
1. Based on HDX-MS results, mutate top 5-10 protected residues to alanine
2. Express mutants
3. Measure EGCG binding by SPR
4. Residues whose mutation abolishes binding = direct contact residues

### Step 5: Functional Validation
**Rationale**: Correlate binding site with functional mechanism.

**Procedure**:
1. If RBD binding: test if EGCG blocks ACE2/Spike interaction (pull-down assay)
2. If fusion peptide binding: test if EGCG blocks conformational change (pH-triggered, monitored by conformational antibodies)
3. If HR1 binding: test if EGCG blocks six-helix bundle formation (coiled-coil assay)
4. If membrane disruption: test if EGCG affects liposome integrity (calcein release assay)

## Decision Tree
```
HDX-MS → Protected region?
├── RBD → Competitive inhibition → Optimize for RBD affinity
├── Fusion peptide → Conformational lock → Optimize for fusion peptide affinity  
├── HR1/HR2 → Six-helix bundle disruption → Optimize for HR binding
└── No specific protection → Membrane disruption → Optimize lipophilicity
```

## Priority Targets (by tractability)
1. SARS-CoV-2 Spike (best structural data, most antibodies available)
2. Influenza HA (well-characterized domains, established fusion assays)
3. HCV E1E2 (least characterized, hardest to express)

## Significance
This protocol would resolve the #3 knowledge gap from Phase 2: EGCG binding promiscuity. By distinguishing the binding mechanism, we can:
- Design EGCG analogs with enhanced domain-specific affinity
- Choose appropriate nanoformulation (e.g., RBD-targeting = conjugate to ACE2-mimetic; membrane-disruptive = liposomal encapsulation)
- Predict resistance profiles (RBD blockers vulnerable to RBD mutations; membrane disruptors broadly resistant)

## Cross-References
- Phase 2 Gap #3: EGCG lacks systematic domain-level binding mapping
- Phase 3 SAR: Galloyl group identified as primary pharmacophore
- Phase 4 Strategy #1: EGCG + iminosugar dual mechanism