j main
j end
j end
j end
j end
j end
j end
j end
j timer_handler
j end
j end
j end
j external_handler
main:
li x11,0x80
li x12,0x8
li x13,0x4
csrrw x0,mie,x11
csrrw x0,mstatus,x12
csrrw x0,mtvec,x13
end:
    j end
timer_handler:
    csrrw x0,mie,x0
    li x3,0x5
    csrrw x0,mie,x11
    mret
external_handler:
    csrrw x0,mie,x0
    li x3,0x6
    csrrw x0,mie,x11
    mret

//csr
li x1,0x58
li x2,0x80
csrrw x3,mstatus,x1
csrrw x3,mstatus,x1
csrrw x3,mie,x2
csrrw x3,mie,x2
csrrw x3,mtvec,x1
csrrw x3,mtvec,x1
end:
    j end
//jal
li x1,0x8
jal x2,label
li x1,0x6
li x1,0x7
label:
	addi x3,x2,0x5
//load use hazard
li x1,0x8
sw x1,(0)x0
li x2,0x12
nop
lw x2,(0)x0
add x3,x2,x2

//control hazard test
li x1,0x80
bne x1,x0,taken
li x2,0x56
li x3,0x5
li x3,0x6
li x3,0x7
taken:
	li x3,0x8
//save test
li x3,0x54325682
li x4,0x35364732
sw x4,(0)x0
sb x3,(0)x0
sb x3,(1)x0
sb x3,(2)x0
sb x3,(3)x0
sh x3,(0)x0
sh x3,(1)x0
sh x3,(2)x0
sw x3,(3)x0
//
load test
li x3,0x54325682
sw x3,(3)x0
lb x3,(0)x0
lb x3,(1)x0
lb x3,(2)x0
lb x3,(3)x0
lh x3,(0)x0
lh x3,(1)x0
lh x3,(2)x0
lh x3,(3)x0
//R type
li x1,6
li x2,-3
add x3,x1,x2
sub x3,x1,x2
sll x3,x2,x1
slt x3,x1,x2
sltu x3,x1,x2
srl x3,x2,x1
//I type
li x1,6
addi x3,x1,-3	
slli x3,x1,2
slti x3,x1,-3
sltiu x3,x1,-3
srli x3,x1,2

