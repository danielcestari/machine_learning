###
# Funcao que quebra faz o split do texto pelo espaco, 
# removendo stopwords e palavras maiores que um certo 
# tamanho, e fazendo stemming
# tambem remove contracoes do ingles, como I'll
##
# text			=> texto a ser processado
# min_size		=> tamanho minimo das palavras ja 
#					feito o stemming
# sep_char		=> caracter separador de palavras
##
# Retorna uma lista de palavras processadas
##

def text_processing(text, min_size=4, sep_char=' '):
	from nltk.stem.snowball import EnglishStemmer
	from nltk.corpus import stopwords as stwds

	stemmer = EnglishStemmer()
	stopwords = set(stwds.words('english') + 
			contractions_without_punc)
	
	text = [w for w in text.split(sep_char) 
			if not w in stopwords
			and len(w) >= min_size]
	words = list()
	for word in text:
		words.append(stemmer.stem(word))
	
	return words



###
# Funcao que prepara os dados vindos do Reuters dataset
##
# file_name 		=> lista com os arquivos para processar
# separation_tag	=> nome da tag que separa os registros
##
# retorna um dicionario com duas chaves, uma para os textos, 
# sendo uma lista com todos os textos, e outra para os 
# topicos, sendo outro dicionario tendo como chave os topicos
# e dentro de cada topico uma lista com os indices dos textos
# relacionados a esse topico
##
# ex: 	{
#			'texts': ['primeiro texto', 'segundo texto', ...],
#			'topics: {
#						'oat': [4, 96, 196, 416, 854], 
#						'saudriyal': [914], 
#						'housing': [28], 
#						'groundnut-oil': [312], 
#						'citruspulp': [326]
#						}
#		}
# 
###

def prepare_reuters_data(file_name_list=list(), 
			process_text=True,
			text_processing_function=text_processing):
	from bs4 import BeautifulSoup
	from re import sub as replace
	from datetime import datetime as date
	
	# tags usados na estruturacao da noticia
	record_tag = 'reuters'
	topics_tag = 'topics'
	topic_tag = 'd'
	text_tag = 'text'
	
	
	result = dict({'texts': list(), 'topics': dict(), 
					'text_to_topics':[]})
	index = 0
	
	for file_name in file_name_list:
		print(date.now().strftime('[%Y-%m-%d %H:%M:%S]') + 
				" - Processando arquivo: %s" % file_name)

		file = open(file_name, 'r', encoding='utf-8', 
					errors='ignore')
		xml = BeautifulSoup( file.read() ). \
				findAll(record_tag)
		
		print("\tNumero de registros a ser processado: %d" % 
				len(xml))

		for record in xml:
			topics = record.find(topics_tag). \
				findAll(topic_tag)

			# descarta noticias sem topico
			if len(topics) == 0:
				continue
			
			# adiciona o indice do texto atual na lista dos 
			# topicos presentes nessa noticia
			current_topics = []
			for topic in topics:
				if not topic.text in result['topics'].keys():
					result['topics'][topic.text] = list()
				result['topics'][topic.text].append(index)
				current_topics.append(topic.text)
			
			# dado um texto, i-esimo elemento da lista 
			# result['texts'], cria uma lista com os topicos
			# relacionados a esse texto
			result['text_to_topics'].append(current_topics)

			text = record.find(text_tag).text
			if process_text:
				# remove caracteres que nao alpha-numerico e
				# espaco, tambem muda texto para caixa baixo
				# substitue qualquer espaco por apenas um
				text = replace(r'([\s]+)', r' ', text.lower())
				text = replace(r'([^a-zA-Z ]+)', r'', text)
				# aplica funcao processing_text_function
				text = text_processing_function(text)
			result['texts'].append(text)
			
			#print(index)
			index += 1
	
	return result

