#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <elf.h>
#include <capstone/capstone.h>

void disassemble_section(FILE *file, uint64_t offset, uint64_t size, uint64_t addr, int machine) {

    uint8_t *buffer = malloc(size);
    if (!buffer) {
        printf("Memory allocation failed\n");
        return;
    }

    fseek(file, offset, SEEK_SET);
    fread(buffer, 1, size, file);

    csh handle;
    cs_insn *insn;
    cs_arch arch;
    cs_mode mode;

    switch(machine) {

        case EM_X86_64:
            arch = CS_ARCH_X86;
            mode = CS_MODE_64;
            break;

        case EM_386:
            arch = CS_ARCH_X86;
            mode = CS_MODE_32;
            break;

        case EM_ARM:
            arch = CS_ARCH_ARM;
            mode = CS_MODE_ARM;
            break;

        case EM_AARCH64:
            arch = CS_ARCH_ARM64;
            mode = CS_MODE_ARM;
            break;

        default:
            printf("Unsupported architecture: %d\n", machine);
            free(buffer);
            return;
    }

    if (cs_open(arch, mode, &handle) != CS_ERR_OK) {
        printf("Capstone initialization failed\n");
        free(buffer);
        return;
    }

    size_t count = cs_disasm(handle, buffer, size, addr, 0, &insn);

    if (count > 0) {
        for (size_t i = 0; i < count; i++) {
            printf("0x%lx:\t%s\t%s\n",
                   insn[i].address,
                   insn[i].mnemonic,
                   insn[i].op_str);
        }
        cs_free(insn, count);
    } else {
        printf("Disassembly failed\n");
    }

    cs_close(&handle);
    free(buffer);
}

void parse_program_headers_64(FILE *file, Elf64_Ehdr *ehdr) {

    printf("\nProgram Headers (64-bit):\n");

    fseek(file, ehdr->e_phoff, SEEK_SET);

    for (int i = 0; i < ehdr->e_phnum; i++) {
        Elf64_Phdr phdr;
        fread(&phdr, 1, sizeof(phdr), file);

        printf(" Program Header %d\n", i);
        printf("  Type:   0x%x\n", phdr.p_type);
        printf("  Offset: 0x%lx\n", phdr.p_offset);
        printf("  Vaddr:  0x%lx\n", phdr.p_vaddr);
        printf("  Paddr:  0x%lx\n", phdr.p_paddr);
        printf("  Filesz: %lu\n", phdr.p_filesz);
        printf("  Memsz:  %lu\n", phdr.p_memsz);
        printf("  Flags:  0x%x\n", phdr.p_flags);
        printf("  Align:  0x%lx\n", phdr.p_align);
        printf("\n");
    }

    printf("----------------------------------\n");

    fseek(file, ehdr->e_shoff, SEEK_SET);

    for (int i = 0; i < ehdr->e_shnum; i++) {

        long header_pos = ftell(file); 

        Elf64_Shdr shdr;
        fread(&shdr, 1, sizeof(shdr), file);

        printf(" Section Header %d\n", i + 1);
        printf("  Name:   0x%x\n", shdr.sh_name);
        printf("  Type:   0x%x\n", shdr.sh_type);
        printf("  Flags:  0x%lx\n", shdr.sh_flags);
        printf("  Addr:   0x%lx\n", shdr.sh_addr);
        printf("  Offset: %lu\n", shdr.sh_offset);
        printf("  Size:   %lu\n", shdr.sh_size);
        printf("\n");

        if (shdr.sh_flags & SHF_EXECINSTR && shdr.sh_size > 0) {
            printf("Executable section found. Disassembling\n");

            disassemble_section(file, shdr.sh_offset, shdr.sh_size, shdr.sh_addr, ehdr -> e_machine);

            printf("\n");
        }

        fseek(file, header_pos + sizeof(Elf64_Shdr), SEEK_SET);
    }
}

