
discreteKnn <- function(dataset, query, k=1) {

	label = ncol(dataset)
	distances = c()

	for (i in 1:nrow(dataset)) {
		instance = as.vector(ts(dataset[i,1:(label-1)]))
		distances = c(distances, sqrt(sum((instance - query)^2)))
	}

	# k-vizinhos mais proximos
	knnIDX = sort.list(distances)[1:k]
	knnRows = dataset[knnIDX,label]

	options = unique(knnRows)
	counting = c()

	for (i in 1:length(options)) {
		counting = c(counting, sum(options[i] == knnRows))
	}

	probs = counting / sum(counting)

	ret = list()
	ret$options = options
	ret$probs = probs
	ret$selected = options[which.max(probs)]

	ret
}

continuousKnn <- function(dataset, query, k=1) {

	label = ncol(dataset)
	distances = c()

	for (i in 1:nrow(dataset)) {
		instance = as.vector(ts(dataset[i,1:(label-1)]))
		distances = c(distances, sqrt(sum((instance - query)^2)))
	}

	# k-vizinhos mais proximos
	knnIDX = sort.list(distances)[1:k]
	knnRows = dataset[knnIDX,label]

	ret = list()
	ret$answer = mean(knnRows)

	ret
}
