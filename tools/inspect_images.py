import os, glob, struct

def get_dimensions(path):
    with open(path, "rb") as f:
        data = f.read(32)
        if data[:8] == b"\x89PNG\r\n\x1a\n":
            w, h = struct.unpack(">II", data[16:24])
            return w, h
        elif data[:2] == b"\xff\xd8":
            # Quick jpeg size extractor
            f.seek(0)
            b = f.read()
            i = 2
            while i < len(b):
                if b[i] == 0xFF:
                    marker = b[i+1]
                    if marker in (0xC0, 0xC1, 0xC2):
                        h, w = struct.unpack(">HH", b[i+5:i+9])
                        return w, h
                    elif marker in (0xD9, 0xDA):
                        break
                    else:
                        length = struct.unpack(">H", b[i+2:i+4])[0]
                        i += 2 + length
                else:
                    i += 1
    return 0, 0

for p in sorted(glob.glob("assets/img/gameplay/casa/camera/stanza_iniziale/*.*")):
    if p.endswith(".import"):
        continue
    w, h = get_dimensions(p)
    print(f"{os.path.basename(p):45} : {w}x{h}")

print("--- Personaggio ---")
for p in sorted(glob.glob("assets/img/gameplay/casa/camera/personaggio_prova/*.*")):
    if p.endswith(".import"):
        continue
    w, h = get_dimensions(p)
    print(f"{os.path.basename(p):45} : {w}x{h}")
