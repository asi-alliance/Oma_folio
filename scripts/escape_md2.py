def escape_md2(text, format_chars=None):
    if format_chars is None:
        format_chars = set()
    special = ['_', '*', '[', ']', '(', ')', '~', '`', '>', '#', '+', '-', '=', '|', '{', '}', '.', '!']
    for ch in special:
        if ch not in format_chars:
            text = text.replace(ch, chr(92) + ch)
    return text