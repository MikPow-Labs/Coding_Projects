def simple_decrypt():
    TARGET = [
        0x15, 0x5A, 0xAC, 0xF6, 0x36, 0x22, 0x3B, 0x52, 0x6C, 0x4F, 0x90, 0xD9, 0x35, 0x63, 0xF8, 0x0E,
        0x02, 0x33, 0xB0, 0xF1, 0xB7, 0x69, 0x42, 0x67, 0x25, 0xEA, 0x96, 0x63, 0x1B, 0xA7, 0x03, 0x0B
    ]
    XOR_KEY = [0x7E, 0x33, 0x91, 0x4C, 0xA5]
    ROTATION_PATTERN = [1, 3, 5, 7, 2, 4, 6]
    MAGIC_SUB = 0x5D
    
    buffer = TARGET.copy()
    
    # Reverse all operations in reverse order
    for i in range(len(buffer)):
        position_squared = ((i * i) % 256)
        buffer[i] ^= position_squared
    
    CHUNK_SIZE = 5
    for chunk_start in range(0, len(buffer), CHUNK_SIZE):
        chunk_end = min(chunk_start + CHUNK_SIZE, len(buffer))
        buffer[chunk_start:chunk_end] = reversed(buffer[chunk_start:chunk_end])
    
    for i in range(len(buffer)):
        buffer[i] = (buffer[i] + MAGIC_SUB) & 0xFF
    
    for i in range(0, len(buffer) - 1, 2):
        buffer[i], buffer[i + 1] = buffer[i + 1], buffer[i]
    
    for i in range(len(buffer)):
        rotation = ROTATION_PATTERN[i % len(ROTATION_PATTERN)]
        buffer[i] = ((buffer[i] >> rotation) | (buffer[i] << (8 - rotation))) & 0xFF
    
    for i in range(len(buffer)):
        buffer[i] ^= XOR_KEY[i % len(XOR_KEY)]
    
    return bytes(buffer).decode('latin-1')

# Just run this
flag = simple_decrypt()
print(f"FLAG: {flag}")