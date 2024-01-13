li x1, 4 # number =4
li x2, 1 # factorial
li x3, 0 #product
li x4, 2 #i
loop: 
    bgt x4, x1, store
    addi x5 , x4 , 0    #x5=j
innerloop_start:
    beq x5, x0, innerloop_end
    add x3,x3,x2
    addi x5,x5,-1
    j innerloop_start
innerloop_end:
    addi x2,x3,0
    li  x3,0
    addi x4,x4,1
    j loop
store:
	sw x2,(0),x0
end:
    j end
