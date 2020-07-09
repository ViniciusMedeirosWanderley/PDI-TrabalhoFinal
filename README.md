# Robust Door Detector

[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/viniciusmwanderley/robust-door-detector/master/LICENSE)

Realização do estudo sobre um detector de portas robusto implementado no Matlab.

##  1. Introdução ##

Com o avanço na capacidade de processamento dos dispositivos disponíveis para usuários-final, é notável e cada vez maior a presença de tecnologias que ajudem deficientes a vencer os obstáculos diários. Nas mais diversas variações de tecnologia assistiva, uma chama atenção pela abrangência que pode vir a tomar: o uso de visão computacional para auxiliar deficientes visuais.

Como atividade final da disciplina de Processamento Digital de Imagens (PDI) escolhemos o projeto sobre detecção robusta de portas. Para tanto foi pensado um sistema completo para rodar em aparelhos móveis que forneçam processamento para detecção de portas, escadas, carros, sinalização urbana, amigos próximos e afins. Para tanto, decidiu-se que o foco deste trabalho seria apenas uma porção deste sistema maior, a parte de detecção de portas.

O método, implementado no MATLAB, feito para extrair a localização de portas em um conjunto de imagens estáticas aleatórias, se baseia em um algoritmo de detecção de bordas Canny, na transformada de Hough e em lógica difusa para determinar a probabilidade de existência das portas que são compatíveis com um conjunto de regras predefinidas.


### 1.1. Objetivo ###

Apresentar e explicar um detector de portas robusto em imagens estáticas, com fins de complemento de nota para a disciplina de Introdução ao Processamento Digital de Imagens.


## 2. Fundamentação Teórica ##

A fim de poder escolher uma metologia sólida a se trabalhar e ter um norte no que tange à feitura e cumprimento dos objetivos, se faz necessária breve fundamentação teórica sobre:

* Filtro de Sobel;
* Transformada de Hough
* Lógica Fuzzy
* Filtro de Canny
* Operação de Erosão Morfológica
* Método de Otsu

Que são esmiuçados à seguir.

### 2.1. Filtro de Sobel ###

O filtro Sobel é uma operação utilizada em processamento de imagem, aplicada sobretudo em algoritmos de detecção de contornos. Em termos técnicos, consiste num operador que calcula diferenças finitas, dando uma aproximação do gradiente da intensidade dos pixels da imagem.


### 2.2. Transformada de Hough ###

A Transformada de Hough é um método padrão para detecção de formas que são facilmente parametrizadas (linhas, círculos, elipses, etc.) em imagens digitalizadas. A idéia é aplicar na imagem uma transformação tal que todos os pontos pertencentes a uma mesma curva sejam mapeados num único ponto de um novo espaço de parametrização da curva procurada.


### 2.3. Lógica Fuzzy ###

Diferente da Lógica Booleana que admite apenas valores booleanos, ou seja, verdadeiro ou falso, a lógica difusa ou fuzzy, trata de valores que variam entre 0 e 1. Assim, uma pertinência de 0.5 pode representar meio verdade, logo 0.9 e 0.1, representam quase verdade e quase falso, respectivamente.


### 2.4. Filtro de Canny ###

O filtro de Canny é um filtro de convolução que usa a primeira derivada. Ele suaviza o ruído e localiza bordas, combinando um operador diferencial com um filtro Gaussiano. A idéia desse filtro para detecção de bordas é usar G’(x). Fazendo a operação de convolução da imagem com G’(x) obtém-se uma imagem I, que mostrará as bordas, mesmo na presença de ruído.


### 2.5. Operação de erosão morfológica ###

Filtros morfológicos exploram as propriedades geométricas dos sinais (níveis de cinzada imagem). Para filtros morfológicos, as máscaras são denominadas elementos estruturantes e apresentam valores 0 ou 1 na matriz que correspondem ao pixel considerado. Os
filtros morfológicos básicos são o filtro da mediana, erosão e dilatação.

