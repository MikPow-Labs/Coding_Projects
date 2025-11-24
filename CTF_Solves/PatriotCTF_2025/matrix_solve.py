import math

# Read encrypted file
with open("encrypted.txt", "rb") as f:
    encrypted_bytes = f.read()

ss = int.from_bytes(encrypted_bytes, byteorder='big')

# Reverse mapping from o
o = (
    (6, 0, 7),
    (8, 2, 1),
    (5, 4, 3)
)
rev = {}
for i in range(3):
    for j in range(3):
        rev[o[i][j]] = (i, j)

# Convert ss to base9 digits (most significant first)
def to_base9(n):
    if n == 0:
        return [0]
    digits = []
    while n > 0:
        digits.append(n % 9)
        n //= 9
    return digits[::-1]

base9_digits = to_base9(ss)

# Reconstruct base3 digits
left = []
right = []
for v in base9_digits:
    a, b = rev[v]
    left.append(a)
    right.append(b)

# The right side needs to be reversed
base3_digits = left + right[::-1]

# Convert base3 digits to integer
s = 0
for d in base3_digits:
    s = s * 3 + d

# Convert to bytes
byte_len = (s.bit_length() + 7) // 8
flag_bytes = s.to_bytes(byte_len, byteorder='big')

print(flag_bytes.decode(errors='ignore'))