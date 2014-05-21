
dataset_AND = matrix(
		    c(0,0,0,
		      0,1,0,
		      1,0,0,
		      1,1,1), nrow = 4, byrow=T)

dataset_XOR = matrix(
		    c(0,0,0,
		      0,1,1,
		      1,0,1,
		      1,1,0), nrow = 4, byrow=T)

activation <- function(value) {
	if (value > 0.5) return (1)
	return (0)
}

train <- function(dataset, eta=0.1, epochs=100) {

	W = runif(min=-1, max=1, n=ncol(dataset))
	counter = 1
	sumError2 = 0
	# W[1] -> theta
	# W[2] -> A
	# W[3] -> B
	
	for (e in 1:epochs) {
		for (i in 1:nrow(dataset)) {
			input = c(1, dataset[i,1:(ncol(dataset)-1)])
			#y = input %*% W
			net = input %*% W
			y = activation(net)
			d = dataset[i,ncol(dataset)]
			W = W + eta * (d - y)*input

			sumError2 = sumError2 + (d-y)^2
			cat("Sum E^2 = ", sumError2/counter, "\n")
			counter = counter + 1
		}
	}

	W
}

plotPerceptron <- function(W) {
	A = seq(0, 1, length=100)
	B = seq(0, 1, length=100)

	r = outer(A, B, function(x, y) { cbind(1, x, y) %*% W } )

	r[r > 0.5] = 1
	r[r <= 0.5] = 0

	filled.contour(A, B, r)
}
