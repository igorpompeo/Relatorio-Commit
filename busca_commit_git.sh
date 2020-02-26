#!/usr/bin/env bash
USER=IgorPompeoTavares

# Criação de variável com a regra do REGEX
re='^[0-9]{4}-[0-9]{2}-[0-9]{2}$'

echo "Informe a data inicial para a busca neste formato (YYYY-MM-DD): " # Data inicio precisa ser menor que a FIM
read DATA_INICIO # DATA_INICIO=$(date -d 'yesterday' '+%Y/%m/%d') 

# Loop de validação do dado informado no paramêtro de data
# Para validação com operador binary precisa ser usado '=~'

while ! [[ $DATA_INICIO =~ ${re}  ]]
do
    echo "Por favor insira a data incial corretamente (YYYY-MM-DD):"
    read DATA_INICIO
done

echo "Informe a data fim para a busca neste formato (YYYY-MM-DD). 
Obs: Lembrando que a data final precisa ser maior que a data inicial"
read DATA_FIM # DATA_FIM=$(date +'/%Y/%m/%d')

while ! [[ $DATA_INICIO =~ ${re}  ]]
do
    echo "Por favor insira a data final corretamente (YYYY-MM-DD):"
    read DATA_FIM
done

ARQUIVO_LOG="C:/Users/$USER/Desktop/git_log.log"

# Salva log em um arquivo
git log --pretty='format:%h' --after=$DATA_INICIO --before=$DATA_FIM > "C:/Users/$USER/Desktop/hash.log"

# Criando vetor com os hash que deseja validar
declare -a vetor_commit
declare -a vetor_arquivos
mapfile vetor_commit < C:/Users/$USER/Desktop/hash.log

# Criando um loop for para varrer o vetor
echo "COMEÇO"
echo "" > $ARQUIVO_LOG

function separator(){
    echo $1 >> $ARQUIVO_LOG
}

for i in "${vetor_commit[@]}"; do
# Comando que faz a busca no Git e traz os dados do responsável pelo commit
    echo "PROCESSANDO HASH: $i"
    separator "HASH: $i"

    separator "================================================================================="


    separator " ########### LOG ########### "

    git log --graph --pretty='format:%n Message: %B %n User:  %an %n Email: %ae %n Date: %ai %n ' -n 1 $i >> $ARQUIVO_LOG

    separator "########### ARQUIVOS ###########"

    git diff-tree --no-commit-id --name-only -r $i >> $ARQUIVO_LOG

    separator "____________________________________________________________________________________________"


done
echo "FIM"
