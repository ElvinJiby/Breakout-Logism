	.text
	# Function to initialise the layer of bricks for ball to destroy
	# Input:
	#	a0 - display array
	
	.globl initBrickLayer
	
initBrickLayer:
	li t0, 0xffffffff 	# load hex value with all bits set to 1
	sw t0, 32(a0) 		# store this value in display[8]
	jr ra 				# exit function
	 
