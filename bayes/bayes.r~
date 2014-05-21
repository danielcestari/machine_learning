

bayes <- function(dataset, query) {
	
	# sim
	#
	# v_sim = P(a1, ..., an | v_sim) * P(v_sim) / P(a1,..,an)
	#

	# nao
	#
	# v_nao = P(a1, ..., an | v_nao) * P(v_nao) / P(a1,..,an)
	#

	nAttrs = ncol(dataset)-1
	label = ncol(dataset)
	yesCounter = 0
	noCounter = 0
	for (i in 1:nrow(dataset)) {
		if (sum(dataset[i,1:nAttrs] == query) == nAttrs) {
			answer = dataset[i, label]

			if (answer == "Sim") {
				yesCounter = yesCounter + 1
			} else {
				noCounter = noCounter + 1
			}
		}
	}

	P_a1_a2_a3_a4__v_sim = yesCounter/sum(dataset[,label] == "Sim")
	P_a1_a2_a3_a4__v_nao = noCounter/sum(dataset[,label] == "Não")

	P_v_sim = sum(dataset[,label] == "Sim") / nrow(dataset)
	P_v_nao = sum(dataset[,label] == "Não") / nrow(dataset)

	yes = P_a1_a2_a3_a4__v_sim * P_v_sim
	no = P_a1_a2_a3_a4__v_nao * P_v_nao

	v_sim = yes / (yes+no)
	v_nao = no / (yes+no)

	cat("v_sim = ", v_sim, "\n")
	cat("v_nao = ", v_nao, "\n")
}
