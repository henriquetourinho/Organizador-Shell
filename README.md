# Organizador Shell

O **Organizador Shell** é um script avançado projetado para organizar arquivos em um diretório de origem, movendo-os para subdiretórios específicos de acordo com seus tipos de formato. O script oferece a flexibilidade de organizar os arquivos localmente ou transferi-los para um servidor remoto.

## Funcionalidades

- Organiza arquivos de tipos específicos em subdiretórios:
  - **Imagens**: jpg, jpeg, png, gif, bmp, svg, heic, webp
  - **Vídeos**: mp4, mkv, avi, mov, wmv, flv, webm
  - **Documentos**: pdf, doc, docx, xls, xlsx, ppt, pptx, txt
  - **Compactados**: zip, tar, gz, bz2, 7z
  - **Outros**: Arquivos que não se enquadram nas categorias acima.

- **Organização por Tipo**: O script organiza arquivos automaticamente de acordo com os seguintes tipos:
  - **Imagens**: Organize arquivos de imagens em formatos como `.jpg`, `.png`, etc., dentro de uma pasta dedicada.
  - **Vídeos**: Arquivos de vídeo, como `.mp4`, `.avi`, são movidos para o diretório `Vídeos`.
  - **Documentos**: Arquivos de texto, planilhas, apresentações, etc., são movidos para o diretório `Documentos`.
  - **Compactados**: Arquivos compactados como `.zip`, `.tar.gz`, etc., são movidos para o diretório `Compactados`.
  - **Outros**: Arquivos que não se encaixam nas categorias anteriores são movidos para o diretório `Outros`.

- Oferece duas opções de destino:
  - **Local**: Mover arquivos organizados para um diretório de destino local.
  - **Remoto**: Transferir arquivos organizados para um servidor remoto, usando SSH.

## Como Usar

### Opções de Linha de Comando

O script utiliza a seguinte sintaxe:

```bash
./organizador.sh [OPÇÕES]
```

### Opções

- `-d <diretório>`: Diretório de origem contendo os arquivos a serem organizados. **Obrigatório**.
- `-t <destino>`: Tipo de destino. Pode ser `local` (diretório local) ou `remoto` (servidor remoto). **Obrigatório**.
- `-l <diretório>`: Diretório local de destino (se `-t local`). **Obrigatório se -t for local**.
- `-r <ip>`: IP do servidor remoto (se `-t remoto`). **Obrigatório se -t for remoto**.
- `-u <usuário>`: Usuário de login no servidor remoto (se `-t remoto`). **Obrigatório se -t for remoto**.
- `-p <senha>`: Senha do servidor remoto (se `-t remoto`). **Obrigatório se -t for remoto**.
- `-k <token>`: Caminho para o arquivo de token SSH (opcional para acesso remoto com chave SSH).
- `-h`: Exibe a ajuda e opções disponíveis.

### Exemplos de Uso

#### Organização Local

Para organizar arquivos localmente, forneça o diretório de origem e destino:

```bash
./organizador.sh -d /caminho/para/origem -t local -l /caminho/para/destino
```

#### Organização Remota

Para transferir arquivos organizados para um servidor remoto, forneça as credenciais do servidor remoto:

```bash
./organizador.sh -d /caminho/para/origem -t remoto -r <ip_remoto> -u <usuario_remoto> -p <senha_remota>
```

Se for necessário usar um token SSH para autenticação, adicione a opção `-k`:

```bash
./organizador.sh -d /caminho/para/origem -t remoto -r <ip_remoto> -u <usuario_remoto> -p <senha_remota> -k /caminho/para/token_ssh
```

### Função de Organização de Arquivos

O script move os arquivos do diretório de origem para subdiretórios no destino, organizando-os por tipo:

1. **Imagens**: Todos os arquivos com extensões de imagem são movidos para o subdiretório `Imagens`.
2. **Vídeos**: Arquivos de vídeo são movidos para o subdiretório `Vídeos`.
3. **Documentos**: Arquivos de documentos (PDF, DOC, TXT, etc.) são movidos para o subdiretório `Documentos`.
4. **Compactados**: Arquivos compactados (ZIP, TAR, etc.) são movidos para o subdiretório `Compactados`.
5. **Outros**: Arquivos que não se encaixam em nenhuma das categorias são movidos para o subdiretório `Outros`.

### Validação de Entrada

O script valida se os parâmetros obrigatórios foram fornecidos. Caso contrário, ele exibe uma mensagem de erro e a ajuda do script.

### Transferência para Servidor Remoto

Se o tipo de destino for remoto, o script compacta os arquivos organizados e os transfere para o servidor remoto utilizando `scp`. Caso um token SSH seja fornecido, ele será usado para autenticação, caso contrário, a autenticação por senha será realizada.

## Requisitos

- **Linux/Unix-like**: O script foi desenvolvido para ambientes Unix, como Linux e macOS.
- **SCP/SSH**: A transferência para servidores remotos requer `scp` e o uso de autenticação SSH.

## Contribuição

Se você encontrar algum bug ou quiser sugerir melhorias, sinta-se à vontade para abrir uma **issue** ou enviar um **pull request**.
