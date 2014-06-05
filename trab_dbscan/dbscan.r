
# TODO: essa funcao nao esta totalmente correta

##
# Funcao que realiza clustering por densidade DBScan
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
dbscan <- function(dataset, epsilon=0.01){
	
	# inicializa clusters
	# o primeiro elemento sera o primeiro elemento do 
	# primeiro cluster
	clusters = list(1)

	# para facilitar retorna apenas uma lista em que cada
	# elemento representa um elemento do dataset, e terá o
	# valor do cluster que esse elemento foi agrupado
	ret = rep(0, length(dataset))

	# percorre o dataset
	for (sample_id in 1:nrow(dataset)){
		sample = dataset[sample_id, ]
		
		cat(sample_id); cat('\n')

		# compara o exemplo em questao com os elementos
		# jah agrupados
		create_cluster = FALSE
		for(cluster_id in 1:length(clusters)){
			
			# caso o exemplo esteja "perto" do elemento do
			# elemento do cluster sendo analizado, adiciona
			# sample ah esse cluster
			# caso sample nao esteja "perto" de nenhum
			# elemento jah agrupado, cria um cluster e insere
			# sample nesse cluster
			
			for(cluster_memb_id in clusters[[cluster_id]]){
				cluster_memb = dataset[cluster_memb_id, ]
				if(sqrt(sum((cluster_memb - sample)^2)) <= epsilon)
					1
				"if ( sqrt(sum((cluster_memb - sample)^2)) 
						<= epsilon){
					clusters[[cluster_id]] = c(
							clusters[[cluster_id]], sample_id)
					ret[sample_id] = cluster_id
					create_cluster = FALSE
					break
				} else{
					create_cluster = TRUE
				}"
			}
		}
		
		# cria novo cluster e insere sample nele
		if(create_cluster){
			clusters = c(clusters, list(sample_id))
			ret[sample_id] = length(clusters)
		}
	}

	return(ret)
}


##
# Funcao que faz agrupamento segundo o DBScan, mas utiliza
# a matriz de distancia para isso
##
# dataset		=> 
# epsilon		=> 
##
# 
###

dbscan_dist <- function(dataset, epsilon){
	
	# calcula a matriz de distancia
	dist_mat = as.matrix(dist(as.matrix(dataset)))
	
	#cat('\nDISTANCIAS\n'); print(dist_mat); cat('\n')

	clusters = list()
	
	# para cada linha quais pontos estao proximo um do outro
	# dentro de epsilon de distancia
	for(sample_id in 1:nrow(dist_mat)){
		clusters[[sample_id]] = 
					which(dist_mat[sample_id, ] <= epsilon)
	}


	#cat('\n\n');print(possible_clusters); cat('\n')
	
	#return(possible_clusters)

	# faz a uniao dos possiveis clusters
	teve_mudancas = TRUE
	while(teve_mudancas){
		teve_mudancas = FALSE
		for(i in 1:length(clusters)){
			remover = c()
			
			if(i == length(clusters))
				break
			for(j in (i+1):length(clusters) ){
				
				#cat('\nDENTRO FOR J\n')
				#cat('\nI ',i,' J', j,'\n')
				
				overlap = intersect( clusters[[j]], clusters[[i]] )
				
				#cat('\noverlap\n');print(overlap)

				if( length(overlap) > 0 ){
					
					#cat('\ndentro if\n')

					clusters[[i]] = union(clusters[[j]], clusters[[i]])
					teve_mudancas = TRUE
					remover = c(remover, j)
					#clusters[[j]] <- NULL
					#break

					#cat('\nFIM IF')
				}
			}
			
			for(j in remover)
				clusters[[j]] <- NULL

			if(teve_mudancas)
				break
		}
	}

	#return(clusters)

	# prepara o retorno, uma lista com o cluster de cada 
	# elemento
	ret = rep(-1, nrow(dataset))
	for(i in 1:length(clusters)){
		ret[ clusters[[i]] ] = i
	}

	return(ret)
}

