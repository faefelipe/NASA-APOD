# 🚀 NASA-APOD - App de Fotos Espaciais  
**Technical Test for Skopia Digital**
## 📦 Como Rodar o Projeto  

Siga os passos abaixo para compilar e rodar o projeto localmente.

### 1. Clonar o Repositório  
Clone o repositório para a sua máquina local usando o Terminal:

```bash
git clone https://github.com/faefelipe/NASA-APOD.git
cd NASA-APOD
2. Obter uma Chave da API da NASA
Este aplicativo requer uma chave de API da NASA para funcionar.

Acesse: https://api.nasa.gov/

Preencha o formulário para gerar sua chave gratuita.

Ela será enviada para o seu e-mail.

3. Configurar a Chave de API (Passo Essencial)
Para manter a chave de API segura e fora do controle de versão, o projeto utiliza um arquivo .xcconfig.

Na pasta raiz do projeto (mesmo nível do arquivo .xcodeproj), crie um arquivo chamado:
Keys.xcconfig
Adicione a seguinte linha, substituindo SUA_CHAVE_AQUI pela chave recebida:
NASA_API_KEY = SUA_CHAVE_AQUI
O projeto já está configurado para ler a chave desse arquivo.
O Keys.xcconfig está no .gitignore para que sua chave não seja enviada ao repositório.

4. Abrir no Xcode e Compilar
Abra o arquivo .xcodeproj no Xcode.

O Swift Package Manager irá baixar a dependência Kingfisher automaticamente.

Selecione um simulador ou dispositivo físico.

Pressione Run (Cmd+R) para compilar e executar.

📂 Organização e Legibilidade do Código
Estrutura de pastas clara baseada na arquitetura MVVM-C.

Nomes descritivos para facilitar a leitura e manutenção.

🏗️ Arquitetura e Boas Práticas
O projeto utiliza MVVM-C para máxima separação de responsabilidades:

Model → Estruturas de dados da API.

View → Componentes de UI passivos e reutilizáveis.

ViewModel → Lógica de apresentação e gerenciamento de estado.

Coordinator → Controle centralizado do fluxo de navegação.

Service & Persistence → Camadas isoladas para rede e armazenamento local.

⚠️ Tratamento de Erros
Erros de rede tratados de forma segura.

Exibe mensagem amigável e botão “Tentar Novamente” para recuperação.

🎨 Experiência do Usuário (UX)
Tema inspirado na NASA, com Light & Dark Mode.

Navegação intuitiva.

Feedback claro ao usuário com loaders e telas de erro.

🧪 Testes Unitários
Implementados para ViewModel e Persistência.

Uso de MockAPIService para simular rede.

Testes independentes da internet → rápidos e confiáveis.

✨ Funcionalidades e Refinamentos
Splash Screen Animada → fundo de estrelas procedural em Swift.

Navegação Visual → painéis interativos com miniaturas de cada dia.

Otimização de Performance → cache, downsampling e prefetching de imagens para rolagem fluida.
![Initial_screen](https://github.com/user-attachments/assets/5f69456f-67f7-4c2b-b77a-fee95ab276ea)
![Start_Screen](https://github.com/user-attachments/assets/355cbee7-bbab-4b9d-a72b-e806ca9d3efd)
![List](https://github.com/user-attachments/assets/52305a6e-ba3f-48f7-bf4f-a4dfb5330dd9)
![Detail-Screen](https://github.com/user-attachments/assets/3b8504a0-096f-4cb2-ad6a-969d72d1f622)
![Delete-Item-Favorites](https://github.com/user-attachments/assets/7212b91b-ba85-42f8-aaa4-b50ad44c896b)

