def self_test():
    t1 = "((--> sam friend) (stv 1.0 0.9))"
    a1 = parse_atoms(t1)
    assert len(a1) > 0
    assert "PASS" in format_output(a1, check_exceptions(a1))
    t2 = "((--> Oma (IntSet Feathered)) (stv 0.0 0.9))"
    a2 = parse_atoms(t2)
    assert len(a2) > 0
    assert "WEAKEN" in format_output(a2, check_exceptions(a2))
    print("PASS: All self-tests passed")
if __name__ == "__main__": self_test()
