# Documentação da Arquitetura MVVM

## 1. Organização do projeto

O projeto foi reorganizado utilizando o padrão arquitetural MVVM (Model-View-ViewModel), separando a interface, os dados e as regras de negócio.

- **Models:** contém a classe `Usuario`, responsável pela estrutura dos dados do usuário.
- **Views:** contém as telas de Login, Cadastro e Home.
- **ViewModels:** contém a lógica e o gerenciamento dos estados de cada tela.
- **Services:** contém os serviços de usuários e preferências.
- **Utils:** contém os validadores e o controle global do tema.

## 2. Migração das telas

As telas originais foram separadas em arquivos:

| Tela original | Nova estrutura |
|---|---|
| Login | `login_view.dart` e `login_viewmodel.dart` |
| Cadastro | `cadastro_view.dart` e `cadastro_viewmodel.dart` |
| Home | `home_view.dart` e `home_viewmodel.dart` |

## 3. Comunicação entre as classes

As Views são responsáveis pela interface e interação com o usuário. Os ViewModels controlam os estados e executam as regras de negócio, utilizando `ChangeNotifier`.

O método `notifyListeners()` informa às telas quando ocorre uma alteração. O componente `ListenableBuilder` atualiza a interface automaticamente.

## 4. Rotas e navegação

As rotas foram configuradas no arquivo `main.dart`:

- `/`: Login
- `/cadastro`: Cadastro
- `/home`: Página inicial

A navegação entre as telas utiliza o `Navigator` do Flutter.

## 5. Gerenciamento de estado

O gerenciamento de estado foi transferido para os ViewModels, substituindo a necessidade de utilizar `setState()` para atualizar os estados das telas.

Os formulários e controladores de texto continuam nas Views, enquanto os estados e as operações de negócio ficam nos ViewModels.

## 6. Persistência de dados e documentos

Foi implementada a funcionalidade de criação, leitura, edição e exclusão de documentos.

A classe `Documento` representa os dados de cada documento, enquanto o `DocumentoService` realiza o armazenamento utilizando o pacote `shared_preferences`.

Os documentos são salvos localmente em formato JSON, permitindo que continuem disponíveis após fechar ou atualizar o aplicativo.

## 7. Preferências do usuário

O serviço `PreferenciasService` foi atualizado para utilizar `shared_preferences`, armazenando as configurações de tema e notificações.

O tema selecionado é carregado ao iniciar o aplicativo, mantendo a preferência do usuário entre as sessões.

## 8. Conclusão

A migração para MVVM tornou o projeto mais organizado, facilitando a manutenção, a reutilização de código e a implementação de novas funcionalidades. A segunda etapa acrescentou o gerenciamento de documentos e a persistência local de dados e preferências.