
result.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00003197          	auipc	gp,0x3
   4:	80018193          	add	gp,gp,-2048 # 2800 <_gbl_ptr>
   8:	00003117          	auipc	sp,0x3
   c:	5f810113          	add	sp,sp,1528 # 3600 <_stack_ptr>
  10:	00002297          	auipc	t0,0x2
  14:	ff028293          	add	t0,t0,-16 # 2000 <_bss_end>
  18:	00002317          	auipc	t1,0x2
  1c:	fe830313          	add	t1,t1,-24 # 2000 <_bss_end>

00000020 <_bss_init_loop>:
  20:	00534863          	blt	t1,t0,30 <_irq_config>
  24:	0002a023          	sw	zero,0(t0)
  28:	00428293          	add	t0,t0,4
  2c:	ff5ff06f          	j	20 <_bss_init_loop>

00000030 <_irq_config>:
  30:	05c00293          	li	t0,92
  34:	fff00313          	li	t1,-1
  38:	00004397          	auipc	t2,0x4
  3c:	fc838393          	add	t2,t2,-56 # 4000 <_trap_stack_ptr>
  40:	30529073          	csrw	mtvec,t0
  44:	30431073          	csrw	mie,t1
  48:	34039073          	csrw	mscratch,t2

0000004c <_main_call>:
  4c:	00000513          	li	a0,0
  50:	00000593          	li	a1,0
  54:	170000ef          	jal	1c4 <main>

00000058 <_endless_loop>:
  58:	0000006f          	j	58 <_endless_loop>

0000005c <_int_handler>:
  5c:	34011173          	csrrw	sp,mscratch,sp
  60:	fb010113          	add	sp,sp,-80
  64:	00112223          	sw	ra,4(sp)
  68:	00003097          	auipc	ra,0x3
  6c:	59808093          	add	ra,ra,1432 # 3600 <_stack_ptr>
  70:	fe1144e3          	blt	sp,ra,58 <_endless_loop>
  74:	00512623          	sw	t0,12(sp)
  78:	00612823          	sw	t1,16(sp)
  7c:	00712a23          	sw	t2,20(sp)
  80:	00a12c23          	sw	a0,24(sp)
  84:	00b12e23          	sw	a1,28(sp)
  88:	02c12023          	sw	a2,32(sp)
  8c:	02d12223          	sw	a3,36(sp)
  90:	02e12423          	sw	a4,40(sp)
  94:	02f12623          	sw	a5,44(sp)
  98:	03012823          	sw	a6,48(sp)
  9c:	03112a23          	sw	a7,52(sp)
  a0:	03c12c23          	sw	t3,56(sp)
  a4:	03d12e23          	sw	t4,60(sp)
  a8:	05e12023          	sw	t5,64(sp)
  ac:	05f12223          	sw	t6,68(sp)
  b0:	340022f3          	csrr	t0,mscratch
  b4:	34102373          	csrr	t1,mepc
  b8:	34202573          	csrr	a0,mcause
  bc:	00512423          	sw	t0,8(sp)
  c0:	04612423          	sw	t1,72(sp)
  c4:	04a12623          	sw	a0,76(sp)
  c8:	260000ef          	jal	328 <int_handler>
  cc:	00010513          	mv	a0,sp
  d0:	04852303          	lw	t1,72(a0)
  d4:	05010113          	add	sp,sp,80
  d8:	34011073          	csrw	mscratch,sp
  dc:	34131073          	csrw	mepc,t1
  e0:	00452083          	lw	ra,4(a0)
  e4:	00852103          	lw	sp,8(a0)
  e8:	00c52283          	lw	t0,12(a0)
  ec:	01052303          	lw	t1,16(a0)
  f0:	01452383          	lw	t2,20(a0)
  f4:	01c52583          	lw	a1,28(a0)
  f8:	02052603          	lw	a2,32(a0)
  fc:	02452683          	lw	a3,36(a0)
 100:	02852703          	lw	a4,40(a0)
 104:	02c52783          	lw	a5,44(a0)
 108:	03052803          	lw	a6,48(a0)
 10c:	03452883          	lw	a7,52(a0)
 110:	03852e03          	lw	t3,56(a0)
 114:	03c52e83          	lw	t4,60(a0)
 118:	04052f03          	lw	t5,64(a0)
 11c:	04452f83          	lw	t6,68(a0)
 120:	02852503          	lw	a0,40(a0)
 124:	30200073          	mret

00000128 <Fibanachi>:
 128:	fd010113          	add	sp,sp,-48
 12c:	02812623          	sw	s0,44(sp)
 130:	03010413          	add	s0,sp,48
 134:	fca42e23          	sw	a0,-36(s0)
 138:	fe042623          	sw	zero,-20(s0)
 13c:	00100793          	li	a5,1
 140:	fef42423          	sw	a5,-24(s0)
 144:	fe042223          	sw	zero,-28(s0)
 148:	00100793          	li	a5,1
 14c:	fef42023          	sw	a5,-32(s0)
 150:	fdc42783          	lw	a5,-36(s0)
 154:	00079663          	bnez	a5,160 <Fibanachi+0x38>
 158:	fe042623          	sw	zero,-20(s0)
 15c:	0540006f          	j	1b0 <Fibanachi+0x88>
 160:	fdc42703          	lw	a4,-36(s0)
 164:	00100793          	li	a5,1
 168:	02f71e63          	bne	a4,a5,1a4 <Fibanachi+0x7c>
 16c:	00100793          	li	a5,1
 170:	fef42623          	sw	a5,-20(s0)
 174:	03c0006f          	j	1b0 <Fibanachi+0x88>
 178:	fe842703          	lw	a4,-24(s0)
 17c:	fe442783          	lw	a5,-28(s0)
 180:	00f707b3          	add	a5,a4,a5
 184:	fef42623          	sw	a5,-20(s0)
 188:	fe842783          	lw	a5,-24(s0)
 18c:	fef42223          	sw	a5,-28(s0)
 190:	fec42783          	lw	a5,-20(s0)
 194:	fef42423          	sw	a5,-24(s0)
 198:	fe042783          	lw	a5,-32(s0)
 19c:	00178793          	add	a5,a5,1
 1a0:	fef42023          	sw	a5,-32(s0)
 1a4:	fe042703          	lw	a4,-32(s0)
 1a8:	fdc42783          	lw	a5,-36(s0)
 1ac:	fcf746e3          	blt	a4,a5,178 <Fibanachi+0x50>
 1b0:	fec42783          	lw	a5,-20(s0)
 1b4:	00078513          	mv	a0,a5
 1b8:	02c12403          	lw	s0,44(sp)
 1bc:	03010113          	add	sp,sp,48
 1c0:	00008067          	ret

