# OTTER_MCU

Implementing the 32-Bit RISC-V OTTER microcontroller. This implementation of the OTTER_MCU can currently handle 3 types of RISC-V instructions, R-Type, I-Type, and B-Type, and will soon be able to handle all RISC-V instructions.

![OTTER_ARCHITECTURE](https://github.com/ryanleontini/OTTER/blob/main/imgs/OTTER_architecture_1_09.jpg?raw=true)

This simulation shows the OTTER_MCU running the assembly instructions shown below:

```
main: 	lui x5, 0xAA055
	addi x8, x5, 0x765
	slli x10, x8, 3
	slt x12, x5, x8
	xor x13, x8, x10
	beq x0, x0, main
```

![OTTER_SIMULATION](https://github.com/ryanleontini/OTTER/blob/main/imgs/miniOTTERsim.PNG?raw=true)
