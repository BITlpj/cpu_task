#4,5,3,2,7->2,3,4,5,7
	xor $a0,$a0,$a0
	xor $a1,$a1,$a1
	addi $a1,$a1,2
	sw $a1,12($a0)
	addi $a1,$a1,1
	sw $a1,8($a0)
	addi $a1,$a1,1
	sw $a1,0($a0)
	addi $a1,$a1,1
	sw $a1,4($a0)
	addi $a1,$a1,2
	sw $a1,16($a0)
	xor $a2,$a2,$a2
bubsort:
	lui $a0, 0
	addi $a1,$a0,20  
loop1_start:
	xor $t0,$t0,$t0
	xor $t1,$t1,$t1
	addi $t1,$t1,4
loop2_start:
	slt $1,$9,$5
	beq $1,$0,loopl_end
	add $t3, $a0, $t1
	lw $t4, -4($t3)
	lw $t5, 0($t3)
	slt $1,$13,$12
	beq $1,$0,loop2_end
	xor $t0,$t0,$t0
	addi $t0,$t0,1
	sw $t4, 0($t3)
	sw $t5, -4($t3)
loop2_end:		
	addi $t1, $t1,4
	j loop2_start

loopl_end:
	lui $t6,0
	beq $t0,$t6,test_jal
	j loop1_start
test_jal:
	jal test_jr
stop:
	j stop
test_jr:
	jr $31 
	

