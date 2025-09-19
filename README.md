NASA-APOD - App de Fotos Espaciais
Technical Test for Skopia Digital

Como Rodar o Projeto
Siga os passos abaixo para compilar e rodar o projeto localmente.

1. Clonar o Repositório
Primeiro, clone o repositório para a sua máquina local usando o Terminal:
Bash
git clone https://github.com/faefelipe/NASA-APOD.git
cd NASA-APOD

2. Obter uma Chave da API da NASA
Este aplicativo requer uma chave de API da NASA para funcionar.
Acesse o site oficial: https://api.nasa.gov/

Preencha o formulário para gerar sua chave de API gratuita. Ela geralmente é enviada para o seu e-mail.

3. Configurar a Chave de API (Passo Essencial)
Para manter a chave de API segura e fora do controle de versão, o projeto utiliza um arquivo .xcconfig.

Na pasta raiz do projeto (no mesmo nível do arquivo .xcodeproj), crie um novo arquivo de texto chamado Keys.xcconfig.

Abra este novo arquivo e adicione a seguinte linha, substituindo SUA_CHAVE_AQUI pela chave que você recebeu da NASA:

NASA_API_KEY = SUA_CHAVE_AQUI
O projeto já está configurado para ler a chave deste arquivo. O nome Keys.xcconfig já está no .gitignore para garantir que sua chave nunca seja enviada para o repositório.

4. Abrir no Xcode e Compilar
Abra o arquivo .xcodeproj no Xcode.
O Swift Package Manager irá baixar e configurar automaticamente a dependência (Kingfisher) na primeira vez que você abrir o projeto.
Selecione um simulador de iPhone ou um dispositivo físico.
Pressione Run (ou o atalho Cmd+R) para compilar e executar o aplicativo.

Organização e Legibilidade do Código
O projeto segue uma estrutura de pastas clara baseada na arquitetura (MVVM-C) e utiliza nomes descritivos para facilitar a leitura e manutenção do código.

Arquitetura e Boas Práticas
Foi utilizada a arquitetura MVVM-C para garantir a máxima separação de responsabilidades:

Model: Estruturas de dados simples que representam a API.
View: Componentes de UI passivos e reutilizáveis.
ViewModel: Lógica de apresentação e gerenciamento de estado.
Coordinator: Controle centralizado de todo o fluxo de navegação.
Service & Persistence: Camadas isoladas para rede e armazenamento local.

Tratamento de Erros
Erros de rede são tratados de forma segura, exibindo uma mensagem amigável ao usuário com um botão de "Tentar Novamente" para permitir a recuperação da falha.

Experiência do Usuário (UX)
A interface possui um tema consistente inspirado na NASA, com suporte a Light & Dark Mode. O fluxo de navegação é intuitivo e o app fornece feedback claro ao usuário através de indicadores de carregamento e telas de erro.

Testes Unitários
Foram implementados testes unitários para a ViewModel e para a camada de Persistência. Um serviço de rede mock (MockAPIService) é utilizado para garantir que os testes da ViewModel sejam rápidos e independentes da internet.

Funcionalidades e Refinamentos
O projeto inclui refinamentos que melhoram a experiência do usuário:

Splash Screen Animada: Fundo de estrelas gerado proceduralmente em Swift.

Navegação Visual: Painéis interativos com miniaturas para navegar entre os dias.

Otimização de Performance: Cache, redimensionamento (downsampling) e pré-carregamento (prefetching) de imagens para uma rolagem fluida.