000001c4 <main>:
 1c4:	fd010113          	add	sp,sp,-48
 1c8:	02112623          	sw	ra,44(sp)
 1cc:	02812423          	sw	s0,40(sp)
 1d0:	03010413          	add	s0,sp,48
 1d4:	fca42e23          	sw	a0,-36(s0)
 1d8:	fcb42c23          	sw	a1,-40(s0)
 1dc:	000017b7          	lui	a5,0x1
 1e0:	0007a223          	sw	zero,4(a5) # 1004 <_text_size+0x4>
 1e4:	000017b7          	lui	a5,0x1
 1e8:	0007a423          	sw	zero,8(a5) # 1008 <_text_size+0x8>
 1ec:	000017b7          	lui	a5,0x1
 1f0:	0007a023          	sw	zero,0(a5) # 1000 <_text_size>
 1f4:	fe042423          	sw	zero,-24(s0)
 1f8:	050007b7          	lui	a5,0x5000
 1fc:	0001c737          	lui	a4,0x1c
 200:	20070713          	add	a4,a4,512 # 1c200 <_trap_stack_ptr+0x18200>
 204:	00e7a623          	sw	a4,12(a5) # 500000c <_trap_stack_ptr+0x4ffc00c>
 208:	060007b7          	lui	a5,0x6000
 20c:	0001c737          	lui	a4,0x1c
 210:	20070713          	add	a4,a4,512 # 1c200 <_trap_stack_ptr+0x18200>
 214:	00e7a623          	sw	a4,12(a5) # 600000c <_trap_stack_ptr+0x5ffc00c>
 218:	000017b7          	lui	a5,0x1
 21c:	0007a703          	lw	a4,0(a5) # 1000 <_text_size>
 220:	00200793          	li	a5,2
 224:	fef71ae3          	bne	a4,a5,218 <main+0x54>
 228:	000017b7          	lui	a5,0x1
 22c:	0007a023          	sw	zero,0(a5) # 1000 <_text_size>
 230:	000017b7          	lui	a5,0x1
 234:	0047a783          	lw	a5,4(a5) # 1004 <_text_size+0x4>
 238:	00078513          	mv	a0,a5
 23c:	eedff0ef          	jal	128 <Fibanachi>
 240:	fea42423          	sw	a0,-24(s0)
 244:	000017b7          	lui	a5,0x1
 248:	0007a223          	sw	zero,4(a5) # 1004 <_text_size+0x4>
 24c:	000017b7          	lui	a5,0x1
 250:	0007a423          	sw	zero,8(a5) # 1008 <_text_size+0x8>
 254:	00300793          	li	a5,3
 258:	fef42623          	sw	a5,-20(s0)
 25c:	0bc0006f          	j	318 <main+0x154>
 260:	fec42703          	lw	a4,-20(s0)
 264:	00300793          	li	a5,3
 268:	02f71263          	bne	a4,a5,28c <main+0xc8>
 26c:	fe842783          	lw	a5,-24(s0)
 270:	3e800593          	li	a1,1000
 274:	00078513          	mv	a0,a5
 278:	2b0000ef          	jal	528 <__divsi3>
 27c:	00050793          	mv	a5,a0
 280:	03078713          	add	a4,a5,48
 284:	060007b7          	lui	a5,0x6000
 288:	00e7a023          	sw	a4,0(a5) # 6000000 <_trap_stack_ptr+0x5ffc000>
 28c:	fec42703          	lw	a4,-20(s0)
 290:	00200793          	li	a5,2
 294:	02f71263          	bne	a4,a5,2b8 <main+0xf4>
 298:	fe842783          	lw	a5,-24(s0)
 29c:	06400593          	li	a1,100
 2a0:	00078513          	mv	a0,a5
 2a4:	284000ef          	jal	528 <__divsi3>
 2a8:	00050793          	mv	a5,a0
 2ac:	03078713          	add	a4,a5,48
 2b0:	060007b7          	lui	a5,0x6000
 2b4:	00e7a023          	sw	a4,0(a5) # 6000000 <_trap_stack_ptr+0x5ffc000>
 2b8:	fec42703          	lw	a4,-20(s0)
 2bc:	00100793          	li	a5,1
 2c0:	02f71263          	bne	a4,a5,2e4 <main+0x120>
 2c4:	fe842783          	lw	a5,-24(s0)
 2c8:	00a00593          	li	a1,10
 2cc:	00078513          	mv	a0,a5
 2d0:	258000ef          	jal	528 <__divsi3>
 2d4:	00050793          	mv	a5,a0
 2d8:	03078713          	add	a4,a5,48
 2dc:	060007b7          	lui	a5,0x6000
 2e0:	00e7a023          	sw	a4,0(a5) # 6000000 <_trap_stack_ptr+0x5ffc000>
 2e4:	fec42783          	lw	a5,-20(s0)
 2e8:	02079263          	bnez	a5,30c <main+0x148>
 2ec:	fe842783          	lw	a5,-24(s0)
 2f0:	00a00593          	li	a1,10
 2f4:	00078513          	mv	a0,a5
 2f8:	2b4000ef          	jal	5ac <__modsi3>
 2fc:	00050793          	mv	a5,a0
 300:	03078713          	add	a4,a5,48
 304:	060007b7          	lui	a5,0x6000
 308:	00e7a023          	sw	a4,0(a5) # 6000000 <_trap_stack_ptr+0x5ffc000>
 30c:	fec42783          	lw	a5,-20(s0)
 310:	fff78793          	add	a5,a5,-1
 314:	fef42623          	sw	a5,-20(s0)
 318:	fec42703          	lw	a4,-20(s0)
 31c:	fff00793          	li	a5,-1
 320:	f4f710e3          	bne	a4,a5,260 <main+0x9c>
 324:	ef5ff06f          	j	218 <main+0x54>

