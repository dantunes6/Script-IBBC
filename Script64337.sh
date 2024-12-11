
clear

echo "Iniciando o Script de tratamentos de dados."
sleep 2
echo ""
echo "***Script feito por Diogo Antunes para U.C. de Introdução à Bioinformática e Biologia Computacional.***"
echo ""
echo ""
echo "Workflow: FastQC --> MutiQC --> Fastp --> FastQC --> MultiQC"
sleep 1.5
echo ""
echo ""
echo ""

echo "!!Atenção!! Por favor, insira o nome da diretoria onde o Script vai funcionar seguindo estas regras:"
sleep 1
echo "1. O nome não pode estar vazio."
sleep 0.5
echo "2. O nome não pode conter espaços."
sleep 0.5
echo "3. O nome não pode ser igual a uma diretoria já existente."
sleep 0.5
echo

# Pergunta ao utilizador o nome da Diretoria para criar a estrutura de diretorias do Script
while true; do
    read -p "Insira o nome da diretoria base do script: " NAME_BASE_DIR

    # Verificar se o nome é vazio
    if [[ -z "$NAME_BASE_DIR" ]]; then
        echo "O nome da diretoria não pode ser vazio, tente novamente."

    # Verificar se o nome contém espaços
    elif [[ "$NAME_BASE_DIR" =~ \  ]]; then
        echo "O nome da diretoria não pode conter espaços, tente novamente."

    # Verificar se a diretoria já existe
    elif [[ -d "$NAME_BASE_DIR" ]]; then
        echo "Já existe uma diretoria com este nome, tente outro."
    else
        break
    fi
done

# Estrutura principal do script
BASE_DIR="$HOME/$NAME_BASE_DIR"
INPUT="$BASE_DIR/raw.data"
OUTPUT="$BASE_DIR/processed.data"
LOG="$BASE_DIR/log.txt" # Cria apenas um ficheiro para registar o que acontece no Script

DIRS=("raw.data" "processed.data/fastqc" "processed.data/trimmed" "processed.data/multiqc")


echo "A criar a estrutura do script..."
for DIR in "${DIRS[@]}"; do
    mkdir -p "$BASE_DIR/$DIR"
    echo "Diretoria criada: $BASE_DIR/$DIR" | tee -a "$LOG"
    sleep 1
done

# Copia os ficheiros registados em samples.txt para a diretoria de INPUT
SAMPLES_FILE="/home/fc64337/IBBC/Exame/samples.txt" #ALTERAVLE PELO USER
SOURCE_DIR="/home/fc64337/IBBC/Exame" #ALTERAVEL PELO USER

while IFS=$'\t' read -r Sample Treatment FILENAME; do
    FILE_PATH="$SOURCE_DIR/${FILENAME}"

    if [[ -f "$FILE_PATH" ]]; then
        echo "Copiando $FILE_PATH para $INPUT..." | tee -a "$LOG"
        cp "$FILE_PATH" "$INPUT"
    fi
done < "$SAMPLES_FILE"

# Ativar ambiente Conda
source /home/fc64337/miniconda3/etc/profile.d/conda.sh
echo ""
echo "Vai ser necessário ativar um ambiente Conda (!!!com fastqc, multiqc e fastp instalado!!!) para poder prosseguir o processo de tratamento de dados."
sleep 1.5
echo ""
while true; do
    read -p "Insira o nome do ambiente Conda que deseja ativar: " ENV

    if [[ -z "$ENV" ]]; then
        echo "O nome do ambiente não pode ser vazio, tente novamente."
    elif ! conda env list | grep -q "^$ENV "; then
        echo "O ambiente '$ENV' não existe, tente novamente."
    else
        echo "Ativando o ambiente '$ENV'..."
        conda activate "$ENV"
        sleep 0.5
        echo "Ambiente Conda ativado com sucesso!"
        break
    fi
done

# Inicia o ficheiro log com a data e hora
echo ""
echo ""
echo "Script iniciado a: $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG"

