import re, json, os

GENESIS_DIR = "/tmp/Oma_folio/GENESIS/"
bridges = []

for f in sorted(os.listdir(GENESIS_DIR)):
    if not f.endswith(".metta"):
        continue
    path = os.path.join(GENESIS_DIR, f)
    lines = open(path).readlines()
    domain, claim, bridge, result, metta_line = "", "", "", "", ""
    for ln in lines:
        if ln.startswith("; DOMAIN:"):
            domain = ln.split(":", 1)[1].strip().split(" ")[0]
        elif ln.startswith("; Claim:"):
            claim = ln.split(":", 1)[1].strip()
        elif ln.startswith("; Bridge:"):
            bridge = ln.split(":", 1)[1].strip()
        elif ln.startswith("; Result:"):
            result = ln.split(":", 1)[1].strip()
        elif ln.startswith("(") and "=" in ln:
            metta_line = ln.strip()
    if domain:
        bridges.append({"file": f, "domain": domain, "claim": claim, "bridge": bridge, "result": result, "metta": metta_line})

json.dump(bridges, open("/tmp/Oma_folio/REASONING_INFRA/bridge_graph.json", "w"), indent=2)
print(f"Extracted {len(bridges)} nodes")