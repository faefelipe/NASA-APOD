NASA-APOD - App de Fotos Espaciais
Technical Test for Skopia Digital

Um aplicativo iOS que consome a API "Astronomy Picture of the Day" (APOD) da NASA, permitindo ao usuário explorar imagens do dia, navegar por datas, favoritar e visualizar sua coleção.

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