00000328 <int_handler>:
 328:	ff010113          	add	sp,sp,-16
 32c:	00812623          	sw	s0,12(sp)
 330:	01010413          	add	s0,sp,16
 334:	050007b7          	lui	a5,0x5000
 338:	0007a703          	lw	a4,0(a5) # 5000000 <_trap_stack_ptr+0x4ffc000>
 33c:	07300793          	li	a5,115
 340:	02f71463          	bne	a4,a5,368 <int_handler+0x40>
 344:	05000737          	lui	a4,0x5000
 348:	060007b7          	lui	a5,0x6000
 34c:	00072703          	lw	a4,0(a4) # 5000000 <_trap_stack_ptr+0x4ffc000>
 350:	00e7a023          	sw	a4,0(a5) # 6000000 <_trap_stack_ptr+0x5ffc000>
 354:	000017b7          	lui	a5,0x1
 358:	0007a703          	lw	a4,0(a5) # 1000 <_text_size>
 35c:	00170713          	add	a4,a4,1
 360:	00e7a023          	sw	a4,0(a5)
 364:	1b40006f          	j	518 <_stack_size+0x18>
 368:	000017b7          	lui	a5,0x1
 36c:	0007a703          	lw	a4,0(a5) # 1000 <_text_size>
 370:	00100793          	li	a5,1
 374:	1af71263          	bne	a4,a5,518 <_stack_size+0x18>
 378:	000017b7          	lui	a5,0x1
 37c:	0087a783          	lw	a5,8(a5) # 1008 <_text_size+0x8>
 380:	00300713          	li	a4,3
 384:	14e78863          	beq	a5,a4,4d4 <int_handler+0x1ac>
 388:	00300713          	li	a4,3
 38c:	18f74663          	blt	a4,a5,518 <_stack_size+0x18>
 390:	00200713          	li	a4,2
 394:	0ee78663          	beq	a5,a4,480 <int_handler+0x158>
 398:	00200713          	li	a4,2
 39c:	16f74e63          	blt	a4,a5,518 <_stack_size+0x18>
 3a0:	00078863          	beqz	a5,3b0 <int_handler+0x88>
 3a4:	00100713          	li	a4,1
 3a8:	06e78863          	beq	a5,a4,418 <int_handler+0xf0>
 3ac:	16c0006f          	j	518 <_stack_size+0x18>
 3b0:	050007b7          	lui	a5,0x5000
 3b4:	0007a703          	lw	a4,0(a5) # 5000000 <_trap_stack_ptr+0x4ffc000>
 3b8:	00070793          	mv	a5,a4
 3bc:	00579793          	sll	a5,a5,0x5
 3c0:	40e787b3          	sub	a5,a5,a4
 3c4:	00279793          	sll	a5,a5,0x2
 3c8:	00e787b3          	add	a5,a5,a4
 3cc:	00379793          	sll	a5,a5,0x3
 3d0:	00078713          	mv	a4,a5
 3d4:	ffff47b7          	lui	a5,0xffff4
 3d8:	48078793          	add	a5,a5,1152 # ffff4480 <_trap_stack_ptr+0xffff0480>
 3dc:	00f707b3          	add	a5,a4,a5
 3e0:	00001737          	lui	a4,0x1
 3e4:	00472703          	lw	a4,4(a4) # 1004 <_text_size+0x4>
 3e8:	00e78733          	add	a4,a5,a4
 3ec:	000017b7          	lui	a5,0x1
 3f0:	00e7a223          	sw	a4,4(a5) # 1004 <_text_size+0x4>
 3f4:	05000737          	lui	a4,0x5000
 3f8:	060007b7          	lui	a5,0x6000
 3fc:	00072703          	lw	a4,0(a4) # 5000000 <_trap_stack_ptr+0x4ffc000>
 400:	00e7a023          	sw	a4,0(a5) # 6000000 <_trap_stack_ptr+0x5ffc000>
 404:	000017b7          	lui	a5,0x1
 408:	0087a703          	lw	a4,8(a5) # 1008 <_text_size+0x8>
 40c:	00170713          	add	a4,a4,1
 410:	00e7a423          	sw	a4,8(a5)
 414:	1040006f          	j	518 <_stack_size+0x18>
 418:	050007b7          	lui	a5,0x5000
 41c:	0007a703          	lw	a4,0(a5) # 5000000 <_trap_stack_ptr+0x4ffc000>
 420:	00070793          	mv	a5,a4
 424:	00179793          	sll	a5,a5,0x1
 428:	00e787b3          	add	a5,a5,a4
 42c:	00379793          	sll	a5,a5,0x3
 430:	00e787b3          	add	a5,a5,a4
 434:	00279793          	sll	a5,a5,0x2
 438:	00078713          	mv	a4,a5
 43c:	fffff7b7          	lui	a5,0xfffff
 440:	d4078793          	add	a5,a5,-704 # ffffed40 <_trap_stack_ptr+0xffffad40>
 444:	00f707b3          	add	a5,a4,a5
 448:	00001737          	lui	a4,0x1
 44c:	00472703          	lw	a4,4(a4) # 1004 <_text_size+0x4>
 450:	00e78733          	add	a4,a5,a4
 454:	000017b7          	lui	a5,0x1
 458:	00e7a223          	sw	a4,4(a5) # 1004 <_text_size+0x4>
 45c:	05000737          	lui	a4,0x5000
 460:	060007b7          	lui	a5,0x6000
 464:	00072703          	lw	a4,0(a4) # 5000000 <_trap_stack_ptr+0x4ffc000>
 468:	00e7a023          	sw	a4,0(a5) # 6000000 <_trap_stack_ptr+0x5ffc000>
 46c:	000017b7          	lui	a5,0x1
 470:	0087a703          	lw	a4,8(a5) # 1008 <_text_size+0x8>
 474:	00170713          	add	a4,a4,1
 478:	00e7a423          	sw	a4,8(a5)
 47c:	09c0006f          	j	518 <_stack_size+0x18>
 480:	050007b7          	lui	a5,0x5000
 484:	0007a703          	lw	a4,0(a5) # 5000000 <_trap_stack_ptr+0x4ffc000>
 488:	00070793          	mv	a5,a4
 48c:	00279793          	sll	a5,a5,0x2
 490:	00e787b3          	add	a5,a5,a4
 494:	00179793          	sll	a5,a5,0x1
 498:	e2078793          	add	a5,a5,-480
 49c:	00001737          	lui	a4,0x1
 4a0:	00472703          	lw	a4,4(a4) # 1004 <_text_size+0x4>
 4a4:	00e78733          	add	a4,a5,a4
 4a8:	000017b7          	lui	a5,0x1
 4ac:	00e7a223          	sw	a4,4(a5) # 1004 <_text_size+0x4>
 4b0:	05000737          	lui	a4,0x5000
 4b4:	060007b7          	lui	a5,0x6000
 4b8:	00072703          	lw	a4,0(a4) # 5000000 <_trap_stack_ptr+0x4ffc000>
 4bc:	00e7a023          	sw	a4,0(a5) # 6000000 <_trap_stack_ptr+0x5ffc000>
 4c0:	000017b7          	lui	a5,0x1
 4c4:	0087a703          	lw	a4,8(a5) # 1008 <_text_size+0x8>
 4c8:	00170713          	add	a4,a4,1
 4cc:	00e7a423          	sw	a4,8(a5)
 4d0:	0480006f          	j	518 <_stack_size+0x18>
 4d4:	050007b7          	lui	a5,0x5000
 4d8:	0007a783          	lw	a5,0(a5) # 5000000 <_trap_stack_ptr+0x4ffc000>
 4dc:	fd078793          	add	a5,a5,-48
 4e0:	00001737          	lui	a4,0x1
 4e4:	00472703          	lw	a4,4(a4) # 1004 <_text_size+0x4>
 4e8:	00e78733          	add	a4,a5,a4
 4ec:	000017b7          	lui	a5,0x1
 4f0:	00e7a223          	sw	a4,4(a5) # 1004 <_text_size+0x4>
 4f4:	05000737          	lui	a4,0x5000
 4f8:	060007b7          	lui	a5,0x6000
 4fc:	00072703          	lw	a4,0(a4) # 5000000 <_trap_stack_ptr+0x4ffc000>
 500:	00e7a023          	sw	a4,0(a5) # 6000000 <_trap_stack_ptr+0x5ffc000>
 504:	000017b7          	lui	a5,0x1
 508:	0087a703          	lw	a4,8(a5) # 1008 <_text_size+0x8>
 50c:	00170713          	add	a4,a4,1
 510:	00e7a423          	sw	a4,8(a5)
 514:	00000013          	nop
 518:	00000013          	nop
 51c:	00c12403          	lw	s0,12(sp)
 520:	01010113          	add	sp,sp,16
 524:	00008067          	ret

