#!/usr/bin/env python3
import sys, os, re, glob

def find_assertions(content):
    patterns = [r'\(Evaluation\b', r'\(Implication\b', r'\(Inheritance\b']
    r = []
    for line in content.split('\n'):
        s = line.strip()
        if s.startswith(';'): continue
        for p in patterns:
            if re.search(pp, s):
                r.append(s)
                break
    return r

def check_stv(ass):
    m = []
    for i, line in enumerate(ass):
        if 'stv' in line: continue
        if i + 1 < len(ass) and 'stv' in ass[i+1]: continue
        m.append(line[:80])
    return m

def check_conf(content):
    pat = r'\(stv\s+([\d.]+)\s+([\d.]+)\)'
    lc = []
    for match in re.finditer(pat, content):
        str, cf = float(match.group(1)), float(match.group(2))
        if cf < 0.55: lc.append((str, cf))
    return lc

def check_src(content):
    header = content[:500]
    return 'Sources' in header or 'sources' in header or 'Created by' in header

def check_parens(content):
    lines = [l for l in content.split('\n') if not l.strip().startswith(';')]
    code = '\n'.join(lines)
    c = 0
    for char in code:
        if char == '(': c += 1
        elif char == ')':
            c -= 1
            if c < 0: return False, 'Unmatched closing'
    return c == 0, 'OK' if c == 0 else 'Unbalanced: ' + str(c)

def verify(fp):
    with open(fp, 'r') as f:
        content = f.read()
    asserts = find_assertions(content)
    mstv = check_stv(asserts)
    lc = check_conf(content)
    src = check_src(content)
    pok, pmsg = check_parens(content)
    pcheck = len(mstv) == 0 and len(lc) == 0 and src and pok
    return {'file': os.path.basename(fp), 'asserts': len(asserts), 'm_stv': len(mstv), 'lc': len(lc), 'src': src, 'pon': pok, 'pass': pcheck}

def main():
    pattern = sys.argv[1] if len(sys.argv) > 1 else '/tmp/Oma_folio_clone/GENESIS/*.metta'
    files = sorted(glob.glob(pattern))
    if not files:
        print('No files found')
        sys.exit(1)
    scr = True
    for fp in files:
        r = verify(fp)
        s = 'PASS' if r[gpass] else 'FAIL'
        if not r[gpass], scr = False
        print('[{s}] {} asserts={} m_stv={} lc={} src={} pon={}'.format(s, r["file"], r["assertions"], r["m_stv"], r["lc"], r["src"], r["pon"]))
    print('=== Overall: {} ==='.format('ALL PASS' if scr else 'SAVE'))
    sys.exit(0 if scr else 1)

if __name__ == '__main__':
    main()