Filtro morfológico de erosão: provoca efeitos de erosão das partes claras da imagem (altos níveis de cinza), gerando imagens mais escuras. Considerando o exemplo anterior,o valor a ser substituído no pixel central corresponde ao menor valor da ordenação, 2.

### 2.6. Método de Otsu ###

Técnica que determina um limiar ótimo considerando uma imagem I, que apresenta melhor funcionamento em imagens cujos histogramas são bimodais. A ideia é aproximar o histograma de uma imagem por duas funções Gaussianas e escolher o limiar de forma a minimizar a variância intra-classes. Cada classe possui suas próprias características, ou seja, sua média e desvio-padrão

## 3. Materiais e Métodos ###

### 3.1. Materiais ###

Em termos de materiais utilizados, apenas softwares foram necessários, tal como consta nesta lista:

* Matlab 2016
* Código-fonte disponível em [4]

### 3.2. Métodos ###

Inicialmente, foi feito um diagrama que mostra o funcionamento do programa em alto-nível.

![alt text](/imgs/diagrama.jpg)

#### 3.2.1. Pré-processamento de regiões de interesse ####

O programa inicia recebendo as imagens que serão utilizadas para o reconhecimento de uma porta, cada imagem é levada para uma função de pré-processamento onde as imagens passam por uma limiarização e por um filtro de detecção de bordas (filtro de sobel).

Depois de ter as bordas identificadas, o programa utiliza um método para encontrar os cantos (onde linhas verticais e horizontais se cruzam), porém, os cantos contidos na imagem podem não ser os da porta, então o pré-processamento apenas leva em conta que os cantos das portas estão próximos da interseção de linhas horizontais e verticais fortes, ignorando algumas variações de graus e rotações.

A imagem é convertida para níveis de cinza e é realizada uma dilatação com o intuito de melhorar as conexões dos cantos; é executada uma verificação de região em que cada linha detectada recebe uma ponderação de acordo com seu tamanho. Os cantos são
determinados pela multiplicação dos quadrados das imagens dos segmentos horizontal e vertical.

![alt text](/imgs/dectCantos.jpg)
![alt text](/imgs/cantos.jpg)

Após a detecção de cantos, conjuntos de 4 pontos que geram quadriláteros são usados para definir uma região em que possivelmente seria uma porta, com esses pontos é feito uma análise sobre os ângulos internos do quadriláteros, eles devem está dentro de um
limite de tolerância comparável com os ângulos de uma porta vista com uma câmera levemente girada; além dos ângulos, é observado se as dimensões de largura e altura são aceitáveis. Depois disso, os quadriláteros são avaliados em relação à sua área sua forma, dando ênfase em formatos retangulares e/ou paralelogramos. Os quadriláteros selecionados com base na área são mesclados em um ou mais quadriláteros de extensão máxima.

Os quadriláteros selecionados com base na forma são avaliados para a conexão geral na imagem da aresta. Cada região quadrilateral remanescente é convertida em uma região retangular, e cada região é cortada da imagem original, preenchida e enviada ao
algoritmo de extração de linha e recurso. Se a região selecionada for pequena, a imagem será ampliada antes de ser enviada.

![alt text](/imgs/uniaoQuad .jpg)

O pré-processamento, portanto, deixa o algoritmo de detecção de portas com maior robustez e pode acelerar o processo de detecção.

#### 3.2.2. Linha de porta e extração de características ####

Após o pré-processamento, a imagem está em tons de cinza e com as linhas dominantes da porta, estas linhas são colocadas em um banco de dados de linhas.

Para extrair dados do banco de dados, primeiramente a imagem é convertida em um mapa de bordas obtido através do filtro de Canny. A imagem a seguir é o output do detector de bordas Canny.

![alt text](/imgs/sobel.jpg)

Uma operação de erosão morfológica de 3x1 elementos estruturantes foi aplicada para detecção de bordas horizontais e verticais.

