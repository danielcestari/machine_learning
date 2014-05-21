
# query = c(Ensolarado, Quente, Alta, Forte)
naiveBayes <- function(dataset, query) {
	
	dataset = as.matrix(dataset)
	query = as.vector(query)

	label = ncol(dataset)
	possibilities = unique(dataset[,label])
	probs = c()

	for (j in 1:length(possibilities)) {
		
		#
		# Prod_i=1_n { P(a_i|v_j) } * P(v_j)
		#
		#
		# P(Ensolarado|Sim) * P(Quente|Sim)
		#	 * P(Alta|Sim) * P(Forte |Sim) * P(Sim)

		ids = which(dataset[,label]==possibilities[j])
		factor = 1

		for(i in 1:length(query)) {
			P_a_i__v_j = sum(query[i] == dataset[ids,i]) / length(ids)
			factor = factor * P_a_i__v_j
		}

		factor = factor * length(ids) / nrow(dataset)
		probs = c(probs, factor)
	}

	ret = list()
	ret$possibilities = possibilities
	ret$probs = probs / sum(probs)

	ret
}
