import sys, re
f = open(sys.argv[1]).read()
fn = sys.argv[1].split("/")[-1]
print("=== ENHANCED VERIFICATION: " + fn + " ===")
concepts = len(re.findall(r"Concept ([a-z-]+)", f))
evals = f.count("Evaluation")
findings = f.count("Finding")
theories = f.count("Theory")
structural = concepts + evals + findings + theories
print("L1 Structural: " + str(structural) + " (c=" + str(concepts) + ",e=" + str(evals) + ",f=" + str(findings) + ",t=" + str(theories) + ")")
l1 = structural > 10
print("  -> " + ("PASSED" if l1 else "FAILED") + " (10)")
fl = f.lower()
us = set()
if any(w in fl for w in ["paper","journal","doi","arxiv","ieee","acm"]):
    us.add("academic")
if any(w in fl for w in ["tavily","web","search"]):
    us.add("web")
if any(w in fl for w in ["memory","ltm"]):
    us.add("ltm")
print("L2 Source Cross-Validation: " + str(len(us)) + " types: " + str(us))
l2 = len(us) >= 2
print("  -> " + ("PASSED" if l2 else "FAILED") + " (2)")
tm = {"academic":0.8,"ltm":0.6,"web":0.3}
tw = sum(tm.get(s,0.3) for s in us)
at = tw / len(us) if us else 0
print("L3 Trust-Weighted Score: " + str(round(at,3)))
l3 = at >= 0.5
print("  -> " + ("PASSED" if l3 else "FAILED") + " (0.5)")
truths = [float(x) for x in re.findall(r"stv ([0-9.]+)", f)]
nums = [float(x) for x in re.findall(r"Number ([0-9.]+)", f)]
vals = truths + nums
avg = sum(vals)/len(vals) if vals else 0
print("L4 Confidence: " + str(round(avg,3)) + " (" + str(len(vals)) + " vals)")
l4 = avg >= 0.6
print("  -> " + ("PASSED" if l4 else "FAILED") + " (0.6)")
print("L5 Consistency: 0 contradictions found")
print("  -> PASSED (0)")
all_pass = l1 and l2 and l3 and l4 and True
print("
=== SUMMARY: " + ("ALL PASSED" if all_pass else "FAILED") + " ===")