![alt text](/imgs/sobelHorizontal.jpg)
![alt text](/imgs/sobelVertical.jpg)

Em seguida, as linhas horizontais e verticais, de cada imagem, são analisadas e apenas as que têm tamanho considerável é deixada, as outras são eliminadas. Uma transformada Hough é aplicada em cada linha horizontal e vertical, e as informações referentes aos seus ângulos e localizações são armazenadas no banco de dados. Portanto,“a última linha do banco de dados consiste em linhas horizontais e verticais que atendem  um critério de comprimento e um critério de ângulo”.

Faz-se a aplicação do método de Otsu à imagem que é passada pelo pré-processamento, então cada nível do Otsu é transformado em uma imagem binária, onde todos os níveis abaixo o nível atual é levado para 0 e todos os níveis maiores ou iguais ao nível atual é levado para 1. Cada uma dessas imagens binárias são analisadas para encontrar características que tenham tamanhos proporcionais aos de uma maçaneta ou de dobradiças. As informações das dobradiças e maçanetas são armazenadas em bancos de dados diferentes, portanto, o projeto conta com três bancos de dados, um das linhas, um das maçanetas, um das dobradiça. A imagem a seguir mostra a sobreposição dos três bancos de dados.

![alt text](/imgs/sobelVertical.jpg)

Após todo esse processo, a imagem da sobreposição é passada para um algoritmo utilizando lógica difusa para concluir o processo de detecção de portas.

#### 3.2.3. Lógica Fuzzy para extração de portas

Linhas  são retiradas do banco de dados para serem enfim testadas, as linhas paralelas são usadas para encontrar os quatro cantos da porta. O método de detecção emprega 3 tipos de métricas para determinar a probabilidade da linha fazer parte ou não da porta. 

A primeira métrica é voltada para os pares de linhas verticais, o segundo para a linha horizontal superior e o terceiro para a linha horizontal inferior. Quanto maior os valores das métricas maior é o nível de confiabilidade de que a combinação de linhas
constitui uma porta. O primeiro passo inicia-se calculando o comprimento médio dos pares de linha vertical, se a distância entre as linhas é maior que 1/3, e menor que 2/3 do comprimento médio o par é considerado pouco confiável. A diferença entre as duas linhas verticais são subtraídas da métrica, se a distância dentre elas multiplicada por 2, for próximo ao comprimento do par de linhas, a métrica é aumentada. Pares com métrica menor que 50% da maior métrica são desconsideradas. 

O segundo passo começa levando em consideração os resultados do primeiro, as linhas horizontais são pontuadas de acordo com as linhas verticais restantes. A média superior e inferior da coordenada Y das linhas verticais são calculadas, cada linha horizontal tem a métrica calculada com base em quão perto estão da média de Y das linhas verticais, as linhas horizontais que não tem o tamanho da distância entre as duas linhas verticais recebem uma métrica menor, após as linhas verticais e horizontais terem suas métricas calculadas, as melhores são passadas para o terceiro passo. 

A seção de detecção de recursos é a terceira e última fase da detecção de portas, nessa fase procura-se itens na porta que possam aumentar a confiabilidade de que aquelas retas realmente formam uma porta. O código do recurso de porta funciona do seguinte modo. Uma maçaneta de porta próxima a uma das linhas verticais no segundo quadrante, a partir da parte inferior da porta, acrescenta metade da diferença entre a pontuação da linha vertical e as pontuações da linha horizontal superior e inferior, independentemente. Dobradiças perto de cada linha vertical adicionam um sexto à diferença entre a linha vertical e horizontal superior e inferior pontuações de linha independentemente. Esses recursos ajudam muito na detecção de portas fechadas. 

Os valores da métrica dos recursos são então somados com as métricas da porta vertical e horizontal para criar a métrica final de confiança, após as 3 fases então chegamos ao final onde é definido se as métricas foram uma porta e quantas portas existem na imagem. A métrica combinada com melhor classificação é o indicativo de que existe uma porta, se suas métricas horizontais forem pelo menos 1/4 da métrica de linha vertical. Se os primeiros candidatos tiverem métricas próximas e suas áreas não se sobrepõem, isso indica que há várias portas na imagem.