00000528 <__divsi3>:
 528:	06054063          	bltz	a0,588 <__umodsi3+0x10>
 52c:	0605c663          	bltz	a1,598 <__umodsi3+0x20>

00000530 <__hidden___udivsi3>:
 530:	00058613          	mv	a2,a1
 534:	00050593          	mv	a1,a0
 538:	fff00513          	li	a0,-1
 53c:	02060c63          	beqz	a2,574 <__hidden___udivsi3+0x44>
 540:	00100693          	li	a3,1
 544:	00b67a63          	bgeu	a2,a1,558 <__hidden___udivsi3+0x28>
 548:	00c05863          	blez	a2,558 <__hidden___udivsi3+0x28>
 54c:	00161613          	sll	a2,a2,0x1
 550:	00169693          	sll	a3,a3,0x1
 554:	feb66ae3          	bltu	a2,a1,548 <__hidden___udivsi3+0x18>
 558:	00000513          	li	a0,0
 55c:	00c5e663          	bltu	a1,a2,568 <__hidden___udivsi3+0x38>
 560:	40c585b3          	sub	a1,a1,a2
 564:	00d56533          	or	a0,a0,a3
 568:	0016d693          	srl	a3,a3,0x1
 56c:	00165613          	srl	a2,a2,0x1
 570:	fe0696e3          	bnez	a3,55c <__hidden___udivsi3+0x2c>
 574:	00008067          	ret

00000578 <__umodsi3>:
 578:	00008293          	mv	t0,ra
 57c:	fb5ff0ef          	jal	530 <__hidden___udivsi3>
 580:	00058513          	mv	a0,a1
 584:	00028067          	jr	t0
 588:	40a00533          	neg	a0,a0
 58c:	00b04863          	bgtz	a1,59c <__umodsi3+0x24>
 590:	40b005b3          	neg	a1,a1
 594:	f9dff06f          	j	530 <__hidden___udivsi3>
 598:	40b005b3          	neg	a1,a1
 59c:	00008293          	mv	t0,ra
 5a0:	f91ff0ef          	jal	530 <__hidden___udivsi3>
 5a4:	40a00533          	neg	a0,a0
 5a8:	00028067          	jr	t0

000005ac <__modsi3>:
 5ac:	00008293          	mv	t0,ra
 5b0:	0005ca63          	bltz	a1,5c4 <__modsi3+0x18>
 5b4:	00054c63          	bltz	a0,5cc <__modsi3+0x20>
 5b8:	f79ff0ef          	jal	530 <__hidden___udivsi3>
 5bc:	00058513          	mv	a0,a1
 5c0:	00028067          	jr	t0
 5c4:	40b005b3          	neg	a1,a1
 5c8:	fe0558e3          	bgez	a0,5b8 <__modsi3+0xc>
 5cc:	40a00533          	neg	a0,a0
 5d0:	f61ff0ef          	jal	530 <__hidden___udivsi3>
 5d4:	40b00533          	neg	a0,a1
 5d8:	00028067          	jr	t0

Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347          	.insn	4, 0x3a434347
   4:	2820                	.insn	2, 0x2820
   6:	5078                	.insn	2, 0x5078
   8:	6361                	.insn	2, 0x6361
   a:	4e47206b          	.insn	4, 0x4e47206b
   e:	2055                	.insn	2, 0x2055
  10:	4952                	.insn	2, 0x4952
  12:	562d4353          	.insn	4, 0x562d4353
  16:	4520                	.insn	2, 0x4520
  18:	626d                	.insn	2, 0x626d
  1a:	6465                	.insn	2, 0x6465
  1c:	6564                	.insn	2, 0x6564
  1e:	2064                	.insn	2, 0x2064
  20:	20434347          	.insn	4, 0x20434347
  24:	3878                	.insn	2, 0x3878
  26:	5f36                	.insn	2, 0x5f36
  28:	3436                	.insn	2, 0x3436
  2a:	2029                	.insn	2, 0x2029
  2c:	3331                	.insn	2, 0x3331
  2e:	322e                	.insn	2, 0x322e
  30:	302e                	.insn	2, 0x302e
	...

Disassembly of section .riscv.attributes:

