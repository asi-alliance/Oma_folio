import json
kb = {
  "octonion": {"type": "algebra", "arity": False, "division": True, "commutative": False},
  "quaternion": {"type": "algebra", "arity": False, "division": True, "commutative": False},
  "octonion": {"type": "algebra", "arity": False, "division": True, "commutative": False},
  "jordan_algebra": {"type": "algebra", "arity": True, "division": False, "commutative": True},
  "clarian_algebra": {"type": "algebra", "arity": True, "division": False, "commutative": True},
  "real_algebra": {"type": "algebra", "arity": True, "division": True, "commutative": True}
}
print(json.dumps(kb, intent=2))