void parse_program_headers_32(FILE *file, Elf32_Ehdr *ehdr) {

    printf("\nProgram Headers (32-bit):\n");

    fseek(file, ehdr->e_phoff, SEEK_SET);

    for (int i = 0; i < ehdr->e_phnum; i++) {
        Elf32_Phdr phdr;
        fread(&phdr, 1, sizeof(phdr), file);

        printf(" Header %d\n", i);
        printf("  Type:   0x%x\n", phdr.p_type);
        printf("  Offset: 0x%x\n", phdr.p_offset);
        printf("  Vaddr:  0x%x\n", phdr.p_vaddr);
        printf("  Paddr:  0x%x\n", phdr.p_paddr);
        printf("  Filesz: %u\n", phdr.p_filesz);
        printf("  Memsz:  %u\n", phdr.p_memsz);
        printf("  Flags:  0x%x\n", phdr.p_flags);
        printf("  Align:  0x%x\n", phdr.p_align);
        printf("\n");
    }

    printf("----------------------------------\n");

    fseek(file, ehdr->e_shoff, SEEK_SET);

    for (int i = 0; i < ehdr->e_shnum; i++) {

        Elf32_Shdr shdr;
        fread(&shdr, 1, sizeof(shdr), file);

        printf(" Section Header %d\n", i + 1);
        printf("  Name:   0x%x\n", shdr.sh_name);
        printf("  Type:   0x%x\n", shdr.sh_type);
        printf("  Flags:  0x%x\n", shdr.sh_flags);
        printf("  Addr:   0x%x\n", shdr.sh_addr);
        printf("  Offset: %u\n", shdr.sh_offset);
        printf("  Size:   %u\n", shdr.sh_size);
        printf("\n");

        if (shdr.sh_flags & SHF_EXECINSTR) {
            printf("Executable section found. Disassembling\n");
            disassemble_section(file, shdr.sh_offset, shdr.sh_size, shdr.sh_addr, ehdr -> e_machine);
        }
    }
}

int main(int argc, char *argv[]) {

    if (argc != 2) {
        printf("Usage: %s <elf_file>\n", argv[0]);
        return 1;
    }

    FILE *file = fopen(argv[1], "rb");

    if (!file) {
        perror("fopen");
        return 1;
    }

    unsigned char e_ident[EI_NIDENT];

    fread(e_ident, 1, EI_NIDENT, file);

    if (e_ident[EI_MAG0] != ELFMAG0 ||
        e_ident[EI_MAG1] != ELFMAG1 ||
        e_ident[EI_MAG2] != ELFMAG2 ||
        e_ident[EI_MAG3] != ELFMAG3) {

        printf("Not an ELF file\n");
        fclose(file);
        return 1;
    }

    rewind(file);

    if (e_ident[EI_CLASS] == ELFCLASS64) {

        Elf64_Ehdr ehdr;

        fread(&ehdr, 1, sizeof(ehdr), file);

        printf("ELF64 Header:\n");
        printf(" Entry point: 0x%lx\n", ehdr.e_entry);
        printf(" Program header offset: %lu\n", ehdr.e_phoff);
        printf(" Number of program headers: %u\n", ehdr.e_phnum);

        if (ehdr.e_phnum > 0) {
            parse_program_headers_64(file, &ehdr);
        }

    } else if (e_ident[EI_CLASS] == ELFCLASS32) {

        Elf32_Ehdr ehdr;

        fread(&ehdr, 1, sizeof(ehdr), file);

        printf("ELF32 Header:\n");
        printf(" Entry point: 0x%x\n", ehdr.e_entry);
        printf(" Program header offset: %u\n", ehdr.e_phoff);
        printf(" Number of program headers: %u\n", ehdr.e_phnum);

        if (ehdr.e_phnum > 0) {
            parse_program_headers_32(file, &ehdr);
        }

    } else {
        printf("Unknown ELF class\n");
    }

    fclose(file);
    return 0;
}