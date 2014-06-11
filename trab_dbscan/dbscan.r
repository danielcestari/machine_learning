
##
# Funcao que realiza clustering por densidade DBScan. Utiliza
# a matriz de distancia para isso.
##
# dataset 		=> Dataframe ou matriz com os dados a serem
#					agrupados
# epsilon		=> Valor limite de distancia para dois pontos 
#					serem considerados pertencentes ao mesmo 
#					cluster
##
# Retorna um vetor com os clusters que determinada posicao 
# representa do dataset
###

dbscan_dist <- function(dataset, epsilon){
	
	# calcula a matriz de distancia
	dist_mat = as.matrix(dist(as.matrix(dataset)))
	distancias = list()
	
	# para cada linha quais pontos estao proximo um do outro
	# dentro de epsilon de distancia
	for(sample_id in 1:nrow(dist_mat)){
		distancias[[sample_id]] = 
					which(dist_mat[sample_id, ] <= epsilon)
	}
	
	clusters = distancias
	i = 1
	
	while(i < length(clusters)){
		# para o i-esimo cluster itera ateh ele estar completo
		cluster = clusters[[i]]
		houve_uniao = TRUE
		while(houve_uniao && i < length(clusters)){
			unidos = c()
			houve_uniao = FALSE

			for(current in (i+1):length(clusters)){
				if(length(intersect(cluster, clusters[[current]])) > 0){
					cluster = union(cluster, clusters[[current]])
					houve_uniao = TRUE
					unidos = c(unidos, current)
				}
			}
			# remove clusters unidos
			clusters[unidos] = NULL
		}
		# i-esimo cluster pronto
		clusters[[i]] = cluster
		i = i + 1
	}
	
	# prepara o retorno, uma lista com o cluster de cada 
	# elemento
	ret = rep(-1, nrow(dataset))
	for(i in 1:length(clusters)){
		ret[ clusters[[i]] ] = i
	}

	return(ret)
}
