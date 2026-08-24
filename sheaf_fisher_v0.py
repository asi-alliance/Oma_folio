import numpy as np
from dataclasses import dataclass
from typing import Dict, Set, Optional
import math

@dataclass
class Atom:
    name: str
    features: np.ndarray

@dataclass
class Context:
    name: str
    atoms: Set[str]
    parent: Optional[str] = None

@dataclass
class SheafSection:
    context: str
    distributions: Dict[str, np.ndarray]
    fisher_metric: Optional[np.ndarray] = None

def fisher_information_metric(probs):
    p = np.clip(probs, 1e-10, 1.0)
    return np.diag(1.0 / p)

def fisher_curvature(fm):
    return float(np.trace(fm))

def gluing_condition(sections):
    if len(sections) < 2:
        return True
    atom_to_vals = {}
    for s in sections:
        for atom_name, dist in s.distributions.items():
            atom_to_vals.setdefault(atom_name, []).append(dist)
    for vals in atom_to_vals.values():
        if len(vals) > 1:
            for i in range(len(vals)):
                for j in range(i+1, len(vals)):
                    if not np.allclose(vals[i], vals[j], atol=1e-3):
                        return False
    return True

def geodesic_transport(fa, fb):
    try:
        from scipy.linalg import sqrtm
        sa = sqrtm(fa)
        return np.real(sa @ np.linalg.inv(sqrtm(fb)) @ fb)
    except ImportError:
        return 0.5 * (fa + fb)

class SheafAtomSpace:
    def __init__(self):
        self.atoms = {}
        self.contexts = {}
        self.sections = {}
        self.relations = []

    def add_atom(self, name, features):
        self.atoms[name] = Atom(name=name, features=np.array(features))

    def add_relation(self, src, rel, tgt):
        self.relations.append((src, rel, tgt))

    def add_context(self, name, atom_names, parent=None):
        self.contexts[name] = Context(name=name, atoms=set(atom_names), parent=parent)

    def add_section(self, context_name, distributions):
        ctx = self.contexts[context_name]
        valid = {}
        for atom_name, dist in distributions.items():
            if atom_name in ctx.atoms:
                valid[atom_name] = np.array(dist, dtype=float)
        if valid:
            avg = np.mean(list(valid.values()), axis=0)
            fm = fisher_information_metric(avg)
        else:
            fm = np.eye(3)
        self.sections[context_name] = SheafSection(context=context_name, distributions=valid, fisher_metric=fm)

    def query_truth(self, atom_name, context_name=None):
        if context_name:
            section = self.sections.get(context_name)
            if section and atom_name in section.distributions:
                return section.distributions[atom_name]
            return None
        truths = []
        for ctx_name, section in self.sections.items():
            if atom_name in section.distributions:
                truths.append(section.distributions[atom_name])
        if not truths:
            return None
        weights = []
        for ctx_name, section in self.sections.items():
            if atom_name in section.distributions:
                curvature = fisher_curvature(section.fisher_metric)
                weights.append(1.0 / (1.0 + curvature))
        weights = np.array(weights)
        weights = weights / weights.sum()
        result = np.zeros_like(truths[0])
        for w, t in zip(weights, truths):
            result += w * t
        return result

    def propagate_truth(self, atom_name, from_ctx, to_ctx):
        fs = self.sections.get(from_ctx)
        ts = self.sections.get(to_ctx)
        if not fs or not ts or atom_name not in fs.distributions:
            return None
        truth = fs.distributions[atom_name]
        transported = geodesic_transport(fs.fisher_metric, ts.fisher_metric)
        weighted = truth * np.diag(transported)[:len(truth)]
        weighted = np.clip(weighted, 1e-10, None)
        return weighted / weighted.sum()

    def conceptual_distance(self, atom_a, atom_b, context_name=None):
        ta = self.query_truth(atom_a, context_name)
        tb = self.query_truth(atom_b, context_name)
        if ta is None or tb is None:
            return None
        eps = 1e-10
        p = np.clip(ta, eps, 1.0)
        q = np.clip(tb, eps, 1.0)
        kl_pq = np.sum(p * np.log(p / q))
        kl_qp = np.sum(q * np.log(q / p))
        return float(0.5 * (kl_pq + kl_qp))

    def check_gluing(self):
        return gluing_condition(list(self.sections.values()))

    def context_curvature_profile(self):
        return {n: fisher_curvature(s.fisher_metric) for n, s in self.sections.items()}