#prepare_reuters_data('../../../dataset/reuters/reut2-000.sgm')
# para teste
dir_base = '../../../dataset/reuters/dataset/'
reuters = [dir_base+'reut2-000.sgm', dir_base+'reut2-001.sgm']
all_reuters = [dir_base+'reut2-'+'{0:03d}'.format(i)+'.sgm' for i in range(0,22) ]




# Dicionario com a lista de contracoes da lingua inglesa
# retirado de: http://stackoverflow.com/questions/19790188/expanding-english-language-contractions-in-python
# Apenas as chaves desse dicionario serao usadas
contractions = { 
	"ain't": "am not; are not; is not; has not; have not[1]",
	"aren't": "are not; am not[2]",
	"can't": "cannot",
	"can't've": "cannot have",
	"'cause": "because",
	"could've": "could have",
	"couldn't": "could not",
	"couldn't've": "could not have",
	"didn't": "did not",
	"doesn't": "does not",
	"don't": "do not",
	"hadn't": "had not",
	"hadn't've": "had not have",
	"hasn't": "has not",
	"haven't": "have not",
	"he'd": "he had / he would",
	"he'd've": "he would have",
	"he'll": "he shall / he will",
	"he'll've": "he shall have / he will have",
	"he's": "he has / he is",
	"how'd": "how did",
	"how'd'y": "how do you",
	"how'll": "how will",
	"how's": "how has / how is / how does",
	"I'd": "I had / I would",
	"I'd've": "I would have",
	"I'll": "I shall / I will",
	"I'll've": "I shall have / I will have",
	"I'm": "I am",
	"I've": "I have",
	"isn't": "is not",
	"it'd": "it had / it would",
	"it'd've": "it would have",
	"it'll": "it shall / it will",
	"it'll've": "it shall have / it will have",
	"it's": "it has / it is",
	"let's": "let us",
	"ma'am": "madam",
	"mayn't": "may not",
	"might've": "might have",
	"mightn't": "might not",
	"mightn't've": "might not have",
	"must've": "must have",
	"mustn't": "must not",
	"mustn't've": "must not have",
	"needn't": "need not",
	"needn't've": "need not have",
	"o'clock": "of the clock",
	"oughtn't": "ought not",
	"oughtn't've": "ought not have",
	"shan't": "shall not",
	"sha'n't": "shall not",
	"shan't've": "shall not have",
	"she'd": "she had / she would",
	"she'd've": "she would have",
	"she'll": "she shall / she will",
	"she'll've": "she shall have / she will have",
	"she's": "she has / she is",
	"should've": "should have",
	"shouldn't": "should not",
	"shouldn't've": "should not have",
	"so've": "so have",
	"so's": "so as / so is",
	"that'd": "that would / that had",
	"that'd've": "that would have",
	"that's": "that has / that is",
	"there'd": "there had / there would",
	"there'd've": "there would have",
	"there's": "there has / there is",
	"they'd": "they had / they would",
	"they'd've": "they would have",
	"they'll": "they shall / they will",
	"they'll've": "they shall have / they will have",
	"they're": "they are",
	"they've": "they have",
	"to've": "to have",
	"wasn't": "was not",
	"we'd": "we had / we would",
	"we'd've": "we would have",
	"we'll": "we will",
	"we'll've": "we will have",
	"we're": "we are",
	"we've": "we have",
	"weren't": "were not",
	"what'll": "what shall / what will",
	"what'll've": "what shall have / what will have",
	"what're": "what are",
	"what's": "what has / what is",
	"what've": "what have",
	"when's": "when has / when is",
	"when've": "when have",
	"where'd": "where did",
	"where's": "where has / where is",
	"where've": "where have",
	"who'll": "who shall / who will",
	"who'll've": "who shall have / who will have",
	"who's": "who has / who is",
	"who've": "who have",
	"why's": "why has / why is",
	"why've": "why have",
	"will've": "will have",
	"won't": "will not",
	"won't've": "will not have",
	"would've": "would have",
	"wouldn't": "would not",
	"wouldn't've": "would not have",
	"y'all": "you all",
	"y'all'd": "you all would",
	"y'all'd've": "you all would have",
	"y'all're": "you all are",
	"y'all've": "you all have",
	"you'd": "you had / you would",
	"you'd've": "you would have",
	"you'll": "you shall / you will",
	"you'll've": "you shall have / you will have",
	"you're": "you are",
	"you've": "you have"
}
# cria lista com contracoes sem os apostrofos
from re import sub as replace
contractions_without_punc = replace(r'([^a-z ]+)', r'', ' '.join(contractions.keys())).split(' ')


