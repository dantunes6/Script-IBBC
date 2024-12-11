# Script-IBBC
Este script automatiza o tratamento e análise de ficheiros FASTQ utilizados em bioinformática, organizando um workflow eficiente com as ferramentas FastQC, MultiQC e Fastp.

O objetivo deste script é realizar um workflow completo de análise de dados biológicos em formato FASTQ. Este pipeline inclui as seguintes etapas:

1. Criação de uma estrutura de diretórias organizada para armazenar os ficheiros de entrada, resultados processados e logs.
2. Cópia e organização dos ficheiros FASTQ que serão processados, a partir de um ficheiro de amostras.
3. Execução de análises FastQC iniciais para avaliar a qualidade dos ficheiros brutos.
4. Relatório MultiQC consolidando os resultados do FastQC inicial.
5. Pré-processamento com Fastp, que inclui trimming de adaptadores e correção de qualidade, permitindo a escolha entre parâmetros padrão ou personalizados.
6. Execução de análises FastQC pós-processamento para avaliar os ficheiros resultantes do Fastp.
7. Relatório MultiQC final consolidando os resultados pós-tratamento.
8. Registo completo de todas as operações realizadas em um ficheiro de log.

Este script automatiza o tratamento e análise de ficheiros FASTQ, amplamente utilizados em bioinformática, através de um workflow integrado com as ferramentas FastQC, MultiQC e Fastp. Inicialmente, o script solicita ao utilizador o nome de uma diretoria base válida, cria a estrutura necessária para armazenar os ficheiros (como "raw.data" para os dados brutos e "processed.data" para os resultados processados), e copia os ficheiros FASTQ listados em "samples.txt" para a diretoria de entrada. A ativação do ambiente Conda é necessária para garantir o funcionamento das ferramentas.

Na primeira fase da análise, o FastQC é executado para avaliar a qualidade dos ficheiros brutos, e um relatório consolidado é gerado com o MultiQC. De seguida, o script realiza o pré-processamento dos ficheiros com Fastp. Aqui, o utilizador tem a flexibilidade de escolher entre dois modos para os parâmetros de processamento:
1- Parâmetros padrão: Neste caso, o script utiliza valores predefinidos, como trimming automático dos primeiros e últimos nucleótidos, qualidade mínima, tamanho máximo das leituras, entre outros. Esta opção é recomendada para utilizadores que desejam uma execução rápida e confiável sem necessidade de ajustes manuais.
2- Parâmetros personalizados: Ao escolher esta opção, o utilizador pode inserir manualmente os valores para cada parâmetro, como --trim_front1, --trim_tail1, --max_len1 e --qualified_quality_phred. Esta flexibilidade permite adaptar o Fastp às necessidades específicas do conjunto de dados, garantindo um controlo mais preciso sobre o processo de pré-processamento. 
Aqui também é detetado automaticamente se as amostras fornecidas são pair-end e single-end, sem necessidade de interação com o utilizador.

No fim desta etapa, os ficheiros processados são armazenados em "processed.data/trimmed", gerando relatórios HTML e JSON individuais.

Na etapa final, o FastQC é novamente executado para reavaliar a qualidade dos ficheiros tratados, seguido por um segundo relatório consolidado com MultiQC, permitindo comparar os resultados antes e depois do tratamento. Todas as etapas são documentadas em um ficheiro log, garantindo rastreabilidade. O script organiza os dados e resultados de forma estruturada, automatiza tarefas repetitivas e oferece flexibilidade na configuração dos parâmetros, proporcionando um workflow eficiente, reprodutível e fácil de interpretar.

!!!Para o utilizador!!! 
O ficheiro samples.txt tem de ter o seguinte formato.
1ª coluna-nome da amostra
2ª coluna-Tratamento (ou qualquer categoria de agrupamento)
3ª coluna-Nome do ficheiro FASTQ

Sample1    TratamentoA    sample1_1_aaa.fastq.gz
Sample1    TratamentoA    sample1_2_aaa.fastq.gz
Sample2    TratamentoB    sample2_1_aaa.fastq.gz
Sample2    TratamentoB    sample2_2_aaa.fastq.gz
Sample3    TratamentoC    sample3.fastq.gz

Certifique-se de que o samples.txt esteja localizado na pasta apropriada (diretoria de origem especificada no script).
O script irá ler linha a linha, copiar os ficheiros para a pasta raw.data e proceder com a análise.






