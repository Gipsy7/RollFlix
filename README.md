# 🎬 Sorteador de Filmes por Gênero

Um app Flutter que ajuda você a decidir que filme assistir! Escolha um gênero e deixe o app sortear um filme aleatório para você usando dados reais da **API do The Movie Database (TMDb)**.

## 🎯 Funcionalidades

- **18 Gêneros Disponíveis**: Ação, Aventura, Animação, Comédia, Crime, Documentário, Drama, Família, Fantasia, História, Terror, Música, Mistério, Romance, Ficção Científica, Thriller, Guerra e Faroeste
- **API Real**: Integração com TMDb para buscar filmes atualizados
- **Informações Detalhadas**: Exibe título, ano, nota e poster do filme
- **Tela de Detalhes Completa**: Sinopse, elenco, direção e informações de produção
- **Trailers e Vídeos**: Assista trailers oficiais diretamente do YouTube
- **Redirecionamento para Streaming**: Clique nos provedores para abrir o serviço
- **Sorteio Aleatório**: Cada busca traz filmes diferentes e atualizados
- **Interface Intuitiva**: Design limpo e fácil de usar
- **Animações**: Efeito de animação quando o filme é sorteado
- **Indicador de Carregamento**: Feedback visual durante a busca
- **Fallback**: Lista estática como backup se a API não estiver disponível
- **Responsivo**: Funciona em diferentes tamanhos de tela

## � Integração com API

O app utiliza a **The Movie Database (TMDb) API** para buscar filmes reais:

- **Filmes Atualizados**: Sempre traz os filmes mais populares de cada gênero
- **Informações Completas**: Título, ano de lançamento, nota dos usuários e poster
- **Variedade**: Busca em páginas aleatórias para maior diversidade
- **Multilíngue**: Configurado para português brasileiro quando disponível

### Gêneros Mapeados:
- 🔫 **Ação** → Gênero 28 (Action)
- �️ **Aventura** → Gênero 12 (Adventure)
- 🎨 **Animação** → Gênero 16 (Animation)
- �😄 **Comédia** → Gênero 35 (Comedy)
- 🔪 **Crime** → Gênero 80 (Crime)
- 📹 **Documentário** → Gênero 99 (Documentary)
- 🎭 **Drama** → Gênero 18 (Drama)
- 👨‍👩‍👧‍👦 **Família** → Gênero 10751 (Family)
- 🧙‍♂️ **Fantasia** → Gênero 14 (Fantasy)
- 🏛️ **História** → Gênero 36 (History)
- 👻 **Terror** → Gênero 27 (Horror)
- 🎵 **Música** → Gênero 10402 (Music)
- 🕵️ **Mistério** → Gênero 9648 (Mystery)
- 💕 **Romance** → Gênero 10749 (Romance)
- 🚀 **Ficção Científica** → Gênero 878 (Science Fiction)
- 😱 **Thriller** → Gênero 53 (Thriller)
- ⚔️ **Guerra** → Gênero 10752 (War)
- 🤠 **Faroeste** → Gênero 37 (Western)

## 🚀 Como usar

1. **Abra o app**
2. **Escolha um dos 18 gêneros** disponíveis
3. **Toque no botão "🎲 SORTEAR FILME"**
4. **Aguarde o carregamento** da API
5. **Veja o filme sorteado** com poster, nota e informações!
6. **Clique no título** do filme para ver detalhes completos
7. **Explore a sinopse**, elenco e informações de produção
8. **Assista ao trailer** clicando no botão vermelho "Assistir Trailer"
9. **Veja vídeos adicionais** na seção de vídeos (se disponível)
10. **Clique nos provedores** de streaming para ser redirecionado ao serviço

### 🎬 Detalhes do Filme
- **Sinopse completa** e informações de produção
- **Elenco principal** com fotos e personagens
- **Direção** e equipe técnica
- **Trailers oficiais** com acesso direto ao YouTube
- **Vídeos adicionais** como teasers e making-of
- **Onde assistir** com links diretos para os serviços

### 🔗 Redirecionamento Inteligente
- **Netflix, Prime Video, Disney+** e outros serviços populares
- **Links diretos** para busca do filme no serviço
- **Fallback** para busca no Google se o provedor não for reconhecido

## 🛠️ Tecnologias

- **Flutter**: Framework para desenvolvimento multiplataforma
- **Dart**: Linguagem de programação
- **HTTP Package**: Para requisições à API
- **TMDb API**: Base de dados de filmes
- **Material Design 3**: Sistema de design do Google

## 📦 Dependências

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  http: ^1.1.0
  url_launcher: ^6.2.2
```

## 🛠️ Como executar

```bash
# Clone o projeto
git clone [seu-repositório]

# Entre no diretório
cd testeapp

# Instale as dependências
flutter pub get

# Execute o app
flutter run
```

## 📱 Plataformas Suportadas

- ✅ Android
- ✅ iOS  
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🔧 Configuração da API

O app usa a API do TMDb com uma chave pública para demonstração. Em produção, você deve:

1. Criar uma conta em [TMDb](https://www.themoviedb.org/settings/api)
2. Obter sua API key
3. Substituir no arquivo `lib/services/movie_service.dart`
4. Proteger a chave usando variáveis de ambiente

## 🛡️ Tratamento de Erros

- **Conexão**: Fallback para lista estática se a API falhar
- **Carregamento**: Indicador visual durante as requisições
- **Feedback**: Mensagens de erro amigáveis para o usuário
- **Validação**: Verificação de dados antes da exibição

---

**Desenvolvido com ❤️ em Flutter + TMDb API**