00000000 <.riscv.attributes>:
   0:	2841                	.insn	2, 0x2841
   2:	0000                	.insn	2, 0x
   4:	7200                	.insn	2, 0x7200
   6:	7369                	.insn	2, 0x7369
   8:	01007663          	bgeu	zero,a6,14 <_start+0x14>
   c:	001e                	.insn	2, 0x001e
   e:	0000                	.insn	2, 0x
  10:	1004                	.insn	2, 0x1004
  12:	7205                	.insn	2, 0x7205
  14:	3376                	.insn	2, 0x3376
  16:	6932                	.insn	2, 0x6932
  18:	7032                	.insn	2, 0x7032
  1a:	5f31                	.insn	2, 0x5f31
  1c:	697a                	.insn	2, 0x697a
  1e:	32727363          	bgeu	tp,t2,344 <int_handler+0x1c>
  22:	3070                	.insn	2, 0x3070
  24:	0800                	.insn	2, 0x0800
  26:	0a01                	.insn	2, 0x0a01
  28:	Address 0x28 is out of bounds.


Disassembly of section .debug_line:

00000000 <.debug_line>:
   0:	0000014f          	.insn	4, 0x014f
   4:	0005                	.insn	2, 0x0005
   6:	0004                	.insn	2, 0x0004
   8:	002e                	.insn	2, 0x002e
   a:	0000                	.insn	2, 0x
   c:	0101                	.insn	2, 0x0101
   e:	fb01                	.insn	2, 0xfb01
  10:	0d0e                	.insn	2, 0x0d0e
  12:	0100                	.insn	2, 0x0100
  14:	0101                	.insn	2, 0x0101
  16:	0001                	.insn	2, 0x0001
  18:	0000                	.insn	2, 0x
  1a:	0001                	.insn	2, 0x0001
  1c:	0100                	.insn	2, 0x0100
  1e:	0101                	.insn	2, 0x0101
  20:	021f 0000 0000      	.insn	6, 0x021f
  26:	000000a3          	sb	zero,1(zero) # 1 <_start+0x1>
  2a:	0102                	.insn	2, 0x0102
  2c:	021f 020f 0111      	.insn	6, 0x0111020f021f
  32:	0000                	.insn	2, 0x
  34:	1101                	.insn	2, 0x1101
  36:	0001                	.insn	2, 0x0001
  38:	0100                	.insn	2, 0x0100
  3a:	0500                	.insn	2, 0x0500
  3c:	2802                	.insn	2, 0x2802
  3e:	0005                	.insn	2, 0x0005
  40:	0300                	.insn	2, 0x0300
  42:	00c4                	.insn	2, 0x00c4
  44:	0301                	.insn	2, 0x0301
  46:	0901                	.insn	2, 0x0901
  48:	0004                	.insn	2, 0x0004
  4a:	0301                	.insn	2, 0x0301
  4c:	0904                	.insn	2, 0x0904
  4e:	0004                	.insn	2, 0x0004
  50:	0301                	.insn	2, 0x0301
  52:	0901                	.insn	2, 0x0901
  54:	0004                	.insn	2, 0x0004
  56:	0301                	.insn	2, 0x0301
  58:	0901                	.insn	2, 0x0901
  5a:	0004                	.insn	2, 0x0004
  5c:	0301                	.insn	2, 0x0301
  5e:	0901                	.insn	2, 0x0901
  60:	0004                	.insn	2, 0x0004
  62:	0301                	.insn	2, 0x0301
  64:	0901                	.insn	2, 0x0901
  66:	0004                	.insn	2, 0x0004
  68:	0301                	.insn	2, 0x0301
  6a:	0901                	.insn	2, 0x0901
  6c:	0004                	.insn	2, 0x0004
  6e:	0301                	.insn	2, 0x0301
  70:	0902                	.insn	2, 0x0902
  72:	0004                	.insn	2, 0x0004
  74:	0301                	.insn	2, 0x0301
  76:	0901                	.insn	2, 0x0901
  78:	0004                	.insn	2, 0x0004
  7a:	0301                	.insn	2, 0x0301
  7c:	0901                	.insn	2, 0x0901
  7e:	0004                	.insn	2, 0x0004
  80:	0301                	.insn	2, 0x0301
  82:	0901                	.insn	2, 0x0901
  84:	0004                	.insn	2, 0x0004
  86:	0301                	.insn	2, 0x0301
  88:	0902                	.insn	2, 0x0902
  8a:	0004                	.insn	2, 0x0004
  8c:	0301                	.insn	2, 0x0301
  8e:	0902                	.insn	2, 0x0902
  90:	0004                	.insn	2, 0x0004
  92:	0301                	.insn	2, 0x0301
  94:	0901                	.insn	2, 0x0901
  96:	0004                	.insn	2, 0x0004
  98:	0301                	.insn	2, 0x0301
  9a:	0901                	.insn	2, 0x0901
  9c:	0004                	.insn	2, 0x0004
  9e:	0301                	.insn	2, 0x0301
  a0:	0902                	.insn	2, 0x0902
  a2:	0004                	.insn	2, 0x0004
  a4:	0301                	.insn	2, 0x0301
  a6:	0901                	.insn	2, 0x0901
  a8:	0004                	.insn	2, 0x0004
  aa:	0301                	.insn	2, 0x0301
  ac:	0901                	.insn	2, 0x0901
  ae:	0004                	.insn	2, 0x0004
  b0:	0301                	.insn	2, 0x0301
  b2:	0902                	.insn	2, 0x0902
  b4:	0004                	.insn	2, 0x0004
  b6:	0301                	.insn	2, 0x0301
  b8:	0906                	.insn	2, 0x0906
  ba:	0004                	.insn	2, 0x0004
  bc:	0301                	.insn	2, 0x0301
  be:	0901                	.insn	2, 0x0901
  c0:	0004                	.insn	2, 0x0004
  c2:	0301                	.insn	2, 0x0301
  c4:	0901                	.insn	2, 0x0901
  c6:	0004                	.insn	2, 0x0004
  c8:	0301                	.insn	2, 0x0301
  ca:	0901                	.insn	2, 0x0901
  cc:	0004                	.insn	2, 0x0004
  ce:	0301                	.insn	2, 0x0301
  d0:	0905                	.insn	2, 0x0905
  d2:	0004                	.insn	2, 0x0004
  d4:	0301                	.insn	2, 0x0301
  d6:	0902                	.insn	2, 0x0902
  d8:	0004                	.insn	2, 0x0004
  da:	0301                	.insn	2, 0x0301
  dc:	0902                	.insn	2, 0x0902
  de:	0004                	.insn	2, 0x0004
  e0:	0301                	.insn	2, 0x0301
  e2:	0901                	.insn	2, 0x0901
  e4:	0004                	.insn	2, 0x0004
  e6:	0301                	.insn	2, 0x0301
  e8:	0902                	.insn	2, 0x0902
  ea:	0004                	.insn	2, 0x0004
  ec:	0301                	.insn	2, 0x0301
  ee:	0902                	.insn	2, 0x0902
  f0:	0004                	.insn	2, 0x0004
  f2:	0301                	.insn	2, 0x0301
  f4:	0901                	.insn	2, 0x0901
  f6:	0004                	.insn	2, 0x0004
  f8:	0301                	.insn	2, 0x0301
  fa:	0901                	.insn	2, 0x0901
  fc:	0004                	.insn	2, 0x0004
  fe:	0301                	.insn	2, 0x0301
 100:	0901                	.insn	2, 0x0901
 102:	0004                	.insn	2, 0x0004
 104:	0301                	.insn	2, 0x0301
 106:	0904                	.insn	2, 0x0904
 108:	0004                	.insn	2, 0x0004
 10a:	0301                	.insn	2, 0x0301
 10c:	0901                	.insn	2, 0x0901
 10e:	0004                	.insn	2, 0x0004
 110:	0301                	.insn	2, 0x0301
 112:	0901                	.insn	2, 0x0901
 114:	0004                	.insn	2, 0x0004
 116:	0301                	.insn	2, 0x0301
 118:	0902                	.insn	2, 0x0902
 11a:	0004                	.insn	2, 0x0004
 11c:	0301                	.insn	2, 0x0301
 11e:	0901                	.insn	2, 0x0901
 120:	0004                	.insn	2, 0x0004
 122:	0301                	.insn	2, 0x0301
 124:	0901                	.insn	2, 0x0901
 126:	0004                	.insn	2, 0x0004
 128:	0301                	.insn	2, 0x0301
 12a:	0902                	.insn	2, 0x0902
 12c:	0004                	.insn	2, 0x0004
 12e:	0301                	.insn	2, 0x0301
 130:	0901                	.insn	2, 0x0901
 132:	0004                	.insn	2, 0x0004
 134:	0301                	.insn	2, 0x0301
 136:	0902                	.insn	2, 0x0902
 138:	0004                	.insn	2, 0x0004
 13a:	0301                	.insn	2, 0x0301
 13c:	0901                	.insn	2, 0x0901
 13e:	0004                	.insn	2, 0x0004
 140:	0301                	.insn	2, 0x0301
 142:	0901                	.insn	2, 0x0901
 144:	0004                	.insn	2, 0x0004
 146:	0301                	.insn	2, 0x0301
 148:	0901                	.insn	2, 0x0901
 14a:	0004                	.insn	2, 0x0004
 14c:	0901                	.insn	2, 0x0901
 14e:	0004                	.insn	2, 0x0004
 150:	0100                	.insn	2, 0x0100
 152:	Address 0x152 is out of bounds.


