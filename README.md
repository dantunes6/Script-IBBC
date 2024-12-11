# Script de Tratamento de Dados - Bioinformática

## Workflow Implementado

O script realiza o seguinte fluxo de processamento:

1. **FastQC**: Qualidade inicial dos arquivos FASTQ.
2. **MultiQC**: Gera relatórios agregados dos resultados do FastQC.
3. **Fastp**: Realiza o trimming e filtragem dos arquivos FASTQ.
4. **FastQC (novamente)**: Qualidade dos arquivos após o trimming.
5. **MultiQC (novamente)**: Relatórios finais agregados.

---

## Requisitos

Antes de executar o script, assegure-se de ter instalado os seguintes softwares:

- [**FastQC**](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)
- [**MultiQC**](https://multiqc.info/)
- [**Fastp**](https://github.com/OpenGene/fastp)
- [**Conda**](https://docs.conda.io/en/latest/) para gerir ambientes.

> É necessário criar um ambiente **Conda** que contenha os programas acima instalados.


---

## Estrutura do Script

Ao executar, o script cria a seguinte estrutura de diretórios:

```
<NOME_BASE_DIR>/
|-- raw.data/               # Dados brutos (FASTQ)
|-- processed.data/
    |-- fastqc/             # Resultados do FastQC
    |-- trimmed/            # Arquivos processados pelo Fastp
    |-- multiqc/            # Relatórios MultiQC
|-- log.txt                 # Log do processamento
```

---

## Como Executar

1. Clone o repositório:
   ```bash
   git clone <URL_DO_REPOSITORIO>
   cd <NOME_DO_REPOSITORIO>
   ```

2. Torne o script executável:
   ```bash
   chmod +x Script64337.sh
   ```

3. Execute o script:
   ```bash
   ./Script64337.sh
   ```

4. Durante a execução:
   - Insira o **nome da diretoria** onde o script irá criar os arquivos (sem espaços).
   - Informe o **ambiente Conda** contendo os programas.
   - Escolha entre parâmetros padrão ou personalizados para o **Fastp**.

---

## Parâmetros Default do Fastp

Caso escolha usar os valores padrão, os seguintes parâmetros serão utilizados:

- `--trim_front1 3`
- `--trim_tail1 3`
- `--max_len1 150`
- `--qualified_quality_phred 20`
- `--cut_window_size 4`
- `--cut_mean_quality 20`
- `--detect_adapter_for_pe`

---

## Arquivos Necessários

O script espera a existência de dois arquivos/diretórios principais:

1. **samples.txt**: Arquivo contendo os nomes dos arquivos FASTQ e tratamentos.
   - Caminho padrão: `/home/fc64337/IBBC/Exame/samples.txt`
   - Formato:
     ```
     Sample<TAB>Treatment<TAB>FILENAME
     ```
   - Este path pode ser alterado pelo user!

2. **Diretório com arquivos FASTQ**: Local dos arquivos brutos.
   - Caminho padrão: `/home/fc64337/IBBC/Exame/`
   - Este path também pode ser alterado pelo user!

---

## Outputs Geradoss

- **FastQC**: Relatórios individuais de qualidade para cada arquivo.
- **MultiQC**: Relatórios agregados para visualização geral dos resultados.
- **Fastp**: Arquivos FASTQ trimados e relatórios em formato **HTML** e **JSON**.
- **log.txt**: Log contendo todas as operações realizadas durante o processamento.

---

## Exemplo de Uso

```bash
./Script64337.sh
```

- Ao ser solicitado, insira:
   - Nome da diretoria base (ex: `bioinfo_results`)
   - Nome do ambiente Conda (ex: `bioinfo_env`)

---

## Autor

**Diogo Antunes**  
Desenvolvido para a Unidade Curricular: **Introdução à Bioinformática e Biologia Computacional**.
