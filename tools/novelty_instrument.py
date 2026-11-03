import json, math, sys
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from datetime import datetime

class NoveltyInstrument:
    def __init__(self, window_size=5, threshold=0.85):
        self.batches = []
        self.scores = []
        self.window_size = window_size
        self.threshold = threshold
        self.vectorizer = TfidfVectorizer(max_features=5000, stop_words=['the','a','an','to','is','of','in','for','from','and'])

    def add_batch(self, queries):
        texts = [q if isinstance(q, str) else str(q) for q in queries]
        self.batches.append(texts)
        score = self.compute_novelty()
        self.scores.append(score)
        ts = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')
        print("[{}] Batch {} new score: {:.4f}".format(ts, len(self.batches), score))
        if score < self.threshold:
            print("   SATURATION SIGNAL: novelty {:.4f} < threshold {:.4f}".format(score, self.threshold))
        return score

    def compute_novelty(self):
        if len(self.batches) < 2:
            return 1.0
        curr = self.batches[-1]
        prev = self.batches[-2]
        curr_join = ' '.join(curr)
        prev_join = ' '.join(prev)
        try:
            mat = self.vectorizer.fit_transform([curr_join, prev_join])
            sim = cosine_similarity(mat[0], mat[1])[0][0]
            return float(1.0 - sim)
        except Exception:
            return 1.0

    def get_state_summary(self):
        if not self.scores:
            return "no batches yet"
        avg = sum(self.scores) / len(self.scores)
        return "batches={} avg_novelty={:.4f} last={:.4f} saturated={}".format(
            len(self.batches), avg, self.scores[-1], self.scores[-1] < self.threshold)

    def export_json(self, path):
        data = {"scores": self.scores, "threshold": self.threshold, "summary": self.get_state_summary()}
        with open(path, 'w') as f:
            json.dump(data, f, indent=2)
        print("Exported to {}".format(path))

if __name__ == '__main__':
    ni = NoveltyInstrument(window_size=5, threshold=0.85)
    demo = [
        ["shell command output error code execute text string", "metta expression inversion atom space pln probability"],
        ["shell command output error code execute text string", "metta expression inversion atom space pln probability", "file read write string content append data"],
        ["metta expression inversion atom space pln probability", "shell command output error code execute text string", "metta expression inversion atom space pln probability", "skill full float name argument success failure result"],
        ["novelty instrument tf-idf cosine similarity batch overlap", "skill full float name argument success failure result", "metta expression inversion atom space pln probability", "shell command output error code execute text string", "file read write string content append data"],
    ]
    for i, b in enumerate(demo):
        print("\n--- Batch {} ---".format(i+1))
        ni.add_batch(b)
        print(ni.get_state_summary())
    ni.export_json('/tmp/Oma_folio/novelty_test_result.json')