Disassembly of section .debug_line_str:

00000000 <.debug_line_str>:
   0:	775f5f2f          	.insn	4, 0x775f5f2f
   4:	7369722f          	.insn	4, 0x7369722f
   8:	6e2d7663          	bgeu	s10,sp,6f4 <__modsi3+0x148>
   c:	2d656e6f          	jal	t3,562e2 <_data_end+0x522e2>
  10:	6c65                	.insn	2, 0x6c65
  12:	2d66                	.insn	2, 0x2d66
  14:	2d636367          	.insn	4, 0x2d636367
  18:	7078                	.insn	2, 0x7078
  1a:	6361                	.insn	2, 0x6361
  1c:	69722f6b          	.insn	4, 0x69722f6b
  20:	2d766373          	.insn	4, 0x2d766373
  24:	6f6e                	.insn	2, 0x6f6e
  26:	656e                	.insn	2, 0x656e
  28:	652d                	.insn	2, 0x652d
  2a:	666c                	.insn	2, 0x666c
  2c:	672d                	.insn	2, 0x672d
  2e:	782d6363          	bltu	s10,sp,7b4 <__modsi3+0x208>
  32:	6170                	.insn	2, 0x6170
  34:	622f6b63          	bltu	t5,sp,66a <__modsi3+0xbe>
  38:	6975                	.insn	2, 0x6975
  3a:	646c                	.insn	2, 0x646c
  3c:	6e69772f          	.insn	4, 0x6e69772f
  40:	782d3233          	.insn	4, 0x782d3233
  44:	3436                	.insn	2, 0x3436
  46:	3638782f          	.insn	4, 0x3638782f
  4a:	365f 2d34 6370      	.insn	6, 0x63702d34365f
  50:	6c2d                	.insn	2, 0x6c2d
  52:	6e69                	.insn	2, 0x6e69
  54:	7875                	.insn	2, 0x7875
  56:	672d                	.insn	2, 0x672d
  58:	756e                	.insn	2, 0x756e
  5a:	6975622f          	.insn	4, 0x6975622f
  5e:	646c                	.insn	2, 0x646c
  60:	7369722f          	.insn	4, 0x7369722f
  64:	6e2d7663          	bgeu	s10,sp,750 <__modsi3+0x1a4>
  68:	2d656e6f          	jal	t3,5633e <_data_end+0x5233e>
  6c:	6c65                	.insn	2, 0x6c65
  6e:	2d66                	.insn	2, 0x2d66
  70:	2d636367          	.insn	4, 0x2d636367
  74:	3331                	.insn	2, 0x3331
  76:	322e                	.insn	2, 0x322e
  78:	302e                	.insn	2, 0x302e
  7a:	662d                	.insn	2, 0x662d
  7c:	6e69                	.insn	2, 0x6e69
  7e:	6c61                	.insn	2, 0x6c61
  80:	7369722f          	.insn	4, 0x7369722f
  84:	6e2d7663          	bgeu	s10,sp,770 <__modsi3+0x1c4>
  88:	2d656e6f          	jal	t3,5635e <_data_end+0x5235e>
  8c:	6c65                	.insn	2, 0x6c65
  8e:	2f66                	.insn	2, 0x2f66
  90:	7672                	.insn	2, 0x7672
  92:	2f693233          	.insn	4, 0x2f693233
  96:	6c69                	.insn	2, 0x6c69
  98:	3370                	.insn	2, 0x3370
  9a:	2f32                	.insn	2, 0x2f32
  9c:	696c                	.insn	2, 0x696c
  9e:	6762                	.insn	2, 0x6762
  a0:	2f006363          	bltu	zero,a6,386 <int_handler+0x5e>
  a4:	5f5f 2f77 6972      	.insn	6, 0x69722f775f5f
  aa:	2d766373          	.insn	4, 0x2d766373
  ae:	6f6e                	.insn	2, 0x6f6e
  b0:	656e                	.insn	2, 0x656e
  b2:	652d                	.insn	2, 0x652d
  b4:	666c                	.insn	2, 0x666c
  b6:	672d                	.insn	2, 0x672d
  b8:	782d6363          	bltu	s10,sp,83e <__modsi3+0x292>
  bc:	6170                	.insn	2, 0x6170
  be:	722f6b63          	bltu	t5,sp,7f4 <__modsi3+0x248>
  c2:	7369                	.insn	2, 0x7369
  c4:	6e2d7663          	bgeu	s10,sp,7b0 <__modsi3+0x204>
  c8:	2d656e6f          	jal	t3,5639e <_data_end+0x5239e>
  cc:	6c65                	.insn	2, 0x6c65
  ce:	2d66                	.insn	2, 0x2d66
  d0:	2d636367          	.insn	4, 0x2d636367
  d4:	7078                	.insn	2, 0x7078
  d6:	6361                	.insn	2, 0x6361
  d8:	75622f6b          	.insn	4, 0x75622f6b
  dc:	6c69                	.insn	2, 0x6c69
  de:	2f64                	.insn	2, 0x2f64
  e0:	336e6977          	.insn	4, 0x336e6977
  e4:	2d32                	.insn	2, 0x2d32
  e6:	3678                	.insn	2, 0x3678
  e8:	2f34                	.insn	2, 0x2f34
  ea:	72756f73          	.insn	4, 0x72756f73
  ee:	2f736563          	bltu	t1,s7,3d8 <int_handler+0xb0>
  f2:	2d636367          	.insn	4, 0x2d636367
  f6:	3331                	.insn	2, 0x3331
  f8:	322e                	.insn	2, 0x322e
  fa:	302e                	.insn	2, 0x302e
  fc:	62696c2f          	.insn	4, 0x62696c2f
 100:	2f636367          	.insn	4, 0x2f636367
 104:	666e6f63          	bltu	t3,t1,782 <__modsi3+0x1d6>
 108:	6769                	.insn	2, 0x6769
 10a:	7369722f          	.insn	4, 0x7369722f
 10e:	64007663          	bgeu	zero,zero,75a <__modsi3+0x1ae>
 112:	7669                	.insn	2, 0x7669
 114:	532e                	.insn	2, 0x532e
	...

