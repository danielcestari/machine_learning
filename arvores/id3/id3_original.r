
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

train <- function(node) {

	# calcular a entropia do node$set
	if (computeEntropy(node$set) == 0) {
		# sim? nao?
		label = ncol(node$set)
		answer = unique(node$set[, label])
		node$attrId = -1
		node$answer = answer
		return (node)
	}

	# calcular o ganho de informacao para cada atributo
	nAttrs = ncol(node$set)-1
	vGanho = c()
	for (i in 1:nAttrs) {
		vGanho = c(vGanho, ganho(node$set, i))
	}

	selectedAttr = which.max(vGanho)
	attrOptions = unique(node$set[,selectedAttr])

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
			train(node$children[[attrOptions[i]]])
	}

	return (node)
}

id3 <- function(set) {
	root = list()
	root$set = set

	root = train(root)

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