if __name__ == "__main__":
    print("=" * 60)
    print("Sheaf-Structured AtomSpace + Fisher Info Geometry v0")
    print("=" * 60)
    sas = SheafAtomSpace()
    sas.add_atom("dog", [0.9, 0.1, 0.8])
    sas.add_atom("cat", [0.8, 0.1, 0.7])
    sas.add_atom("wolf", [0.85, 0.2, 0.9])
    sas.add_atom("animal", [0.5, 0.1, 0.5])
    sas.add_atom("mammal", [0.6, 0.1, 0.6])
    sas.add_atom("pet", [0.7, 0.05, 0.4])
    sas.add_atom("wild", [0.3, 0.8, 0.7])
    sas.add_atom("domestic", [0.7, 0.05, 0.3])
    sas.add_atom("predator", [0.4, 0.9, 0.8])
    sas.add_atom("canine", [0.85, 0.15, 0.85])
    sas.add_relation("dog", "is-a", "canine")
    sas.add_relation("dog", "is-a", "mammal")
    sas.add_relation("wolf", "is-a", "canine")
    sas.add_relation("canine", "is-a", "mammal")
    sas.add_relation("mammal", "is-a", "animal")
    sas.add_relation("cat", "is-a", "mammal")
    sas.add_context("domestic_context", ["dog", "cat", "pet", "domestic", "mammal"])
    sas.add_context("wild_context", ["wolf", "wild", "predator", "mammal", "canine"])
    sas.add_context("taxonomic_context", ["dog", "wolf", "canine", "mammal", "animal"])
    sas.add_context("pet_context", ["dog", "cat", "pet", "domestic"])
    sas.add_section("domestic_context", {"dog": [0.95, 0.04, 0.01], "cat": [0.90, 0.08, 0.02], "pet": [0.85, 0.10, 0.05], "domestic": [1.0, 0.0, 0.0], "mammal": [0.60, 0.30, 0.10]})
    sas.add_section("wild_context", {"wolf": [0.95, 0.04, 0.01], "wild": [1.0, 0.0, 0.0], "predator": [0.80, 0.15, 0.05], "mammal": [0.50, 0.35, 0.15], "canine": [0.60, 0.30, 0.10]})
    sas.add_section("taxonomic_context", {"dog": [0.98, 0.01, 0.01], "wolf": [0.97, 0.02, 0.01], "canine": [0.95, 0.04, 0.01], "mammal": [0.96, 0.03, 0.01], "animal": [1.0, 0.0, 0.0]})
    sas.add_section("pet_context", {"dog": [0.90, 0.08, 0.02], "cat": [0.88, 0.10, 0.02], "pet": [1.0, 0.0, 0.0], "domestic": [0.95, 0.04, 0.01]})
    print("Atoms:", len(sas.atoms))
    print("Contexts:", len(sas.contexts))
    print("Sections:", len(sas.sections))
    print("Relations:", len(sas.relations))
    print("--- Context-Dependent Truth Values ---")
    for atom in ["dog", "wolf", "mammal"]:
        print(atom, ":")
        for ctx in ["domestic_context", "wild_context", "taxonomic_context", "pet_context"]:
            truth = sas.query_truth(atom, ctx)
            if truth is not None:
                print(" ", ctx, ": T=", round(truth[0],2), ", U=", round(truth[1],2), ", F=", round(truth[2],2))
            else:
                print(" ", ctx, ": not in context")
        gt = sas.query_truth(atom)
        if gt is not None:
            print(" [GLOBAL]: T=", round(gt[0],2), ", U=", round(gt[1],2), ", F=", round(gt[2],2))
    print("--- Fisher Curvature Profile ---")
    for ctx, curve in sas.context_curvature_profile().items():
        print(" ", ctx, ": curvature = ", round(curve,2))
    print("--- Geodesic Truth Transport ---")
    for atom in ["dog", "mammal"]:
        print(atom, ":")
        td = sas.query_truth(atom, "domestic_context")
        if td is not None:
            print(" domestic_context: ", td)
        tp = sas.propagate_truth(atom, "domestic_context", "wild_context")
        if tp is not None:
            print(" transported: ", tp)
        tw = sas.query_truth(atom, "wild_context")
        if tw is not None:
            print(" wild_context (native): ", tw)
    print("--- Conceptual Distance ---")
    pairs = [("dog", "wolf"), ("dog", "cat"), ("dog", "mammal"), ("wolf", "cat")]
    for a, b in pairs:
        dg = sas.conceptual_distance(a, b)
        dt = sas.conceptual_distance(a, b, "taxonomic_context")
        dd = sas.conceptual_distance(a, b, "domestic_context")
        print(" d(", a, ", ", b, "):")
        if dg: print(" global: ", round(dg,4))
        if dt: print(" taxonomic: ", round(dt,4))
        if dd: print(" domestic: ", round(dd,4))
    print("--- Sheaf Gluing Condition ---")
    glued = sas.check_gluing()
    print(" Sections can be glued: ", glued)
    print("Prototype v0 complete.")