##
# Funcao que cria o "modelo" naivebayes, uma estrutura 
# com as probabilidades calculadas
##
# texts			=> Lista com o nome dos arquivos a serem 
#					aprendidos, ou a estrutura de texto ja
# 					processada (estrutura retornada pela
#					funcao prepare_reuters_data)
#
##
# Retorna uma dicionario cujas chaves sao os topicos 
# encontrados, para cada chave ha outro dicionario associado
# contendo duas chaves, a probabilidade do topico em questao,
# a um dicionario com as frequencias de cada palavra dado o
# topico em questao
##
# ex:
# {
#	'coffee': {
#			'P_wk': {
#					'export': Decimal('0.03947368421052631578947368421'),
#					'still': Decimal('0.02631578947368421052631578947'),
#					'follow': Decimal('0.02631578947368421052631578947'),
#					'affect': Decimal('0.02631578947368421052631578947'),
#					'chang': Decimal('0.02631578947368421052631578947'),
#					'eightmemb': Decimal('0.02631578947368421052631578947'),
#					'session': Decimal('0.02631578947368421052631578947'),
#					'present': Decimal('0.02631578947368421052631578947'),
#					'splinter': Decimal('0.02631578947368421052631578947'),
#					'london': Decimal('0.02631578947368421052631578947'),
#					'group': Decimal('0.02631578947368421052631578947')
#			},
#			'P_topic': 1.0
#	}
# }
#
###

def learn_naivebayes_text(texts=[]):
	from datetime import datetime as date
	from decimal import Decimal, Context 
	
	# cria contexto para o built-in Decimal
	context = Context()

	if type(texts).__name__ == 'list':
		print('Preparando dados')
		proc_texts = prepare_reuters_data(texts)
	else:
		proc_texts = texts
	
	print('\n\nCalculo das probabilidades\n')
	
	# cria vocabulario e ja conta ocorrencias de palavas
	# por texto
	vocabulary = set()
	freq_words = []
	index = 0 
	for text in proc_texts['texts']:
		
		# contagem das palavras
		freq_words.append({})
		for word in text:
			if not word in freq_words[index]:
				freq_words[index][word] = 0
			freq_words[index][word] += 1
		
		# criacao do vocabulario
		vocabulary.update(text)
		index += 1
	
	# ja adiciona um para evitar a prob ser zero
	vocabulary_size = len(vocabulary)
	vocab_freq = {}
	for word in vocabulary:
		vocab_freq[word] = 1
	
	# calculando P_topicj e P_wk__topicj
	topics = {}
	total_texts = len(proc_texts['texts'])
	for topic, text_indices in proc_texts['topics'].items():
		
		print("\t" + date.now().strftime('[%Y-%m-%d %H:%M:%S]')
			+ " topico: %s" % topic)

		topics[topic] = {
			'P_topic': Decimal( len(text_indices) / total_texts),
			'P_wk': vocab_freq
		}
		
		# itera os textos do topico em questao
		total_words = 0
		for text in text_indices:
			for word, freq in freq_words[text].items():
				topics[topic]['P_wk'][word] += freq
			total_words += len(freq_words[text])
		
		# frequencia das palavras para o topico em questao
		# ja contadas, e acrescidas de 1, para evitar o zero
		# agora calcula a prob real da palavra dado o topico
		for word, freq in topics[topic]['P_wk'].items():
			topics[topic]['P_wk'][word] = context.divide(
			Decimal(freq), Decimal(total_words + vocabulary_size))
	
	print('\n\nTopicos processados: %d' % len(topics.keys()))
	print('Tamanho do vocabulario: %d' % vocabulary_size)
	
	return topics


