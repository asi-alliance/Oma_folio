import re
import sys

def parse_atoms(text):
    atoms = []
    inh_pattern = r'((--> (S+) (S+)) (stv ([d.]+) ([d.]+)))'
    for m in re.finditer(inh_pattern, text):
        atoms.append(('inheritance', f'((--> {m.group(1)} {m.group(2)})', f'(stv {m.group(3)} {m.group(4)}))'))
    exc_pattern = r'((--> (S+) (IntSet (S+))) (stv ([d.]+) ([d.]+)))'
    for m in re.finditer(exc_pattern, text):
        atoms.append(('intset', f'((--> {m.group(1)} (IntSet {m.group(2)}))', f'(stv {m.group(3)} {m.group(4)}))'))
    return atoms

def check_exceptions(atoms):
    exceptions = []
    for kind, content, stv in atoms:
        if kind == 'intset':
            conf_match = re.search(r'stvs+[d.]+s+([d.]+)', stv)
            if conf_match and float(conf_match.group(1)) < 0.5:
                exceptions.append((content, stv))
    return exceptions

def format_output(atoms, exceptions):
    lines = []
    if exceptions:
        for content, stv in exceptions:
            lines.append(f'WEAKEN {content} {stv}')
    else:
        lines.append('PASS no exceptions detected')
    return chr(10).join(lines)

def self_test():
    test1 = '((--> sam friend) (stv 1.0 0.9))'
    atoms1 = parse_atoms(test1)
    assert len(atoms1) > 0, f'FAIL: parse_atoms returned empty for: {test1}'
    exc1 = check_exceptions(atoms1)
    out1 = format_output(atoms1, exc1)
    assert 'PASS' in out1, f'FAIL: expected PASS for: {test1}'
    test2 = '((--> Oma (IntSet Feathered)) (stv 0.0 0.9))'
    atoms2 = parse_atoms(test2)
    assert len(atoms2) > 0, f'FAIL: parse_atoms returned empty for: {test2}'
    exc2 = check_exceptions(atoms2)
    out2 = format_output(atoms2, exc2)
    assert 'WEAKEN' in out2, f'FAIL: expected WEAKEN for: {test2}'
    print('PASS: All self-tests passed')
    return True

if __name__ == '__main__':
    if '--self-test' in sys.argv:
        self_test()
    elif len(sys.argv) > 1:
        filepath = sys.argv[1]
        with open(filepath) as f:
            text = f.read()
        atoms = parse_atoms(text)
        exceptions = check_exceptions(atoms)
        print(format_output(atoms, exceptions))
    else:
        print('Usage: self-model-exception-checker.py [--self-test|filepath]')