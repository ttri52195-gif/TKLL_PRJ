import sys

# --- CẤU HÌNH ---
HEX_FILE = 'program.hex'
OUTPUT_FILE = 'expected_regs.txt'

# --- 1. ĐỊNH NGHĨA OPCODE ---
# R-Type
OP_R_TYPE = 0x00
FUNCT_ADD = 0x20
FUNCT_SUB = 0x22
FUNCT_AND = 0x24
FUNCT_OR  = 0x25
FUNCT_SLT = 0x2A
FUNCT_XOR = 0x26  # ← THÊM XOR cho R-type

# I-Type Arithmetic & Control
OP_ADDI = 0x08
OP_BEQ  = 0x04
OP_LW   = 0x23
OP_SW   = 0x2B

# I-Type Logic (Zero-Extended)
OP_ANDI = 0x0C
OP_ORI  = 0x0D
OP_XORI = 0x0E

OP_J    = 0x02

# Khởi tạo Register File (32 thanh ghi, ban đầu bằng 0)
# regs[0] là thanh ghi số 0, regs[1] là thanh ghi số 1...
regs = [0] * 32
memory = {} 
pc = 0

def to_signed(val):
    """Chuyển 32-bit unsigned thành signed"""
    if val & 0x80000000:
        return val - 0x100000000
    return val

def zero_extend_16(val):
    """Zero-extend 16-bit thành 32-bit"""
    return val & 0xFFFF

def sign_extend_16(val):
    """Sign-extend 16-bit thành 32-bit"""
    if val & 0x8000:
        return val | 0xFFFF0000
    return val & 0xFFFF

def run_simulation():
    global pc
    
    # 1. Đọc file Hex
    try:
        with open(HEX_FILE, 'r') as f:
            lines = f.readlines()
        instructions = [int(line.strip(), 16) for line in lines if line.strip()]
    except FileNotFoundError:
        print(f"Lỗi: Không tìm thấy file '{HEX_FILE}'. Hãy tạo file này trước.")
        return

    print(f"Golden Model: Đang chạy mô phỏng {len(instructions)} lệnh...")

    # 2. Chạy vòng lặp giả lập
    steps = 0
    MAX_STEPS = 2000
    
    while steps < MAX_STEPS:
        if pc // 4 >= len(instructions):
            break 
            
        instr = instructions[pc // 4]
        
        # --- Decode ---
        opcode = (instr >> 26) & 0x3F
        rs = (instr >> 21) & 0x1F
        rt = (instr >> 16) & 0x1F
        rd = (instr >> 11) & 0x1F
        shamt = (instr >> 6) & 0x1F
        funct = instr & 0x3F
        
        imm_raw = instr & 0xFFFF
        
        # Zero Extended (cho ANDI, ORI, XORI)
        imm_zero = zero_extend_16(imm_raw)
        
        # Sign Extended (cho ADDI, LW, SW, BEQ)
        imm_signed = sign_extend_16(imm_raw)
        
        address = instr & 0x03FFFFFF

        next_pc = pc + 4

        # --- Execute ---
        # 1. R-Type
        if opcode == OP_R_TYPE:
            val_rs = regs[rs]
            val_rt = regs[rt]
            if funct == FUNCT_ADD:
                regs[rd] = (val_rs + val_rt) & 0xFFFFFFFF
            elif funct == FUNCT_SUB:
                regs[rd] = (val_rs - val_rt) & 0xFFFFFFFF
            elif funct == FUNCT_AND:
                regs[rd] = val_rs & val_rt
            elif funct == FUNCT_OR:
                regs[rd] = val_rs | val_rt
            elif funct == FUNCT_XOR:  # ← THÊM XOR
                regs[rd] = val_rs ^ val_rt
            elif funct == FUNCT_SLT:
                regs[rd] = 1 if to_signed(val_rs) < to_signed(val_rt) else 0

        # 2. I-Type Arithmetic (Sign Extended)
        elif opcode == OP_ADDI:
            regs[rt] = (regs[rs] + imm_signed) & 0xFFFFFFFF

        # 3. I-Type Logic (Zero Extended) - ← SỬA Ở ĐÂY
        elif opcode == OP_ANDI:
            regs[rt] = (regs[rs] & imm_zero)  # ← Dùng imm_zero
        elif opcode == OP_ORI:
            regs[rt] = (regs[rs] | imm_zero)  # ← Dùng imm_zero
        elif opcode == OP_XORI:
            regs[rt] = (regs[rs] ^ imm_zero)  # ← SỬA: Dùng imm_zero thay vì imm

        # 4. Control Flow
        elif opcode == OP_BEQ:
            if regs[rs] == regs[rt]:
                next_pc = pc + 4 + (imm_signed << 2)

        elif opcode == OP_J:
            next_pc = ((pc + 4) & 0xF0000000) | (address << 2)

        # 5. Memory
        elif opcode == OP_LW:
            addr = (regs[rs] + imm_signed) & 0xFFFFFFFF
            regs[rt] = memory.get(addr, 0)
        elif opcode == OP_SW:
            addr = (regs[rs] + imm_signed) & 0xFFFFFFFF
            memory[addr] = regs[rt]

        regs[0] = 0
        
        pc = next_pc
        steps += 1

    # 3. Xuất kết quả mong đợi ra file
    try:
        with open(OUTPUT_FILE, 'w') as f:
            for i in range(32):
                f.write(f"{regs[i]:08x}\n")
        
    except Exception as e:
        print(f"Lỗi khi ghi file: {e}")

if __name__ == "__main__":
    run_simulation()