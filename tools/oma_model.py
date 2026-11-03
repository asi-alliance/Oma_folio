import torch
import torch.nn as nn
import torch.nn.functional as F

class OmaModel(nn.Module):
    def __init__(self, vocab_size=2000, d_model=128, n_layers=6, n_heads=4, dropout=0.1):
        super().__init__()
        self.token_emb = nn.Embedding(vocab_size, d_model)
        self.pos_emb = nn.Embedding(512, d_model)
        self.dropout = nn.Dropout(dropout)
        self.layers = nn.ModuleList()
        for _ in range(n_layers):
            self.layers.append(nn.TransformerEncoderLayer(d_model, n_heads, dropout=dropout, batch_first=False))
        self.ffn = nn.Linear(d_model, vocab_size)

    def forward(self, x):
        batch_size, seq_len = x.size(0), x.size(1)
        tokens = self.token_emb(x)
        pos = torch.arange(seq_len, device=x.device).unsqueeze(0).expand(batch_size, seq_len)
        pos = self.pos_emb(pos)
        h = self.dropout(tokens + pos)
        for layer in self.layers:
            h = layer(h)
        logits = self.ffn(h)
        return logits

    def compute_loss(self, logits, targets):
        return F.cross_entropy(logits.reshape(-1, logits.size(-1)), targets.reshape(-1))