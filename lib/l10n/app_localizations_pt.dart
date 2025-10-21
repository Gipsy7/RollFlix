// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'RollFlix';

  @override
  String get cancel => 'Cancelar';

  @override
  String get watchAd => 'Assistir Anúncio';

  @override
  String get tryAgain => 'Tentar Novamente';

  @override
  String get clear => 'Limpar';

  @override
  String get watchAdConfirmTitle => 'Assistir um anúncio para ganhar um recurso?';

  @override
  String get watchAdConfirmBody => 'Assistir a um anúncio concederá uma recarga de recurso.';

  @override
  String resourceCount(Object uses, Object maxUses, Object resource) {
    return 'Você tem $uses/$maxUses $resource disponíveis.';
  }

  @override
  String get testNotification => 'Testar Notificação';

  @override
  String get rollAndChill => 'Roll and Chill';

  @override
  String get welcome => 'Bem-vindo!';

  @override
  String get loginToAccess => 'Faça login para acessar o aplicativo';

  @override
  String get connectingGoogle => 'Conectando com Google...';

  @override
  String get continueWithGoogle => 'Continuar com Google';

  @override
  String get loginTerms => 'Ao fazer login, você concorda com nossos\nTermos de Uso e Política de Privacidade';

  @override
  String loginError(Object error) {
    return 'Erro ao fazer login com Google: $error';
  }

  @override
  String get settings => 'Configurações';

  @override
  String get notifications => 'Notificações';

  @override
  String get enableNotifications => 'Ativar notificações';

  @override
  String get receiveReleaseNotifications => 'Receber notificações sobre lançamentos';

  @override
  String get movieReleases => 'Lançamentos de filmes';

  @override
  String get notifyFavoriteMovieReleases => 'Notificar quando filmes favoritos forem lançados';

  @override
  String get newEpisodes => 'Novos episódios';

  @override
  String get notifyFavoriteShowEpisodes => 'Notificar sobre episódios de séries favoritas';

  @override
  String get backgroundExecution => 'Execução em Background';

  @override
  String get automaticChecks => 'Verificações automáticas';

  @override
  String get every6HoursEvenClosed => 'A cada 6 horas, mesmo com app fechado';

  @override
  String get active => 'ATIVO';

  @override
  String get testsMaintenance => 'Testes e Manutenção';

  @override
  String get sendTestNotification => 'Enviar notificação de teste';

  @override
  String get clearSendHistory => 'Limpar histórico de envios';

  @override
  String get allowResendNotifications => 'Permite reenvio de notificações';

  @override
  String get clearHistory => 'Limpar Histórico';

  @override
  String get clearHistoryConfirm => 'Deseja realmente limpar todo o histórico de notificações? Esta ação não pode ser desfeita.';

  @override
  String get understood => 'Entendi';

  @override
  String get settingsSaved => 'Configurações salvas com sucesso';

  @override
  String settingsSaveError(Object error) {
    return 'Erro ao salvar configurações: $error';
  }

  @override
  String get sendHistoryCleared => 'Histórico de envios limpo com sucesso';

  @override
  String get testNotificationSent => 'Notificação de teste enviada!';

  @override
  String get notificationTestTitle => 'Teste de Notificação';

  @override
  String get notificationTestBody => 'Se você está vendo isso, as notificações estão funcionando! 🎉';

  @override
  String get backgroundInfoTitle => 'Como funciona:';

  @override
  String get backgroundInfoContent => '• Verificações automáticas a cada 6 horas\n• Funciona mesmo com app fechado\n• Requer conexão com internet\n• Não executa com bateria baixa\n• Sistema gerenciado pelo Android';

  @override
  String get performanceTitle => 'Performance:';

  @override
  String get performanceContent => '• Máximo 4 verificações por dia\n• Verifica apenas favoritos novos\n• Economia de 90% de bateria\n• 96% menos chamadas à API';

  @override
  String get language => 'Idioma';

  @override
  String get selectLanguage => 'Selecionar Idioma';

  @override
  String get english => 'Inglês';

  @override
  String get portuguese => 'Português';

  @override
  String get spanish => 'Espanhol';

  @override
  String get french => 'Francês';

  @override
  String get languageChanged => 'Idioma alterado com sucesso';

  @override
  String get restartApp => 'Reinicie o aplicativo para que as alterações tenham efeito';

  @override
  String get cannotOpenLink => 'Não foi possível abrir o link';

  @override
  String get errorOpeningLink => 'Erro ao abrir o link';

  @override
  String get watchTrailer => 'Assistir Trailer';

  @override
  String get synopsis => 'Sinopse';

  @override
  String get synopsisNotAvailable => 'Sinopse não disponível.';

  @override
  String get direction => 'Direção:';

  @override
  String get mainCast => 'Elenco Principal';

  @override
  String get videos => 'Vídeos';

  @override
  String get whereToWatch => 'Onde Assistir';

  @override
  String get streamingIncluded => 'Streaming (Incluído na assinatura):';

  @override
  String get rent => 'Aluguel:';

  @override
  String get buy => 'Compra:';

  @override
  String get streamingInfoNotAvailable => 'Informações de streaming não disponíveis no momento.';

  @override
  String get soundtrack => 'Trilha Sonora';

  @override
  String get themeSong => 'Música Tema';

  @override
  String get by => 'por';

  @override
  String get spotify => 'Spotify';

  @override
  String get youtube => 'YouTube';

  @override
  String get completePlaylist => 'Playlist Completa';

  @override
  String get spotifyPlaylist => 'Playlist no Spotify';

  @override
  String get youtubePlaylist => 'Playlist no YouTube';

  @override
  String get genresLabel => 'Gêneros';

  @override
  String get discoverMore => 'Descubra mais filmes incríveis no RollFlix!';

  @override
  String get trailerNotAvailable => 'Trailer não disponível';

  @override
  String get shareTooltip => 'Compartilhar';

  @override
  String get markAsWatched => 'Marcar como assistido';

  @override
  String get markAsUnwatched => 'Marcar como não assistido';

  @override
  String get removedFromWatched => 'Removido de assistidos';

  @override
  String get markedAsWatched => 'Marcado como assistido';

  @override
  String get errorLoadingDetails => 'Erro ao carregar detalhes do filme';

  @override
  String get errorLoadingTVShowDetails => 'Erro ao carregar detalhes da série';

  @override
  String get errorLoadingInitialData => 'Erro ao carregar dados iniciais';

  @override
  String get selectGenreFirst => 'Selecione um gênero primeiro';

  @override
  String get rollError => 'Não foi possível realizar o sorteio. Tente novamente.';

  @override
  String get noSeriesFound => 'Nenhuma série encontrada para esse filtro. Tente novamente.';

  @override
  String get noMovieFound => 'Nenhum filme encontrado para esse filtro. Tente novamente.';

  @override
  String get removedFromFavorites => 'Removido dos favoritos';

  @override
  String addedToFavorites(Object title) {
    return '❤️ $title adicionado aos favoritos';
  }

  @override
  String allItemsRemoved(Object contentType) {
    return 'Todos os $contentType foram removidos';
  }

  @override
  String get searchError => 'Erro ao pesquisar séries';

  @override
  String get favorites => 'Favoritos';

  @override
  String get watched => 'Já Assisti';

  @override
  String get movies => 'Filmes';

  @override
  String get series => 'Séries';

  @override
  String get seriesUpper => 'SÉRIES';

  @override
  String get moviesUpper => 'FILMES';

  @override
  String get seriesLower => 'séries';

  @override
  String get moviesLower => 'filmes';

  @override
  String get removeFromWatched => 'Remover de assistidos';

  @override
  String get removeFromWatchedQuestion => 'Remover de assistidos?';

  @override
  String confirmRemoveWatched(Object title) {
    return 'Tem certeza que deseja remover \"$title\" da lista de assistidos?';
  }

  @override
  String get clearAllWatched => 'Limpar todos os assistidos?';

  @override
  String confirmClearAllWatched(Object contentType, Object count) {
    return 'Tem certeza que deseja remover todos os $count $contentType assistidos?';
  }

  @override
  String get prioritizeHighRated => 'Prioriza filmes com maior nota';

  @override
  String get prioritizePopular => 'Prioriza filmes mais conhecidos';

  @override
  String get excludeWatched => 'Excluir já assistidos';

  @override
  String get excludeWatchedDescription => 'Não mostra conteúdos já marcados como assistidos';

  @override
  String get notificationDescription => 'Configure quando deseja receber notificações sobre seus filmes e séries favoritos.';

  @override
  String get movieReleasesTitle => '🎬 Lançamentos de Filmes';

  @override
  String get movieReleasesSubtitle => 'Notificar quando filmes favoritos forem lançados';

  @override
  String get newEpisodesTitle => '📺 Novos Episódios';

  @override
  String get newEpisodesSubtitle => 'Notificar sobre novos episódios de séries favoritas';

  @override
  String get close => 'Fechar';

  @override
  String get searchSeries => 'Pesquisar Séries';

  @override
  String get seriesMode => 'SÉRIES';

  @override
  String get movieMode => 'Modo: Filmes';

  @override
  String get switchToSeries => 'Alternar para Séries';

  @override
  String get switchToMovies => 'Alternar para Filmes';

  @override
  String get loadingMovies => 'Carregando filmes...';

  @override
  String get shareSeriesText => '🍿 Descubra mais séries incríveis no RollFlix!';

  @override
  String get typeToSearchSeries => 'Digite algo para pesquisar séries';

  @override
  String initialGenreSelected(Object genre) {
    return 'Gênero inicial selecionado: $genre';
  }

  @override
  String get newMovieSelected => '✅ Novo filme selecionado!';

  @override
  String get newMenuSelected => '✅ Novo menu selecionado!';

  @override
  String errorInitializingApp(Object error) {
    return 'Erro ao inicializar app: $error';
  }

  @override
  String modeChangedTo(Object mode) {
    return 'Modo alterado para: $mode';
  }

  @override
  String modeSetTo(Object mode) {
    return 'Modo definido para: $mode';
  }

  @override
  String get remove => 'Remover';

  @override
  String get addToFavorites => 'Adicionar aos favoritos';

  @override
  String get removeFromFavorites => 'Remover dos favoritos';

  @override
  String get markAsNotWatched => 'Marcar como não assistido';

  @override
  String get addToFavoritesTooltip => 'Adicionar aos favoritos';

  @override
  String get removeFromFavoritesTooltip => 'Remover dos favoritos';

  @override
  String get clearAllTooltip => 'Limpar todos';

  @override
  String get rollPreferencesTitle => 'Preferências de Rolagem';

  @override
  String chooseGenre(Object contentType) {
    return 'Escolha um Gênero de $contentType';
  }

  @override
  String get rolling => 'Rolando...';

  @override
  String get rollNewSeries => 'Rolar Nova Série';

  @override
  String get rollNewMovie => 'Rolar Novo Filme';

  @override
  String get rollSeries => 'Rolar Série';

  @override
  String get rollMovie => 'Rolar Filme';

  @override
  String get releasePeriod => 'Período de Lançamento';

  @override
  String get sortBy => 'Ordenar Por';

  @override
  String get contentRating => 'Classificação Indicativa';

  @override
  String get otherOptions => 'Outras Opções';

  @override
  String get apply => 'Aplicar';

  @override
  String get from => 'De';

  @override
  String get to => 'Até';

  @override
  String get any => 'Qualquer';

  @override
  String get clearPeriod => 'Limpar período';

  @override
  String get selectInitialYear => 'Selecionar Ano Inicial';

  @override
  String get selectFinalYear => 'Selecionar Ano Final';

  @override
  String get random => 'Aleatório';

  @override
  String get randomDescription => 'Ordem completamente aleatória';

  @override
  String get bestRated => 'Melhor Avaliados';

  @override
  String get mostPopular => 'Mais Populares';

  @override
  String get allowAdultContent => 'Permitir conteúdo +18';

  @override
  String get showAllContent => 'Exibir todo tipo de conteúdo';

  @override
  String get onlyNonAdultContent => 'Apenas conteúdo não adulto';

  @override
  String get activeNotifications => 'Notificações Ativas';

  @override
  String get activeNotificationsDescription => 'Ativar/desativar todas as notificações';

  @override
  String get testNotificationHint => 'Toque para enviar uma notificação de teste';

  @override
  String get home => 'Início';

  @override
  String get searchMovies => 'Pesquisar Filmes';

  @override
  String get myProfile => 'Meu Perfil';

  @override
  String get login => 'Entrar';

  @override
  String get discoverAmazingSeries => 'Descubra séries incríveis';

  @override
  String get dateNight => 'Date Night';

  @override
  String get dateNightComingSoon => 'Date Night em desenvolvimento!\nEm breve disponível 🚀';

  @override
  String get clearCache => 'Limpar Cache';

  @override
  String get cacheCleared => 'Cache de filmes e receitas limpo!';

  @override
  String get aboutApp => 'Sobre o App';

  @override
  String get notificationHistory => 'Histórico de Notificações';

  @override
  String get version => 'Versão';

  @override
  String get whatIsRollflix => 'O que é o Rollflix?';

  @override
  String get whatIsRollflixDescription => 'Aplicativo para descobrir filmes e séries aleatórios por gênero. Escolha entre mais de 18 gêneros diferentes e encontre seu próximo entretenimento!';

  @override
  String get availableFeatures => 'Recursos Disponíveis';

  @override
  String get movieSeriesRoller => 'Sorteador de Filmes e Séries';

  @override
  String get movieSeriesRollerDescription => 'Descubra seu próximo entretenimento de forma aleatória';

  @override
  String get genresAvailable => '18+ Gêneros Disponíveis';

  @override
  String get genresAvailableDescription => 'Ação, comédia, terror, romance, ficção científica e muito mais';

  @override
  String get smartNotifications => 'Notificações Inteligentes';

  @override
  String get smartNotificationsDescription => 'Fique por dentro dos lançamentos dos seus favoritos';

  @override
  String get favoritesSystem => 'Sistema de Favoritos';

  @override
  String get favoritesSystemDescription => 'Salve e acompanhe seus filmes e séries preferidos';

  @override
  String get movieSeriesMode => 'Modo Filmes e Séries';

  @override
  String get movieSeriesModeDescription => 'Alterne facilmente entre filmes e séries';

  @override
  String get inDevelopment => '🚀 Em Desenvolvimento';

  @override
  String get newFeaturesComing => 'Novos recursos que estão sendo desenvolvidos e em breve estarão disponíveis:';

  @override
  String get movieQuiz => 'Quiz de Filmes';

  @override
  String get movieQuizDescription => 'Teste seus conhecimentos sobre cinema com perguntas desafiadoras';

  @override
  String get dateNightDescription => 'Encontre o filme ou série perfeito para assistir a dois';

  @override
  String get soundtrackQuiz => 'Quiz de Trilha Sonora';

  @override
  String get soundtrackQuizDescription => 'Adivinhe o filme ou série pela música';

  @override
  String get technologies => 'Tecnologias';

  @override
  String get developedWithFlutter => 'Desenvolvido com Flutter';

  @override
  String get copyright => '2025 Rollflix';

  @override
  String get allRightsReserved => 'Todos os direitos reservados';

  @override
  String get comingSoon => 'EM BREVE';

  @override
  String get noWatchedItems => 'Nenhum item assistido';

  @override
  String markWatchedHint(Object contentType) {
    return 'Marque os $contentType que você já assistiu para vê-los aqui';
  }

  @override
  String get seriesLabel => 'Série';

  @override
  String get movieLabel => 'Filme';

  @override
  String get watchedToday => 'Assistido hoje';

  @override
  String get watchedYesterday => 'Assistido ontem';

  @override
  String watchedDaysAgo(Object days) {
    return 'Assistido há $days dias';
  }

  @override
  String watchedWeeksAgo(Object weeks, Object weekWord) {
    return 'Assistido há $weeks $weekWord';
  }

  @override
  String watchedMonthsAgo(Object months, Object monthWord) {
    return 'Assistido há $months $monthWord';
  }

  @override
  String watchedYearsAgo(Object years, Object yearWord) {
    return 'Assistido há $years $yearWord';
  }

  @override
  String get week => 'semana';

  @override
  String get weeks => 'semanas';

  @override
  String get month => 'mês';

  @override
  String get months => 'meses';

  @override
  String get year => 'ano';

  @override
  String get years => 'anos';

  @override
  String get clearAll => 'Limpar todos';

  @override
  String get myFavorites => 'Meus Favoritos';

  @override
  String get loadingFavorites => 'Carregando favoritos...';

  @override
  String get noFavoritesYet => 'Nenhum favorito ainda';

  @override
  String addToFavoritesHint(Object contentType) {
    return 'Adicione $contentType aos favoritos\npara vê-los aqui!';
  }

  @override
  String get removeFavorite => 'Remover favorito?';

  @override
  String confirmRemoveFavorite(Object title) {
    return 'Deseja remover \"$title\" dos favoritos?';
  }

  @override
  String noFavoritesToClear(Object contentType) {
    return 'Não há $contentType favoritos para limpar';
  }

  @override
  String get clearAllFavorites => 'Limpar todos os favoritos?';

  @override
  String confirmClearAllFavorites(Object contentType, Object count) {
    return 'Todos os $count $contentType favoritos serão removidos. Esta ação não pode ser desfeita.';
  }

  @override
  String allFavoritesCleared(Object contentType) {
    return 'Todos os $contentType favoritos foram removidos';
  }

  @override
  String get logoutConfirmTitle => 'Sair da conta?';

  @override
  String get logoutConfirmMessage => 'Você será desconectado e precisará fazer login novamente.';

  @override
  String get logout => 'Sair';

  @override
  String logoutError(Object error) {
    return 'Erro ao fazer logout: $error';
  }

  @override
  String get loadingProfile => 'Carregando perfil...';

  @override
  String get logoutButton => 'Sair da Conta';

  @override
  String get rolls => 'Sorteios';

  @override
  String get searchHint => 'Digite o nome do filme ou série...';

  @override
  String get searchMoviesError => 'Erro ao pesquisar filmes';

  @override
  String get searchingMovies => 'Pesquisando filmes...';

  @override
  String get noResultsFound => 'Nenhum resultado encontrado';

  @override
  String get tryDifferentKeywords => 'Tente pesquisar com outras palavras-chave';

  @override
  String get noMoviesFound => 'Nenhum filme encontrado';

  @override
  String get loadingMoreResults => 'Carregando mais resultados...';

  @override
  String get tapPlusOne => 'Toque +1';

  @override
  String watchAdForExtraResource(Object resource) {
    return 'Assista a um anúncio curto e ganhe +1 $resource extra!';
  }

  @override
  String get appVersion => 'Versão 4.0.0';

  @override
  String get basicInfo => 'Informações Básicas';

  @override
  String get biography => 'Biografia';

  @override
  String get filmography => 'Filmografia';

  @override
  String get filmographyAsDirector => 'Filmografia como Diretor';

  @override
  String errorLoadingHistory(Object error) {
    return 'Erro ao carregar histórico';
  }

  @override
  String get historyCleared => 'Histórico limpo com sucesso';

  @override
  String get noNotifications => 'Nenhuma notificação';

  @override
  String get notificationHint => 'Você será notificado quando houver novos lançamentos dos seus favoritos';

  @override
  String get firstAirDate => 'Primeira exibição:';

  @override
  String get cast => 'Elenco';

  @override
  String get crew => 'Equipe';

  @override
  String get screenplay => 'Roteiro:';

  @override
  String get trailers => 'Trailers';

  @override
  String get user => 'Usuário';

  @override
  String get accountInfo => 'Informações da Conta';

  @override
  String get userId => 'ID do Usuário';

  @override
  String get yes => 'Sim';

  @override
  String get no => 'Não';

  @override
  String get statistics => 'Estatísticas';

  @override
  String get findYourNextFavoriteMovie => 'Encontre seu próximo filme favorito';

  @override
  String get heroes => 'Heróis';

  @override
  String get chooseGenreOf => 'Escolha um Gênero de';

  @override
  String get available => 'Disponível';

  @override
  String get unavailable => 'Indisponível';

  @override
  String get dateNightPreferences => 'Preferências do Date Night';

  @override
  String get customizeYourExperience => 'Personalize Sua Experiência';

  @override
  String get configurePreferencesForPersonalizedSuggestions => 'Configure suas preferências para sugestões personalizadas';

  @override
  String get dietaryRestrictions => 'Restrições Alimentares';

  @override
  String get budget => 'Orçamento';

  @override
  String get preparationTime => 'Tempo de Preparo';

  @override
  String get culinaryLevel => 'Nível Culinário';

  @override
  String get drinkPreferences => 'Preferências de Bebidas';

  @override
  String get ingredientsToAvoid => 'Ingredientes a Evitar';

  @override
  String get restoreDefault => 'Restaurar Padrão';

  @override
  String get savePreferences => 'Salvar Preferências';

  @override
  String get includeAlcoholicBeverages => 'Incluir bebidas alcoólicas';

  @override
  String get suggestionsWillIncludeWinesAndDrinks => 'Sugestões incluirão vinhos e drinques';

  @override
  String get onlyNonAlcoholicBeverages => 'Apenas bebidas não-alcoólicas';

  @override
  String get selectIngredientsToAvoid => 'Selecione ingredientes que deseja evitar:';

  @override
  String get preferencesRestoredToDefault => 'Preferências restauradas para o padrão';

  @override
  String get preferencesSavedSuccessfully => 'Preferências salvas com sucesso!';

  @override
  String recipeReady(Object title) {
    return '⏰ $title está pronto!';
  }

  @override
  String get next => 'Próxima';

  @override
  String get recipeLoadError => 'Não foi possível carregar a receita. Tente novamente.';

  @override
  String get adNotAvailable => 'Anúncio não disponível no momento. Tente novamente em instantes.';

  @override
  String get preferencesCleared => 'Preferências limpas';

  @override
  String get shareSeries => 'Compartilhar série';

  @override
  String get preferences => 'Preferências';

  @override
  String get changeMeal => 'Trocar refeição';

  @override
  String get movieTab => 'Filme';

  @override
  String get mealTab => 'Refeição';

  @override
  String get checklistTab => 'Checklist';

  @override
  String get romanticDate => '💕 Encontro Romântico';

  @override
  String get casualDate => '🍿 Encontro Casual';

  @override
  String get elegantDate => '🥂 Encontro Elegante';

  @override
  String get funDate => '🎉 Encontro Divertido';

  @override
  String get cozyDate => '🏠 Encontro Aconchegante';

  @override
  String get dateDetails => '🌟 Detalhes do Encontro';

  @override
  String get releaseLabel => 'Lançamento:';

  @override
  String get durationLabel => 'Duração:';

  @override
  String get defaultMovieOverview => 'Uma história romântica emocionante que vai tornar sua noite ainda mais especial.';

  @override
  String get technicalInfo => 'Informações Técnicas';

  @override
  String get productionLabel => 'Produção:';

  @override
  String get checklistHint => 'Marque os itens conforme você os adiciona ao carrinho!';

  @override
  String get intimateQuestionsGame => '20 Perguntas Íntimas';

  @override
  String get intimateQuestionsDesc => 'Conheçam melhor um ao outro com perguntas profundas e divertidas';

  @override
  String get easy => 'Fácil';

  @override
  String get romanticTruthOrDare => 'Verdade ou Desafio Romântico';

  @override
  String get romanticTruthOrDareDesc => 'Versão romântica do clássico jogo';

  @override
  String get medium => 'Médio';

  @override
  String get cookingBattle => 'Batalha Culinária';

  @override
  String get cookingBattleDesc => 'Competição amigável de preparar um prato';

  @override
  String get loserDoesDishes => 'Quem perder faz a louça!';

  @override
  String get advanced => 'Avançado';

  @override
  String get coupleQuizDesc => 'Testem o quanto se conhecem';

  @override
  String get dreamsAndAspirations => 'Sonhos e Aspirações';

  @override
  String get dreamLocationQuestion => 'Se você pudesse viver em qualquer lugar do mundo, onde seria?';

  @override
  String get professionalDreamQuestion => 'Qual é o seu maior sonho profissional?';

  @override
  String get servingsUnit => 'porções';

  @override
  String get nutritionalInfo => 'Informações Nutricionais';

  @override
  String get protein => 'Proteína';

  @override
  String get adultFilter => '🔞 Apenas não adulto';

  @override
  String get preferencesApplied => 'Preferências aplicadas!';

  @override
  String get moviesMode => 'FILMES';

  @override
  String get rollGenre => 'Rolar Gênero';

  @override
  String seriesRolled(Object count) {
    return 'Série $count sorteada';
  }

  @override
  String movieRolled(Object count) {
    return 'Filme $count sorteado';
  }

  @override
  String get tryDifferentGenre => 'Tente selecionar outro gênero ou recarregar a página.';

  @override
  String get players => 'jogadores';

  @override
  String get minutes => 'min';

  @override
  String get rules => 'Regras';

  @override
  String get questions => 'perguntas';

  @override
  String get interestingQuestions => 'Perguntas interessantes para conhecerem melhor um ao outro';

  @override
  String get conversationStarters => 'Iniciadores de Conversa';

  @override
  String get movieGenreQuestion => 'Se sua vida fosse um filme, qual seria o gênero?';

  @override
  String get dateNightGames => 'Jogos para o Encontro';

  @override
  String get makeNightFun => 'Deixe a noite mais divertida e memorável';

  @override
  String get season => 'temporada';

  @override
  String get seasons => 'temporadas';

  @override
  String get episode => 'episódio';

  @override
  String get episodes => 'episódios';

  @override
  String get genres => 'Gêneros';

  @override
  String get newEpisodeAvailable => 'Novo Episódio Disponível!';

  @override
  String get newEpisodeOf => 'Novo episódio de';

  @override
  String get earnExtraResource => 'Ganhar Recurso Extra';

  @override
  String noResourceAvailable(Object resource) {
    return 'Você não tem $resource disponível.';
  }

  @override
  String get confirm => 'Confirmar';

  @override
  String errorChangingMovie(Object error) {
    return 'Erro ao trocar filme: $error';
  }

  @override
  String errorChangingMenu(Object error) {
    return 'Erro ao trocar menu: $error';
  }

  @override
  String errorSharing(Object error) {
    return 'Erro ao compartilhar: $error';
  }

  @override
  String errorOpeningDetails(Object error) {
    return 'Erro ao abrir detalhes: $error';
  }

  @override
  String get selectDateNightType => 'Selecione um tipo de encontro primeiro';

  @override
  String get noMoviesForDateNight => 'Nenhum filme encontrado para este tipo de encontro';

  @override
  String errorGeneratingDateNight(Object error) {
    return 'Erro ao gerar encontro: $error';
  }

  @override
  String get seriesType => 'SÉRIE';

  @override
  String get movieType => 'FILME';

  @override
  String get reminderType => 'LEMBRETE';

  @override
  String get otherType => 'OUTRO';
}