###
# Funcao para fazer a consulta de um dado texto 
##
# model		=> 
# text		=> 
# k			=>
##
# 
##
# 
###

def query_naivebayes(model={}, text='', k=1):
	from decimal import Decimal, Context
	from math import log
	from re import sub as replace

	# cria contexto para o built-in Decimal
	context = Context()
	
	# processa texto para de ter apenas palavras significativas
	if type(text).__name__ == 'str':
		print('Processando texto, stemming, removendo stopwords ....\n\n')
		words = text_processing( replace(r'([^a-zA-Z ]+)', r'', text) )
	else:
		words = text

	# cria vetor de probabilidades 
	prob_topic = list()
	for topic in model.keys():
		
		#print("Calculando topico: %s" % topic)
		
		prob = context.ln(model[topic]['P_topic'])
		#print("ANTES %s" % words)
		for wk in words:
			#print("PROBLEMA %s %f %f" % (wk, model[topic]['P_wk'][wk], log(model[topic]['P_wk'][wk])))
			prob += context.ln( model[topic]['P_wk'][wk] )
		prob_topic.append( {topic: prob} )
	
	sorted_probs = sorted(prob_topic, key=lambda k: tuple(k.values())[0], 
							reverse=True)
	
	return sorted_probs[0:k]


import re
text = 'International Coffee Organization (ICO) exporters will modify their new proposal on quota resumption before presenting it to importers tomorrow, ICO delegates said. The change, which will be discussed tonight informally among producers, follows talks after the formal producer session with the eight-member producer splinter group and will affect the proposed quota distribution for 12 months from April one, they said. The proposed share-out would still include shortfall declarations, they said.'
#model = learn_naivebayes_text(all_reuters)

#probs = query_naivebayes(model, re.sub(r'([^a-zA-Z ]+)', r'', text))

text2 = "New Zealand's trading bank seasonally adjusted deposit growth rose 2.6 pct in January compared with a rise of 9.4 pct in December, the Reserve Bank said. Year-on-year total deposits rose 30.6 pct compared with a 26.3 pct increase in the December year and 34.5 pct rise a year ago period, it said in its weekly statistical release. Total deposits rose to 17.18 billion N.Z. Dlrs in January compared with 16.74 billion in December and 13.16 billion in January 1986."

"The Italian treasury said annual coupon rates payable March 1988 on two issues of long-term treasury certificates (CCTs) would be cut by about four percentage points compared with rates this March. Coupon rates on 10-year certificates maturing March 1995 	will fall to 9.80 pct from 13.65 pct and rates on 10-year 	issues maturing in March 1996 would fall to 10.05 pct from 14.30 pct. The Treasury also cut by 0.60 point six-monthly coupons payable this September on six issues maturing between September 1988 and September 1991. The issues carry terms of between five and seven years and will have coupon rates of between 4.85 and 5.65 pct in September compared with 5.45 and 6.25 pct this March."



text3 = "The International Coffee Organization (ICO ) council talks on reintroducing export quotas continued with an extended session lasting late into Sunday night, but delegates said prospects for an accord between producers and consumers were diminishing by the minute. The special meeting, called to stop the prolonged slide in coffee prices, was likely to adjourn sometime tonight without agreement, delegates said. The council is expected to agree to reconvene either within the next six weeks or in September, they said.  The talks foundered on Sunday afternoon when it became apparent consumers and producers could not compromise on the formula for calculating any future quota system, delegates said. Coffee export quotas were suspended a year ago when prices soared in response to a drought which cut Brazil's crop by nearly two-thirds. Brazil is the world's largest coffee producer and exporter."


