# Documentação da Arquitetura MVVM

## 1. Organização do projeto

O projeto foi desenvolvido utilizando o padrão arquitetural MVVM (Model-View-ViewModel), separando a interface, os dados e as regras de negócio.

A estrutura ficou organizada da seguinte forma:

- **Models:** contém as classes Usuario e Documento.
- **Services:** realiza o armazenamento e a consulta dos dados.
- **Views:** contém as telas de Login, Cadastro, Home e Editor.
- **ViewModels:** controla os estados e as operações de cada funcionalidade.
- **Utils:** contém os validadores e o controle global do tema.
- **main.dart:** configura o aplicativo, os temas e as rotas.

## 2. Mapeamento de classes e widgets

| Elemento | Arquivo |
|---|---|
| Classe Usuario | models/usuario.dart |
| Classe Documento | models/documento.dart |
| Serviço de usuários | models/services/usuario_service.dart |
| Serviço de preferências | models/services/preferencias_service.dart |
| Serviço de documentos | models/services/documento_service.dart |
| LoginView | views/login_view.dart |
| CadastroView | views/cadastro_view.dart |
| HomeView | views/home_view.dart |
| EditorView | views/editor_view.dart |
| LoginViewModel | viewmodels/login_viewmodel.dart |
| CadastroViewModel | viewmodels/cadastro_viewmodel.dart |
| HomeViewModel | viewmodels/home_viewmodel.dart |
| DocumentosViewModel | viewmodels/documentos_viewmodel.dart |
| Validadores | utils/validadores.dart |
| Tema global | utils/tema_global.dart |
| Rotas e inicialização | main.dart |

## 3. Alterações de estrutura e imports

O código que inicialmente estava concentrado em um único arquivo no DartPad foi dividido em arquivos separados.

Foram organizados os imports e separadas as responsabilidades de cada componente.

As telas passaram a utilizar seus respectivos ViewModels e modelos necessários.

Também foram configuradas rotas nomeadas no arquivo main.dart:

- `/`: Login
- `/cadastro`: Cadastro
- `/home`: Página inicial
- `/editor`: Criação e edição de documentos

## 4. Mudanças no gerenciamento de estado

A lógica de negócio foi transferida das telas para os ViewModels, utilizando ChangeNotifier.

O método notifyListeners() informa quando ocorre uma alteração nos dados, enquanto o ListenableBuilder permite que a interface seja atualizada automaticamente.

Os estados e as operações de autenticação, cadastro e documentos são controlados pelos respectivos ViewModels.

As Views mantêm apenas os controles e estados locais necessários à interface.

## 5. CRUD e persistência de dados

Foi criada a classe Documento para representar os documentos cadastrados.

O DocumentosViewModel realiza as operações de criação, consulta, edição e exclusão.

O DocumentoService utiliza o pacote shared_preferences e os métodos jsonEncode e jsonDecode para armazenar os documentos em formato JSON.

Dessa forma, os documentos permanecem salvos mesmo após atualizar a página do aplicativo.

## 6. Preferências e sessão do usuário

O PreferenciasService utiliza shared_preferences para armazenar as preferências de tema e notificações.

Também foram implementados métodos para salvar, consultar e encerrar a sessão do usuário, armazenando seu nome e e-mail.

O tema selecionado é carregado na inicialização do aplicativo, permitindo manter a escolha entre as sessões.

O controle global do tema é realizado por meio de ValueNotifier e ValueListenableBuilder.

## 7. Testes realizados

Foi executado o comando flutter analyze, que não apresentou erros de código, apenas avisos informativos relacionados à depreciação do pacote material.dart.

O comando flutter test também foi executado com sucesso, confirmando a aprovação dos testes automatizados.

## 8. Conclusão

A implementação da arquitetura MVVM tornou o projeto mais organizado e facilitou a manutenção e a separação das responsabilidades.

A segunda fase acrescentou a criação, leitura, edição e exclusão de documentos, além da persistência local das preferências e dos dados de sessão utilizando shared_preferences.