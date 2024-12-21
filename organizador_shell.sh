#!/bin/bash

# Organizador Shell
# Um script avançado para organizar arquivos por tipo e opção de destino local ou remoto.

# Função de exibição de ajuda
function exibir_ajuda() {
    echo "Organizador Shell - Ajuda"
    echo "\nUso: $0 [OPÇÕES]"
    echo "\nOpções:"
    echo "  -d <diretório>      Diretório de origem para organização. (Obrigatório)"
    echo "  -t <destino>        Tipo de destino: 'local' ou 'remoto'. (Obrigatório)"
    echo "  -l <diretório>      Diretório local de destino. (Requerido se -t local)"
    echo "  -r <ip>             IP do servidor remoto. (Requerido se -t remoto)"
    echo "  -u <usuário>        Usuário de login no servidor remoto. (Requerido se -t remoto)"
    echo "  -p <senha>          Senha do servidor remoto. (Requerido se -t remoto)"
    echo "  -k <token>          Caminho para o arquivo de token SSH. (Opcional para remoto)"
    echo "  -h                  Exibe esta ajuda."
    echo "\nO script organiza os seguintes tipos de arquivos:"
    echo "  - Imagens: jpg, jpeg, png, gif, bmp, svg, heic, webp"
    echo "  - Vídeos: mp4, mkv, avi, mov, wmv, flv, webm"
    echo "  - Documentos: pdf, doc, docx, xls, xlsx, ppt, pptx, txt"
    echo "  - Compactados: zip, tar, gz, bz2, 7z"
    exit 0
}

# Função de organização de arquivos
function organizar_arquivos() {
    local origem=$1
    local destino=$2

    # Criar subdiretórios no destino
    mkdir -p "$destino/Imagens" "$destino/Vídeos" "$destino/Documentos" "$destino/Compactados" "$destino/Outros"

    # Organizar arquivos por tipo
    find "$origem" -type f \(
        -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o \
        -iname "*.gif" -o -iname "*.bmp" -o -iname "*.svg" -o \
        -iname "*.heic" -o -iname "*.webp" \) -exec mv {} "$destino/Imagens/" \;

    find "$origem" -type f \(
        -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.avi" -o \
        -iname "*.mov" -o -iname "*.wmv" -o -iname "*.flv" -o \
        -iname "*.webm" \) -exec mv {} "$destino/Vídeos/" \;

    find "$origem" -type f \(
        -iname "*.pdf" -o -iname "*.doc" -o -iname "*.docx" -o \
        -iname "*.xls" -o -iname "*.xlsx" -o -iname "*.ppt" -o \
        -iname "*.pptx" -o -iname "*.txt" \) -exec mv {} "$destino/Documentos/" \;

    find "$origem" -type f \(
        -iname "*.zip" -o -iname "*.tar" -o -iname "*.gz" -o \
        -iname "*.bz2" -o -iname "*.7z" \) -exec mv {} "$destino/Compactados/" \;

    # Mover outros arquivos para a pasta "Outros"
    find "$origem" -type f ! \(
        -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o \
        -iname "*.gif" -o -iname "*.bmp" -o -iname "*.svg" -o \
        -iname "*.heic" -o -iname "*.webp" -o -iname "*.mp4" -o \
        -iname "*.mkv" -o -iname "*.avi" -o -iname "*.mov" -o \
        -iname "*.wmv" -o -iname "*.flv" -o -iname "*.webm" -o \
        -iname "*.pdf" -o -iname "*.doc" -o -iname "*.docx" -o \
        -iname "*.xls" -o -iname "*.xlsx" -o -iname "*.ppt" -o \
        -iname "*.pptx" -o -iname "*.txt" -o -iname "*.zip" -o \
        -iname "*.tar" -o -iname "*.gz" -o -iname "*.bz2" -o \
        -iname "*.7z" \) -exec mv {} "$destino/Outros/" \;
}

# Processar argumentos de linha de comando
while getopts "d:t:l:r:u:p:k:h" opt; do
    case $opt in
        d) origem="$OPTARG" ;;
        t) tipo_destino="$OPTARG" ;;
        l) destino_local="$OPTARG" ;;
        r) ip_remoto="$OPTARG" ;;
        u) usuario_remoto="$OPTARG" ;;
        p) senha_remoto="$OPTARG" ;;
        k) token_remoto="$OPTARG" ;;
        h) exibir_ajuda ;;
        *) exibir_ajuda ;;
    esac
done

# Validar entrada
if [[ -z $origem || -z $tipo_destino ]]; then
    echo "Erro: Diretório de origem (-d) e tipo de destino (-t) são obrigatórios."
    exibir_ajuda
fi

# Destino local
if [[ $tipo_destino == "local" ]]; then
    if [[ -z $destino_local ]]; then
        echo "Erro: Diretório de destino local (-l) é obrigatório."
        exibir_ajuda
    fi
    organizar_arquivos "$origem" "$destino_local"

# Destino remoto
elif [[ $tipo_destino == "remoto" ]]; then
    if [[ -z $ip_remoto || -z $usuario_remoto || -z $senha_remoto ]]; then
        echo "Erro: IP (-r), usuário (-u) e senha (-p) são obrigatórios para destino remoto."
        exibir_ajuda
    fi

    # Criar destino remoto temporário
    tmp_dest=$(mktemp -d)
    organizar_arquivos "$origem" "$tmp_dest"

    # Compactar destino organizado
    arquivo_compactado="$tmp_dest/arquivos_organizados.tar.gz"
    tar -czf "$arquivo_compactado" -C "$tmp_dest" .

    # Transferir para o servidor remoto
    if [[ -n $token_remoto ]]; then
        scp -i "$token_remoto" "$arquivo_compactado" "$usuario_remoto@$ip_remoto:"
    else
        sshpass -p "$senha_remoto" scp "$arquivo_compactado" "$usuario_remoto@$ip_remoto:"
    fi

    echo "Arquivos organizados e transferidos para o servidor remoto com sucesso."
    rm -r "$tmp_dest"
else
    echo "Erro: Tipo de destino inválido. Use 'local' ou 'remoto'."
    exibir_ajuda
fi

exit 0

