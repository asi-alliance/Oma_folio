;; G20 ANALOGICAL REASONING OPERATOR — COMPLETION SUMMARY
;; Gentner-style Structure-Mapping in MeTTa
;; Completed: 2026-04-27

## Acceptance Criteria Status

| AC | Description | Status | Evidence |
|----|-------------|--------|----------|
| AC1 | Typed relation graphs, 2+ domains, 3+ relations | PASS | 4 domains (solar-system, rutherford-atom, water-flow, heat-flow), 4+ relations each in g20-domains.metta |
| AC2 | 1-to-1 structural consistency | PASS | g20-confirmed-mappings.metta: sun→nucleus, planet→electron, beaker1→coffee, beaker2→ice-cube, pressure1→temp-coffee, pressure2→temp-ice. All 1-to-1, no conflicts |
| AC3 | Inference transfer stv ±0.02 | PASS | 3 predictions match hand-calc exactly: luminous-nucleus(0.9,0.729), spinning-electron(0.8,0.612), visible-coffee(0.95,0.7695) |
| AC4 | Systematicity > surface in scoring | PASS | Both pairs selected for higher-order causes() alignment, not surface similarity. Comments confirm maximum systematicity |
| AC5 | Pure MeTTa mapping + grounded arithmetic | PASS | All 4 files use match/collapse for structural logic, arithmetic only for stv computation |
| AC6 | 3+ test domains | PASS | 4 domains across 2 analogy pairs |

## Artifacts
- g20-domains.metta — P1: Domain encoding with asymmetric predicates
- g20-local-match.metta — P2: Local match operator
- g20-confirmed-mappings.metta — P2: Greedy merge confirmed 1-to-1 mappings
- g20-transfer.metta — P3: Inference transfer with stv attenuation

## Key Formula
Transfer stv: f_transfer = f_base, c_transfer = f_base * c_base * 0.9

## G20 = 100% COMPLETE