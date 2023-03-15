# Coordinates are given in row major format
# (col,row) = (x,y)
# draw_background, draw_horizontal_line, draw_vertical_line, draw_dot subroutines written by J. Calllenes and P. Hummel
# draw Mario written by Ryan Leontini

.eqv BG_COLOR, 0x0F	 # light blue (0/7 red, 3/7 green, 3/3 blue)
.eqv VG_ADDR, 0x11000120
.eqv VG_COLOR, 0x11000140
.eqv PEACH_COLOR, 0xD5

main:
    li sp, 0x10000     #initialize stack pointer
	li s2, VG_ADDR     #load MMIO addresses 
	li s3, VG_COLOR    

	# fill screen using default color
	call draw_background  # must not modify s2, s3

    # Draw Mario
	li a3, 0xE0		# color red (7/7 red, 0/7 green, 0/3 blue)
	li a0, 20		# start X coordinate
	li a1, 20		# Y coordinate
	li a2, 25		# ending X coordinate
	call draw_horizontal_line  # must not modify: a3, s2, s3

    li a3, 0xE0		# color red (7/7 red, 0/7 green, 0/3 blue)
	li a0, 19		# start X coordinate
	li a1, 21		# Y coordinate
	li a2, 28		# ending X coordinate
	call draw_horizontal_line  # must not modify: a3, s2, s3

    li a3, PEACH_COLOR		# color peach (6/7 red, 5/7 green, 1/3 blue)
	li a0, 19		# start X coordinate
	li a1, 22		# Y coordinate
	li a2, 26		# ending X coordinate
	call draw_horizontal_line  # must not modify: a3, s2, s3

    li a3, PEACH_COLOR		# color peach (6/7 red, 5/7 green, 1/3 blue)
	li a0, 18		# start X coordinate
	li a1, 23		# Y coordinate
	li a2, 28		# ending X coordinate
	call draw_horizontal_line  # must not modify: a3, s2, s3

    li a3, PEACH_COLOR		# color peach (6/7 red, 5/7 green, 1/3 blue)
	li a0, 18		# start X coordinate
	li a1, 24		# Y coordinate
	li a2, 29		# ending X coordinate
	call draw_horizontal_line  # must not modify: a3, s2, s3

    li a3, PEACH_COLOR		# color peach (6/7 red, 5/7 green, 1/3 blue)
	li a0, 18		# start X coordinate
	li a1, 25		# Y coordinate
	li a2, 28		# ending X coordinate
	call draw_horizontal_line  # must not modify: a3, s2, s3

    li a3, PEACH_COLOR		# color peach (6/7 red, 5/7 green, 1/3 blue)
	li a0, 20		# start X coordinate
	li a1, 26		# Y coordinate
	li a2, 27		# ending X coordinate
	call draw_horizontal_line  # must not modify: a3, s2, s3

    # li a0, 10		# X coordinate
	# li a1, 20		# Y coordinate
	# li a3, 0xE0		# color red (7/7 red, 0/7 green, 0/3 blue)
	# call draw_dot  # must not modify s2, s3

	# li a0, 50		# X coordinate
	# li a1, 20		# Y coordinate
	# li a3, 0xE0		# color red (7/7 red, 0/7 green, 0/3 blue)
	# call draw_dot  # must not modify s2, s3

	# li a0, 5		# X coordinate
	# li a1, 5		# Y coordinate
	# li a3, 0xE5		# color off-red (7/7 red, 1/7 green, 1/3 blue)
	# call draw_dot  # must not modify s2, s3

	# li a3, 0xE0		# color red (7/7 red, 0/7 green, 0/3 blue)
	# li a0, 4		# start X coordinate
	# li a1, 1		# Y coordinate
	# li a2, 70		# ending X coordinate
	# call draw_horizontal_line  # must not modify: a3, s2, s3

    # li a3, 0xE0		# color red (7/7 red, 0/7 green, 0/3 blue)
	# li a0, 4		# start X coordinate
	# li a1, 2		# Y coordinate
	# li a2, 70		# ending X coordinate
	# call draw_horizontal_line  # must not modify: a3, s2, s3

	# li a0, 4		# X coordinate
	# li a1, 8		# starting Y coordinate
	# li a2, 55		# ending Y coordinate
	# call draw_vertical_line  # must not modify s2, s3


done:	j done # continuous loop

draw_mario:
    li a0, 0
    li a1, 0
    # Hat
    li a3, 0xE0		# color red (7/7 red, 0/7 green, 0/3 blue)
    addi a0, a4, 3	# start X coordinate
    addi a1, a5, 1  # Y coordinate
    li a2, 0
    addi a2, a0, 5  # end X coordinate
	call draw_horizontal_line  # must not modify: a3, s2, s3

    addi a0, a4, 2	# start X coordinate
    addi a1, a5, 2  # Y coordinate
    li a2, 0
    addi a2, a0, 9
	call draw_horizontal_line  # must not modify: a3, s2, s3

    ret
    # Face
    #addi a0, 

# draws a horizontal line from (a0,a1) to (a2,a1) using color in a3
# Modifies (directly or indirectly): t0, t1, a0, a2
draw_horizontal_line:
	addi sp,sp,-4
	sw ra, 0(sp)
	addi a2,a2,1	#go from a0 to a2 inclusive
draw_horiz1:
	call draw_dot  # must not modify: a0, a1, a2, a3
	addi a0,a0,1
	bne a0,a2, draw_horiz1
	lw ra, 0(sp)
	addi sp,sp,4
	ret

# draws a vertical line from (a0,a1) to (a0,a2) using color in a3
# Modifies (directly or indirectly): t0, t1, a1, a2
draw_vertical_line:
	addi sp,sp,-4
	sw ra, 0(sp)
	addi a2,a2,1
draw_vert1:
	call draw_dot  # must not modify: a0, a1, a2, a3
	addi a1,a1,1
	bne a1,a2,draw_vert1
	lw ra, 0(sp)
	addi sp,sp,4
	ret

# Fills the 60x80 grid with one color using successive calls to draw_horizontal_line
# Modifies (directly or indirectly): t0, t1, t4, a0, a1, a2, a3
draw_background:
	addi sp,sp,-4
	sw ra, 0(sp)
	li a3, BG_COLOR	#use default color
	li a1, 0	#a1= row_counter
	li t4, 60 	#max rows
start:	li a0, 0
	li a2, 79 	#total number of columns
	call draw_horizontal_line  # must not modify: t4, a1, a3
	addi a1,a1, 1
	bne t4,a1, start	#branch to draw more rows
	lw ra, 0(sp)
	addi sp,sp,4
	ret

# draws a dot on the display at the given coordinates:
# 	(X,Y) = (a0,a1) with a color stored in a3
# 	(col, row) = (a0,a1)
# Modifies (directly or indirectly): t0, t1
draw_dot:
	andi t0,a0,0x7F	# select bottom 7 bits (col)
	andi t1,a1,0x3F	# select bottom 6 bits  (row)
	slli t1,t1,7	#  {a1[5:0],a0[6:0]} 
	or t0,t1,t0	# 13-bit address
	sw t0, 0(s2)	# write 13 address bits to register
	sw a3, 0(s3)	# write color data to frame buffer
	ret