Disassembly of section .debug_info:

00000000 <.debug_info>:
   0:	0000005b          	.insn	4, 0x005b
   4:	0005                	.insn	2, 0x0005
   6:	0401                	.insn	2, 0x0401
   8:	0000                	.insn	2, 0x
   a:	0000                	.insn	2, 0x
   c:	0001                	.insn	2, 0x0001
   e:	0000                	.insn	2, 0x
  10:	2800                	.insn	2, 0x2800
  12:	0005                	.insn	2, 0x0005
  14:	b400                	.insn	2, 0xb400
  16:	0001                	.insn	2, 0x0001
  18:	0000                	.insn	2, 0x
  1a:	7400                	.insn	2, 0x7400
  1c:	0000                	.insn	2, 0x
  1e:	1700                	.insn	2, 0x1700
  20:	0001                	.insn	2, 0x0001
  22:	0100                	.insn	2, 0x0100
  24:	0280                	.insn	2, 0x0280
  26:	00000123          	sb	zero,2(zero) # 2 <_start+0x2>
  2a:	285d                	.insn	2, 0x285d
  2c:	0005                	.insn	2, 0x0005
  2e:	8400                	.insn	2, 0x8400
  30:	0201                	.insn	2, 0x0201
  32:	0135                	.insn	2, 0x0135
  34:	0000                	.insn	2, 0x
  36:	305d                	.insn	2, 0x305d
  38:	0005                	.insn	2, 0x0005
  3a:	4800                	.insn	2, 0x4800
  3c:	2c02                	.insn	2, 0x2c02
  3e:	0001                	.insn	2, 0x0001
  40:	5d00                	.insn	2, 0x5d00
  42:	0530                	.insn	2, 0x0530
  44:	0000                	.insn	2, 0x
  46:	0248                	.insn	2, 0x0248
  48:	0000013f 0005785d 	.insn	8, 0x0005785d0000013f
  50:	1000                	.insn	2, 0x1000
  52:	4902                	.insn	2, 0x4902
  54:	0001                	.insn	2, 0x0001
  56:	5d00                	.insn	2, 0x5d00
  58:	05ac                	.insn	2, 0x05ac
  5a:	0000                	.insn	2, 0x
  5c:	0330                	.insn	2, 0x0330
	...

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	1101                	.insn	2, 0x1101
   2:	1001                	.insn	2, 0x1001
   4:	12011117          	auipc	sp,0x12011
   8:	1b0e030f          	.insn	4, 0x1b0e030f
   c:	250e                	.insn	2, 0x250e
   e:	130e                	.insn	2, 0x130e
  10:	0005                	.insn	2, 0x0005
  12:	0200                	.insn	2, 0x0200
  14:	002e                	.insn	2, 0x002e
  16:	193f0e03          	lb	t3,403(t5)
  1a:	1549                	.insn	2, 0x1549
  1c:	0111                	.insn	2, 0x0111
  1e:	0f12                	.insn	2, 0x0f12
  20:	0000                	.insn	2, 0x
  22:	00003b03          	.insn	4, 0x3b03
	...

Disassembly of section .debug_aranges:

