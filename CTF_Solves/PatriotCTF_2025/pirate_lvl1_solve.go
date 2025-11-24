package main

import (
	"fmt"
)

var target = [30]byte{
	0x60, 0x6D, 0x5D, 0x97, 0x2C, 0x04, 0xAF, 0x7C, 0xE2, 0x9E, 0x77, 0x85, 0xD1, 0x0F, 0x1D, 0x17, 0xD4, 0x30, 0xB7, 0x48, 0xDC, 0x48, 0x36, 0xC1, 0xCA, 0x28, 0xE1, 0x37, 0x58, 0x0F,
}

var xorKey = [7]byte{0xC7, 0x2E, 0x89, 0x51, 0xB4, 0x6D, 0x1F}
var rotationPattern = [8]uint{7, 5, 3, 1, 6, 4, 2, 0}
const magicSub byte = 0x93
const chunkSize = 6

func rotateRight(b byte, n uint) byte {
	n = n % 8
	return (b >> n) | (b << (8 - n))
}

func decryptVault() string {
	buffer := make([]byte, 30)
	copy(buffer, target[:])
	
	// Reverse the operations in reverse order
	
	// Step 1: Reverse operation 6 - XOR with (position² + position) mod 256
	for i := range buffer {
		positionValue := ((i * i) + i) % 256
		buffer[i] ^= byte(positionValue)
	}
	
	// Step 2: Reverse operation 5 - Reverse chunks of 6 bytes (same operation)
	for chunkStart := 0; chunkStart < len(buffer); chunkStart += chunkSize {
		chunkEnd := chunkStart + chunkSize
		if chunkEnd > len(buffer) {
			chunkEnd = len(buffer)
		}
		for i, j := chunkStart, chunkEnd-1; i < j; i, j = i+1, j-1 {
			buffer[i], buffer[j] = buffer[j], buffer[i]
		}
	}
	
	// Step 3: Reverse operation 4 - Add instead of subtract
	for i := range buffer {
		buffer[i] += magicSub
	}
	
	// Step 4: Reverse operation 3 - Swap adjacent pairs (same operation)
	for i := 0; i < len(buffer)-1; i += 2 {
		buffer[i], buffer[i+1] = buffer[i+1], buffer[i]
	}
	
	// Step 5: Reverse operation 2 - Rotate right instead of left
	for i := range buffer {
		rotation := rotationPattern[i%len(rotationPattern)]
		buffer[i] = rotateRight(buffer[i], rotation)
	}
	
	// Step 6: Reverse operation 1 - XOR with rotating key (same operation)
	for i := range buffer {
		buffer[i] ^= xorKey[i%len(xorKey)]
	}
	
	return string(buffer)
}

func main() {
	fmt.Println("Decrypting the Pirate King's Vault...")
	
	flag := decryptVault()
	
	fmt.Printf("The vault combination is: %s\n", flag)
	fmt.Printf("Flag: %s\n", flag)
	
	// Verify the decryption
	fmt.Println("\nVerifying decryption...")
	
	// Re-encrypt to verify
	testBuffer := make([]byte, 30)
	copy(testBuffer, []byte(flag))
	
	// Apply encryption operations
	for i := range testBuffer {
		testBuffer[i] ^= xorKey[i%len(xorKey)]
	}
	for i := range testBuffer {
		rotation := rotationPattern[i%len(rotationPattern)]
		testBuffer[i] = (testBuffer[i] << rotation) | (testBuffer[i] >> (8 - rotation))
	}
	for i := 0; i < len(testBuffer)-1; i += 2 {
		testBuffer[i], testBuffer[i+1] = testBuffer[i+1], testBuffer[i]
	}
	for i := range testBuffer {
		testBuffer[i] -= magicSub
	}
	for chunkStart := 0; chunkStart < len(testBuffer); chunkStart += chunkSize {
		chunkEnd := chunkStart + chunkSize
		if chunkEnd > len(testBuffer) {
			chunkEnd = len(testBuffer)
		}
		for i, j := chunkStart, chunkEnd-1; i < j; i, j = i+1, j-1 {
			testBuffer[i], testBuffer[j] = testBuffer[j], testBuffer[i]
		}
	}
	for i := range testBuffer {
		positionValue := ((i * i) + i) % 256
		testBuffer[i] ^= byte(positionValue)
	}
	
	// Check if it matches target
	match := true
	for i := range testBuffer {
		if testBuffer[i] != target[i] {
			match = false
			break
		}
	}
	
	if match {
		fmt.Println("✓ Decryption verified successfully!")
	} else {
		fmt.Println("✗ Decryption verification failed!")
	}
}