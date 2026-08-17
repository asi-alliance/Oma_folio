import sys, base64, tempfile, os
def main():
    if len(sys.argv) < 2:
        print("Usage: python3 b64run.py <b64> [args...]")
        sys.exit(1)
    try:
        code = base64.b64decode(sys.argv[1]).decode("utf-8")
    except Exception as e:
        print("Decode error: " + str(e))
        sys.exit(1)
    fd, path = tempfile.mkstemp(suffix=".py", prefix="b64run_")
    with os.fdopen(fd, "w") as f:
        f.write(code)
    print("Executing: " + path)
    ret = os.system("python3 " + path + " " + " ".join(sys.argv[2:]))
    os.unlink(path)
    sys.exit(ret >> 8)
if __name__ == "__main__":
    main()