00000000 <.debug_aranges>:
   0:	001c                	.insn	2, 0x001c
   2:	0000                	.insn	2, 0x
   4:	0002                	.insn	2, 0x0002
   6:	0000                	.insn	2, 0x
   8:	0000                	.insn	2, 0x
   a:	0004                	.insn	2, 0x0004
   c:	0000                	.insn	2, 0x
   e:	0000                	.insn	2, 0x
  10:	0528                	.insn	2, 0x0528
  12:	0000                	.insn	2, 0x
  14:	00b4                	.insn	2, 0x00b4
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
   0:	775f5f2f          	.insn	4, 0x775f5f2f
   4:	7369722f          	.insn	4, 0x7369722f
   8:	6e2d7663          	bgeu	s10,sp,6f4 <__modsi3+0x148>
   c:	2d656e6f          	jal	t3,562e2 <_data_end+0x522e2>
  10:	6c65                	.insn	2, 0x6c65
  12:	2d66                	.insn	2, 0x2d66
  14:	2d636367          	.insn	4, 0x2d636367
  18:	7078                	.insn	2, 0x7078
  1a:	6361                	.insn	2, 0x6361
  1c:	69722f6b          	.insn	4, 0x69722f6b
  20:	2d766373          	.insn	4, 0x2d766373
  24:	6f6e                	.insn	2, 0x6f6e
  26:	656e                	.insn	2, 0x656e
  28:	652d                	.insn	2, 0x652d
  2a:	666c                	.insn	2, 0x666c
  2c:	672d                	.insn	2, 0x672d
  2e:	782d6363          	bltu	s10,sp,7b4 <__modsi3+0x208>
  32:	6170                	.insn	2, 0x6170
  34:	622f6b63          	bltu	t5,sp,66a <__modsi3+0xbe>
  38:	6975                	.insn	2, 0x6975
  3a:	646c                	.insn	2, 0x646c
  3c:	6e69772f          	.insn	4, 0x6e69772f
  40:	782d3233          	.insn	4, 0x782d3233
  44:	3436                	.insn	2, 0x3436
  46:	756f732f          	.insn	4, 0x756f732f
  4a:	6372                	.insn	2, 0x6372
  4c:	7365                	.insn	2, 0x7365
  4e:	6363672f          	.insn	4, 0x6363672f
  52:	312d                	.insn	2, 0x312d
  54:	2e322e33          	.insn	4, 0x2e322e33
  58:	2f30                	.insn	2, 0x2f30
  5a:	696c                	.insn	2, 0x696c
  5c:	6762                	.insn	2, 0x6762
  5e:	632f6363          	bltu	t5,s2,684 <__modsi3+0xd8>
  62:	69666e6f          	jal	t3,666f8 <_data_end+0x626f8>
  66:	69722f67          	.insn	4, 0x69722f67
  6a:	2f766373          	.insn	4, 0x2f766373
  6e:	6964                	.insn	2, 0x6964
  70:	2e76                	.insn	2, 0x2e76
  72:	5f2f0053          	.insn	4, 0x5f2f0053
  76:	775f 722f 7369      	.insn	6, 0x7369722f775f
  7c:	6e2d7663          	bgeu	s10,sp,768 <__modsi3+0x1bc>
  80:	2d656e6f          	jal	t3,56356 <_data_end+0x52356>
  84:	6c65                	.insn	2, 0x6c65
  86:	2d66                	.insn	2, 0x2d66
  88:	2d636367          	.insn	4, 0x2d636367
  8c:	7078                	.insn	2, 0x7078
  8e:	6361                	.insn	2, 0x6361
  90:	69722f6b          	.insn	4, 0x69722f6b
  94:	2d766373          	.insn	4, 0x2d766373
  98:	6f6e                	.insn	2, 0x6f6e
  9a:	656e                	.insn	2, 0x656e
  9c:	652d                	.insn	2, 0x652d
  9e:	666c                	.insn	2, 0x666c
  a0:	672d                	.insn	2, 0x672d
  a2:	782d6363          	bltu	s10,sp,828 <__modsi3+0x27c>
  a6:	6170                	.insn	2, 0x6170
  a8:	622f6b63          	bltu	t5,sp,6de <__modsi3+0x132>
  ac:	6975                	.insn	2, 0x6975
  ae:	646c                	.insn	2, 0x646c
  b0:	6e69772f          	.insn	4, 0x6e69772f
  b4:	782d3233          	.insn	4, 0x782d3233
  b8:	3436                	.insn	2, 0x3436
  ba:	3638782f          	.insn	4, 0x3638782f
  be:	365f 2d34 6370      	.insn	6, 0x63702d34365f
  c4:	6c2d                	.insn	2, 0x6c2d
  c6:	6e69                	.insn	2, 0x6e69
  c8:	7875                	.insn	2, 0x7875
  ca:	672d                	.insn	2, 0x672d
  cc:	756e                	.insn	2, 0x756e
  ce:	6975622f          	.insn	4, 0x6975622f
  d2:	646c                	.insn	2, 0x646c
  d4:	7369722f          	.insn	4, 0x7369722f
  d8:	6e2d7663          	bgeu	s10,sp,7c4 <__modsi3+0x218>
  dc:	2d656e6f          	jal	t3,563b2 <_data_end+0x523b2>
  e0:	6c65                	.insn	2, 0x6c65
  e2:	2d66                	.insn	2, 0x2d66
  e4:	2d636367          	.insn	4, 0x2d636367
  e8:	3331                	.insn	2, 0x3331
  ea:	322e                	.insn	2, 0x322e
  ec:	302e                	.insn	2, 0x302e
  ee:	662d                	.insn	2, 0x662d
  f0:	6e69                	.insn	2, 0x6e69
  f2:	6c61                	.insn	2, 0x6c61
  f4:	7369722f          	.insn	4, 0x7369722f
  f8:	6e2d7663          	bgeu	s10,sp,7e4 <__modsi3+0x238>
  fc:	2d656e6f          	jal	t3,563d2 <_data_end+0x523d2>
 100:	6c65                	.insn	2, 0x6c65
 102:	2f66                	.insn	2, 0x2f66
 104:	7672                	.insn	2, 0x7672
 106:	2f693233          	.insn	4, 0x2f693233
 10a:	6c69                	.insn	2, 0x6c69
 10c:	3370                	.insn	2, 0x3370
 10e:	2f32                	.insn	2, 0x2f32
 110:	696c                	.insn	2, 0x696c
 112:	6762                	.insn	2, 0x6762
 114:	47006363          	bltu	zero,a6,57a <__umodsi3+0x2>
 118:	554e                	.insn	2, 0x554e
 11a:	4120                	.insn	2, 0x4120
 11c:	2e322053          	.insn	4, 0x2e322053
 120:	3134                	.insn	2, 0x3134
 122:	5f00                	.insn	2, 0x5f00
 124:	645f 7669 6973      	.insn	6, 0x69737669645f
 12a:	5f5f0033          	.insn	4, 0x5f5f0033
 12e:	6968                	.insn	2, 0x6968
 130:	6464                	.insn	2, 0x6464
 132:	6e65                	.insn	2, 0x6e65
 134:	5f5f 755f 6964      	.insn	6, 0x6964755f5f5f
 13a:	7376                	.insn	2, 0x7376
 13c:	3369                	.insn	2, 0x3369
 13e:	5f00                	.insn	2, 0x5f00
 140:	755f 6f6d 7364      	.insn	6, 0x73646f6d755f
 146:	3369                	.insn	2, 0x3369
 148:	5f00                	.insn	2, 0x5f00
 14a:	6d5f 646f 6973      	.insn	6, 0x6973646f6d5f
 150:	Address 0x150 is out of bounds.