# FastQC
echo "Gerando relatórios FastQC para os ficheiros selecionados..."
for FILE in "$INPUT"/*.fastq*; do
    if [[ -f "$FILE" ]]; then
        echo "Processando $FILE..." | tee -a "$LOG"
        fastqc -o "$BASE_DIR/processed.data/fastqc" "$FILE" | tee -a "$LOG"
    fi
done

# Inicia o ficheiro log com a data e hora
echo ""
echo ""
echo "Script iniciado a: $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG"

# FastQC
echo "Gerando relatórios FastQC para os ficheiros selecionados..."
for FILE in "$INPUT"/*.fastq*; do
    if [[ -f "$FILE" ]]; then
        echo "Processando $FILE..." | tee -a "$LOG"
        fastqc -o "$BASE_DIR/processed.data/fastqc" "$FILE" | tee -a "$LOG"
    fi
done
echo "Relatórios concluídos. Consulte em: $BASE_DIR/processed.data/fastqc"
echo ""
echo ""
# MultiQC
echo "Gerando relatório MultiQC para os ficheiros selecionados..." | tee -a "$LOG"
multiqc "$BASE_DIR/processed.data/fastqc" -o "$BASE_DIR/processed.data/multiqc" | tee -a "$LOG"
echo "Relatório concluído. Consulte em: $BASE_DIR/processed.data/multiqc"

echo ""
echo ""
echo "###  Fastp  ###"
echo ""

# Escolha de Parâmetros FastP
echo "Pode usar os valores padrão ou inserir manualmente os valores dos prâmetros para o FastP:"
echo "1. Usar valores padrão:"
echo "   --trim_front1 --> 3"
echo "   --trim_tail1 --> 3"
echo "   --max_len1 --> 150"
echo "   --qualified_quality_phred --> 20"
echo "   --cut_window_size --> 4"
echo "   --cut_mean_quality --> 20"
echo "   --detect_adapter_for_pe"
echo ""
echo "2. Inserir parâmetros personalizados"
echo ""
sleep 2
read -p "Escolha (1=valores padrão, 2=inserir manualmente): " TRIM_CHOICE

# Configuração dos parâmetros
if [[ "$TRIM_CHOICE" == "2" ]]; then
    read -p "Insira os parâmetros do FastP como uma string completa: " FASTP_ARGS
else
    FASTP_ARGS="--trim_front1 3 --trim_tail1 3 --max_len1 150 --qualified_quality_phred 20 --cut_window_size 4 --cut_mean_quality 20 --detect_adapter_for_pe"
fi

for FILE in "$INPUT"/*_1_aaa.fastq.gz; do
    BASENAME=$(basename "$FILE" _1_aaa.fastq.gz)

    FORWARD="$INPUT/${BASENAME}_1_aaa.fastq.gz"
    REVERSE="$INPUT/${BASENAME}_2_aaa.fastq.gz"
    OUTPUT_FORWARD="$OUTPUT/trimmed/${BASENAME}_trimmed_1.fastq.gz"
    OUTPUT_REVERSE="$OUTPUT/trimmed/${BASENAME}_trimmed_2.fastq.gz"

    # Verificar se os ficheiros são paired-end
    if [[ -f "$FORWARD" && -f "$REVERSE" ]]; then
        echo "Detetado como paired-end para $BASENAME" | tee -a "$LOG"
        fastp --in1 "$FORWARD" --in2 "$REVERSE" \
              --out1 "$OUTPUT_FORWARD" --out2 "$OUTPUT_REVERSE" \
              $FASTP_ARGS \
              --html "$OUTPUT/trimmed/${BASENAME}_fastp.html" \
              --json "$OUTPUT/trimmed/${BASENAME}_fastp.json" &>> "$LOG"
    elif [[ -f "$FORWARD" && ! -f "$REVERSE" ]]; then
        # Caso de single-end
        echo "Detetado como single-end para $BASENAME" | tee -a "$LOG"
        fastp --in1 "$FORWARD" \
              --out1 "$OUTPUT_FORWARD" \
              $FASTP_ARGS \
              --html "$OUTPUT/trimmed/${BASENAME}_fastp.html" \
              --json "$OUTPUT/trimmed/${BASENAME}_fastp.json" &>> "$LOG"
    else

        echo "Erro: falta algum ficheiro para $BASENAME" | tee -a "$LOG"
    fi
done

echo""
echo "Processo de trimming concluído. Consulte em: $BASE_DIR/processed.data/trimmed"

#Relatórios fastqc para os ficheiros processados
echo ""
echo ""
echo "Executando FastQC para os arquivos processados anteriormente..."
for FILE in "$OUTPUT/trimmed"/*_trimmed_*.fastq.gz; do
    if [[ -f "$FILE" ]]; then
        echo "Processando $FILE..." | tee -a "$LOG"
        fastqc -o "$BASE_DIR/processed.data/fastqc" "$FILE" | tee -a "$LOG"
    fi
done
echo ""
echo "Relatórios FastQC para os ficheiros trimados concluídos. Consulte em: $BASE_DIR/processed.data/fastqc"
echo ""
echo ""
# Relatório MultiQC para os ficheiros processados com FastQC
echo "Gerando relatório MultiQC para os ficheiros processados..." | tee -a "$LOG"
multiqc "$BASE_DIR/processed.data/fastqc" -o "$BASE_DIR/processed.data/multiqc" | tee -a "$LOG"
echo ""
echo "Relatório MultiQC concluído. Consulte em: $BASE_DIR/processed.data/multiqc"


echo "Script concluído! Consulte os resultados nas pastas de 'fastqc' e 'multiqc'dentro da diretoria $NAME_BASE_DIR."
echo "Consulte todos os detalhes do tratamento dos seus ficheiros em 'logs.txt' na diretoria $NAME_BASE_DIR"
echo "O script foi concluído com sucesso em: $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG"
