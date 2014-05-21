validation <- function(dataset, train_func, test_func){
	# TODO escrever pré-condições e pós-condições


	# divide dataset, aleatoriamente
	# TODO permitir escolher a proporcao para treino e validacao
	# TODO garantir a extratificacao, balanceamento
	train_set = dataset

	test_set = dataset
	
	
	# treina com o dataset de treino
	trained = train_func(train_set)
	
	
	# valida o treinamento
	result = list()
	result$trained = trained
	result$erros = c()
	
	acertos = 0
	for(i in 1:length(test_set)){
		test_func(trained, test_set[i])
	}
	result$acertos = acertos/length(test_set)

	return (result)
}


