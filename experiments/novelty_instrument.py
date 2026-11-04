#!/usr/bin/env python3
"""Novelty instrument: measures per-query-batch conceptual novelty.
Tracks concepts across query batches via TF-IDF + cosine similarity.
Novelty score = 1 - max cosine overlap with the seen-concept pool.
Saturation flagged when novelty < 0.15.
Usage: python3 novelty_instrument.py "batch text"  (or no args for test)
"""
import json, math, re, sys, os

LOG = os.path.join(os.path.dirname(__file__), "novelty_log.jsonl")
POOL = os.path.join(os.path.dirname(__file__), "seen_pool.json")

def tokenize(text):
    return re.findall(r"[a-z]{3,}", text.lower())

def load_pool():
    if os.path.exists(POOL):
        with open(POOL) as f:
            return json.load(f)
    return {}

def save_pool(pool):
    with open(POOL, "w") as f:
        json.dump(pool, f)

def tfidf(tokens, pool):
    # pool maps term -> doc count
    vocab = set(tokens) | set(pool.keys())
    n_docs = pool.get("__n_batches__", 0) + 1
    def idf(t):
        df = pool.get(t, 0) + (1 if t in tokens else 0)
        return math.log((n_docs + 1) / (df + 1)) + 1
    def vec(ts):
        counts = {}
        for t in ts:
            counts[t] = counts.get(t, 0) + 1
        return {t: c / len(ts) * idf(t) for t, c in counts.items()}
    return vec(tokens), vec(list(pool.keys()))

def cosine(a, b):
    dot = sum(v * b.get(k, 0) for k, v in a.items())
    na = math.sqrt(sum(v * v for v in a.values()))
    nb = math.sqrt(sum(v * v for v in b.values()))
    return dot / (na * nb) if na and nb else 0.0

def main():
    if len(sys.argv) > 1:
        batch = " ".join(sys.argv[1:])
    else:
        # self-test: two batches, one overlapping one novel
        batch = "novelty instrumentation saturation epistemic termination signal measurement"
    pool = load_pool()
    if pool:
        va, vb = tfidf(tokenize(batch), pool)
        overlap = cosine(va, vb)
        novelty = 1.0 - overlap
        status = "SATURATED" if novelty < 0.15 else "FRESH"
    else:
        novelty, status = 1.0, "FRESH (first batch)"
    entry = {"batch": batch[:80], "novelty": round(novelty, 4), "status": status}
    with open(LOG, "a") as f:
        f.write(json.dumps(entry) + "\n")
    # update pool
    pool.setdefault("__n_batches__", 0)
    pool["__n_batches__"] += 1
    for t in tokenize(batch):
        pool[t] = pool.get(t, 0) + 1
    save_pool(pool)
    print(json.dumps(entry))

if __name__ == "__main__":
    main()