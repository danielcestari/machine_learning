
entropia <- function(serie, nstates = 5, epsilon = 0.00001) {
	
	states = c()
	Hs = c()
	intervals = seq(min(serie), max(serie)+epsilon, length=nstates+1)
	visits = matrix(0, nrow=nstates, ncol=nstates)
	old_state = -1

	for (i in 1:length(serie)) {
		
		# descobrindo qual eh o estado atualmente visitado
		state = which(serie[i] < intervals)[1]-1
		states = c(states, state)

		# contagem de visitas ou transicoes entre estados
		if (old_state != -1) {
			#cat("old_state = ", old_state, " state = ", state, "\n")
			visits[old_state, state] = 
				visits[old_state, state] + 1
		}
		old_state = state

		# calculando as probabilidades de transicao 
		#	entre estados
		probs = matrix(0.000001, nrow=nstates, ncol=nstates)
		for (j in 1:nrow(visits)) {
			probs[j,] = visits[j,] / sum(visits[j,])
		}

		# calculando entropia
		probs = probs[!is.na(probs)]
		H = -sum(probs[probs > 0]*log2(probs[probs > 0]))
		Hs = c(Hs, H)
	}

	ret = list()
	ret$states = states
	ret$Hs = Hs
	ret$dHdt = Hs[2:length(Hs)] - Hs[1:(length(Hs)-1)]

	return (ret)
}