##
# Funcao que valida um "modelo" de naive bayes.
# Como boa parte das noticias tem mais de um topico, i.e.,
# as classes estao intrelacadas, a abordagem para decidir se
# acertou, foi considerar dentre os "k" topicos com maior 
# probabilidade se algum esta presenta na lista de topicos 
# desejada entao houve um acerto na classificacao.


# Os 5 topicos com maior numero de textos associados estao 
# relacionados ah 77% dos textos.
# Como poucos topicos estao relacionados com muitos textos a 
# probabilidades deles sera muito maior, exemplor dois 
# topicos estao relacionados ah 56% das noticias. Alem disso
# muitas noticias tem varios topicos, e esses dois com 56% sao
# os que mais aparecem.
# Por essa natureza do problema adotou-se essa abordagem de 
# considerar os "K" com probabilidade maior e compara-los com
# os topicos esperados para a noticia em questao
# 
# Justamente pelo fato de uma mesma noticia ter varios topicos
# a probabilidade das palavras nele contida eh diluida. E como
# Ha dois topicos que aparecem numa quantidade muito maior que
# os demais a probabilidade do topico mais comum eh sempre a 
# maior. 
##
# model			=> "modelo" naive bayes, estrutura com as 
#					probabilidades calculadas 
# texts			=> texto processado, dicionario com duas 
#					chaves, uma para os textos e outra para 
#					os topicos do texto, ambas sao listas
# k				=> o numero de probabilidades a considerar na
#					resposta
##
# Retorna a procentagem de acertos
#
###

def validate_naivebayes(model, proc_texts={}, k=5):
	total_texts = len(proc_texts['texts'])
	
	from datetime import datetime as date
	print("Validando " + date.now().strftime('[%Y-%m-%d %H:%M:%S]')) 
	print("Tamanho do testset %d \n"% total_texts)

	acertos = 0
	for index in range(0, total_texts):
		text = proc_texts['texts'][index]
		probs = query_naivebayes(model, text, k)
		result = set([tuple(i.keys())[0] for i in probs]) & \
					set(proc_texts['text_to_topics'][index])

		print("Texto Atual %d"% index)
		
		# se a interseccao entre probs e os topicos desejados
		# tiver ao menos um elementos, entao acertou
		if len(result) > 0:
			acertos += 1
			print("\t\tACERTOU")
	
	return acertos / total_texts


###
#
#
##
# directory		=> Diretorio contendo os arquivos das noticias
# training_prop	=> Proporcao dos dados para treinamento
# min_text		=> Numero minimo de noticias um topico (classe)
#					deve ter para ser aceito como valido e nao
# 					ser descartado
##
#
#
###

def avalia_naivebayes(directory='./', texts={}, training_prop=0.7, 
						min_text=100):
	from os import listdir
	from random import sample

	print("Avaliando Naive Bayes\n")
	
	# processa textos
	print("Pre-processando textos\n")
	if len(texts) == 0 :
		file_name_list = [directory+i for i in listdir(directory)]
		proc_texts = prepare_reuters_data(file_name_list)
	else:
		proc_texts = texts
	
	# cortando textos com noticias raras
	valid_texts = set()
	valid_topics = []
	for tp,related_texts in proc_texts['topics'].items():
		# apenas noticias relacionadas a topicos com um numero
		# minimo de ocorrencia eh considerado valido

		# eventualmente topicos com poucas ocorrencias estarao
		# presentes
		if len(related_texts) >= min_text:
			valid_topics.append(tp)
			valid_texts = set.union(valid_texts, related_texts)
	
	#print("topicos %s"% valid_topics)
	#print("textos %s"% valid_textsIds)
	
	# particiona o dataset entre training-set e test-set
	print("Criando training-set e test-set dentre %d textos validos" 
			% len(valid_texts))

	return valid_texts

	train_ids = sample(range(0, len(valid_texts)), 
					round(len(valid_texts)*training_prop))
	

	test_ids = list(valid_texts - set(train_ids))
	



	return {'train':train_texts, 'teste': test_texts}