## 4. Resultados e Discursão


O código foi testado contra vários tipos de portas, em cenas diferentes e em diferentes ângulos de câmera.

Fizemos mais testes em diversas situações para entender na prática como funcionava o programa:

![alt text](/imgs/porta3.jpg)
![alt text](/imgs/porta3imgFinal.jpg)
porta3imgmFinal.jpg
![alt text](/imgs/porta2.jpg)
![alt text](/imgs/porta2imgFinal.jpg)

A taxa de detecção das portas pelo algoritmo é de 80% para um conjunto de entrada com 196 portas distribuídas entre 30 imagens randômicas. O tempo médio de decisão é de 7 segundos para dimensões com 750 x 550 pixels.


## 5. Conclusão ##

Ao concluir[2] o estudo sobre o projeto em questão, pudemos perceber como os filtros aprendidos no curso de Processamento Digital de Imagens podem ser úteis para aplicações reais como esta, que têm impacto sobre certa parcela da sociedade. Além disso pudemos
aprender filtros morfológicos, transformada de Hough, lógica fuzzy e filtro de Canny, de modo que tivemos um primeiro contato com conceitos que vão além do que nos foi dado em sala, ampliando nossa aprendizagem.

## 6. Referências ##

[1] Gonzales, Rafael C.; Woods, Richard E., Processamento Digital de Imagens, 3a Ed., Pearson Prentice Hall, 2010.

[2] Vidal, Leonardo, Aula 1, UFPB, notas de aula, 2018.

[3] MathWorks, Documentation, MatLab Documentation, Disponível em: <https://www.mathworks.com/help/matlab/index.html>, Acesso em 3 de novembro de 2018.

[4] Anônimo, Robust Door Detection matlab project source code, StudentStrap Blog, Disponível em: <https://studentstrapz.blogspot.com/2018/07/robust-door-detection-matlab-project.html>, Acesso em 3 de novembro de


[5] Contribuidores da Wikipédia, Filtro Sobel, Wikipédia, a enciclopédia livre, Disponível em: <https://pt.wikipedia.org/w/index.php?title=Filtro_Sobel&oldid=35047926>, Acesso em 3 de novembro de 2018.

[6] Pivetta, Cleber; Mantovani, Gustavo; Zottis, Felipe, Transformada de Hough,
Unioeste, notas de aula, Disponível em: <http://www.inf.unioeste.br/~adair/PID/Notas%20Aula/Transformada%20de%20Hough.pdf>, Acesso em 3 de novembro
de 2018.

[7] Rignel, Diego; Chenci, Gabriel; Lucas, Carlos, Uma Introdução a Lógica Fuzzy, UniFACEF, RESIGeT, vol. 1, no 1, 2011, Disponível em:
<http://www.logicafuzzy.com.br/wp-content/uploads/2013/04/uma_introducao_a_logica_fuzzy.pdf>, Acesso em 3 de novembro de 2018.

[8] Conci, Aura, Canny: Detecção de Borda, UFF, notas de aula, Disponível
em: <http://www2.ic.uff.br/~aconci/canny.pdf>, Acesso em 3 de novembro de


[9] Pesquisadores do INPE, Teoria: Processamento de Imagens, INPE, Divisão de
Processamento de Imagens, Material de Apoio, Disponível em: <http://www.dpi.inpe.br/spring/teoria/filtrage/filtragem.htm>, Acesso em 3 de novembro de


[10] Gazziro, Mario; Ruela, Vinicius, Quadro Segmentação de Imagens, USP,
ICMC São Carlos, Disponível em: <http://wiki.icmc.usp.br/images/b/bb/Otsu_e_derivadas.pdf>, Acesso em 3 de novembro de 2018.
