
# Entropia
entropia <- function(casos) {
	# casos = c(9, 3)
	# prob = c(9/12, 3/12)
	# H = -(9/12 *log2(9/12) + 3/12*log2(3/12))

	prob = casos / sum(casos)
	H = -sum(prob[prob > 0] * log2(prob[prob > 0]))

	H
}

# Ganho de Informacao
# set - tabela com atributos e em que a ultima coluna define o conceito
#	que desejamos aprender
#
# attr = 1 (avaliando o atributo 1)
ganho <- function(set, attr) {
	
	label = ncol(set)
	allLabels = set[,label]
	options = unique(allLabels)

	counting = c()
	for (i in 1:length(options)) {
		counting = c(counting, sum(options[i] == allLabels))
	}
	Hset = entropia(counting) # entropia do conjunto

	H = c()
	countingAttr = c()
	attributeOptions = unique(set[,attr])
	for (i in 1:length(attributeOptions)) {
		# quantas vezes temos vento fraco e quantas vezes
		#	temos vento forte
		countingAttr = c(countingAttr,
			sum(set[,attr] == attributeOptions[i]))

		# para vento fraco
		#	encontre a entropia
		#
		# para vento forte
		#	encontre a entropia
		where = which(set[,attr] == attributeOptions[i])
		labelOptions = unique(set[where,label])
		countingLabel = c()
		for (j in 1:length(labelOptions)) {
			countingLabel = c(countingLabel,
			    sum(labelOptions[j] == set[where,label]))
		}

		H = c(H, entropia(countingLabel))
	}

	# Hset -> entropia do conjunto
	# countingAttr -> quantas ocorrencia para vento fraco e 
	#	quantas para vento forte -> c(8, 6)
	# H -> entropia para vento fraco e a entropia para vento
	#	forte -> c(val1, val2)
	proportion = countingAttr / sum(countingAttr)
	gain = Hset - sum(proportion * H)

	gain
}

computeEntropy <- function(set) {
	label = ncol(set)
	attrOptions = unique(set[, label])

	counting = c()
	for (i in 1:length(attrOptions)) {
		counting = c(counting, 
			     sum(attrOptions[i] == set[, label]))
	}

	return (entropia(counting))
}

train <- function(node, attrs) {

	# calcular a entropia do node$set
	# OU
	# se a entreopia NAO eh zero, mas acabaram os atributos
	#	significa que eh noh folha e precisa fazer o tratamento
	if (computeEntropy(node$set) == 0 || length(attrs) == 0) {
		# sim? nao?

		# eh preciso fazer a proporcao para cada opcao
		# 	caso tenha tres opcoes e no noh folha tenha numero igual
		#	da primeira e da terceira opcoes
		# 	a media daria o noh do meio, por isso eh preciso fazer
		#	a proporcao para cada opcao e pegar a maior
		label = ncol(node$set)
		answers = unique(node$set[, label])
		prop = c()
		for(i in 1:length(answers)){
			prop = c(prop, sum(node$set[, label] == answers[i]))
		}
		prop = prop/length(node$set[, label])

		# seleciona aleatoriamente dentro os de maior frequencia
		# which(prop == max(prop)) retorna um vetor com a posicao dos elementos
		# de maior frequencia
		# dentre esse eh sorteado um numero aleatorio que representa a posicao
		# nesse vetor de elementos maximos => runif
		# floor arredonda para baixo, pq comeca em 1 e termina em X.99
		iAnswer = floor( runif(1, 1, length(which(prop == max(prop)))+0.99))

		# DEBUG
		cat("prop:", prop, "\n")
		print(node$set)
		cat('iAnser:', iAnswer, '; answers', answers, '\n\n')

		# label = ncol(node$set)
		# answer = unique(node$set[, label])
		node$attrId = -1
		node$answer = answers[iAnswer]
		return (node)
	}

	# calcular o ganho de informacao para cada atributo
	nAttrs = ncol(node$set)-1
	vGanho = c()
	for (i in 1:length(attrs)) {
		vGanho = c(vGanho, ganho(node$set, attrs[i]))
	}

	# DEBUG verificando os ganhos
	#cat("nAttrs:", nAttrs, "\n")
	#print(node$set[0,])
	#cat("Ganhos: ", vGanho, "\n\n")

	selectedAttr = which.max(vGanho)
	attrOptions = unique(node$set[,selectedAttr])
	
	# remove o atributo apos seleciona-lo
	attrs <- attrs[-selectedAttr]

	node$attrId = selectedAttr
	node$attrOptions = attrOptions
	node$children = list()

	# "Ensolarado", "Nublado", "Chuvoso"
	for (i in 1:length(attrOptions)) {
		where = which(node$set[,selectedAttr] == 
				attrOptions[i])
		node$children[[attrOptions[i]]] = list()
		node$children[[attrOptions[i]]]$set=node$set[where,]

		# ocorre a chamada recursiva
		node$children[[attrOptions[i]]] = 
			train(node$children[[attrOptions[i]]], attrs)
	}

	return (node)
}

id3 <- function(set) {
	root = list()
	root$set = set
	attrs = 1:(ncol(set)-1)

	root = train(root, attrs)

	return (root)
}

search <- function(node, sample) {
	id = node$attrId
	cat("attrId: ", id, "\n")

	if (id == -1) {
		cat("Answer: ", levels(node$answer)[node$answer], "\n")
		return ();
	}

	childId = which(levels(node$attrOptions) == sample[id])
	cat("childId: ", childId, "\n")
	search(node$children[[childId]], sample)
}

test <- function (root, sample) {
	search(root, sample)
}



