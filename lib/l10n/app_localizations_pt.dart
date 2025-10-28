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
  String rollAndChillWithMode(Object mode) {
    return 'Roll and Chill • $mode';
  }

  @override
  String get menu => 'Menu';

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
  String get notAvailableShort => 'N/D';

  @override
  String get dateNightShareHeader => '🎬✨ PLANO DE ENCONTRO PERFEITO ✨🍽️';

  @override
  String get dateNightShareSectionMovie => 'FILME';

  @override
  String get labelTitle => 'Título';

  @override
  String get labelYear => 'Ano';

  @override
  String get labelRating => 'Avaliação';

  @override
  String get labelGenres => 'Gêneros';

  @override
  String get labelDuration => 'Duração';

  @override
  String get labelPoster => 'Poster';

  @override
  String get labelTrailer => 'Trailer';

  @override
  String get dateNightShareSectionMenu => 'MENU';

  @override
  String get labelMainDish => 'Prato Principal';

  @override
  String get labelDessert => 'Sobremesa';

  @override
  String get labelDrink => 'Bebida';

  @override
  String get labelSnacks => 'Petiscos';

  @override
  String get createdWithRollflix => 'Criado com Rollflix 🎬🍿';

  @override
  String get labelAppetizer => 'Petisco';

  @override
  String get labelSideDish => 'Acompanhamento';

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
  String get noSeriesFound => 'Nenhuma série encontrada';

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
  String get watched => 'Assistidos';

  @override
  String get movies => 'Filmes';

  @override
  String get series => 'SÉRIES';

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
  String get findYourNextFavoriteSeries => 'Encontre sua próxima série favorita';

  @override
  String get noPopularSeriesFound => 'Nenhuma série popular encontrada';

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
  String get dateNight => 'Date Night 🚧';

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
  String get rolls => 'Rolagens';

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
  String get aboutTheDish => 'Sobre o Prato';

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
  String get gamesAndActivities => 'Jogos & Atividades';

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

  @override
  String get coupleQuizRule1 => 'Escrevam respostas sobre o outro';

  @override
  String get coupleQuizRule2 => 'Comparem as respostas';

  @override
  String get coupleQuizRule3 => 'Ganhem pontos por acertos';

  @override
  String get coupleQuizRule4 => 'Descubram coisas novas!';

  @override
  String get movieMimicRule1 => 'Um faz mímica, outro adivinha';

  @override
  String get movieMimicRule2 => 'Sem palavras!';

  @override
  String get movieMimicRule3 => 'Tempo limite: 1 minuto por filme';

  @override
  String get searchSeriesHint => 'Digite o nome da série...';

  @override
  String get searchSeriesPrompt => 'Digite algo para pesquisar séries';

  @override
  String get trending => 'Em Alta';

  @override
  String get topRated => 'Mais Votados';

  @override
  String get all => 'Todos';

  @override
  String get searchTVHint => 'Buscar séries...';

  @override
  String get noSeriesAvailable => 'Nenhuma série disponível';

  @override
  String get reloading => 'Recarregando';

  @override
  String get trendingTab => 'Em Alta';

  @override
  String get topRatedTab => 'Mais Votadas';

  @override
  String get tapForDetails => 'Toque para detalhes';

  @override
  String get tapForMoreDetails => 'Toque para mais detalhes';

  @override
  String get recipeUnavailable => 'Receita Indisponível';

  @override
  String get calories => 'Calorias';

  @override
  String get carbohydrates => 'Carboidratos';

  @override
  String get fat => 'Gordura';

  @override
  String get quick => 'Rápido';

  @override
  String get mediumTime => 'Médio';

  @override
  String get elaborate => 'Elaborado';

  @override
  String get gourmet => 'Gourmet';

  @override
  String get beginner => 'Iniciante';

  @override
  String get intermediate => 'Intermediário';

  @override
  String get advancedSkill => 'Avançado';

  @override
  String get expert => 'Expert';

  @override
  String get beginnerDesc => 'Receitas simples e diretas';

  @override
  String get intermediateDesc => 'Alguma experiência necessária';

  @override
  String get advancedDesc => 'Técnicas mais complexas';

  @override
  String get expertDesc => 'Alta gastronomia';

  @override
  String get timeLabel => 'Tempo';

  @override
  String get difficultyLabel => 'Dificuldade';

  @override
  String get preparationTimePrefix => '⏱️ Tempo de Preparo:';

  @override
  String get difficultyPrefix => '📊 Dificuldade:';

  @override
  String get genreNovidades => 'Novidades';

  @override
  String get genreAcao => 'Ação';

  @override
  String get genreAventura => 'Aventura';

  @override
  String get genreAnimacao => 'Animação';

  @override
  String get genreComedia => 'Comédia';

  @override
  String get genreCrime => 'Crime';

  @override
  String get genreDocumentario => 'Documentário';

  @override
  String get genreDrama => 'Drama';

  @override
  String get genreFamilia => 'Família';

  @override
  String get genreFantasia => 'Fantasia';

  @override
  String get genreHistoria => 'História';

  @override
  String get genreTerror => 'Terror';

  @override
  String get genreMusica => 'Música';

  @override
  String get genreMisterio => 'Mistério';

  @override
  String get genreRomance => 'Romance';

  @override
  String get genreFiccaoCientifica => 'Ficção Científica';

  @override
  String get genreSuspense => 'Suspense';

  @override
  String get genreGuerra => 'Guerra';

  @override
  String get genreWestern => 'Western';

  @override
  String get genreFavoritos => 'Favoritos';

  @override
  String get genreAssistidos => 'Assistidos';

  @override
  String get tvGenreNovidades => 'Novidades';

  @override
  String get tvGenreAcaoAventura => 'Ação & Aventura';

  @override
  String get tvGenreAnimacao => 'Animação';

  @override
  String get tvGenreComedia => 'Comédia';

  @override
  String get tvGenreCrime => 'Crime';

  @override
  String get tvGenreDocumentario => 'Documentário';

  @override
  String get tvGenreDrama => 'Drama';

  @override
  String get tvGenreFamilia => 'Família';

  @override
  String get tvGenreInfantil => 'Infantil';

  @override
  String get tvGenreMisterio => 'Mistério';

  @override
  String get tvGenreNovela => 'Novela';

  @override
  String get tvGenreFiccaoCientificaFantasia => 'Ficção Científica & Fantasia';

  @override
  String get tvGenreTalkShow => 'Talk Show';

  @override
  String get tvGenreGuerraPolitica => 'Guerra & Política';

  @override
  String get tvGenreWestern => 'Western';

  @override
  String get tvGenreReality => 'Reality';

  @override
  String get tvGenreFavoritos => 'Favoritos';

  @override
  String get tvGenreAssistidos => 'Assistidos';

  @override
  String get memoriesAndExperiences => 'Memórias e Experiências';

  @override
  String get tastesAndPreferences => 'Gostos e Preferências';

  @override
  String get funAndImagination => 'Diversão e Imaginação';

  @override
  String get philosophyAndValues => 'Filosofia e Valores';

  @override
  String get relationship => 'Relacionamento';

  @override
  String get learnIn5YearsQuestion => 'O que você gostaria de aprender nos próximos 5 anos?';

  @override
  String get superpowerQuestion => 'Se pudesse ter qualquer superpoder, qual seria?';

  @override
  String get idealLifeQuestion => 'Qual seria sua vida ideal daqui a 10 anos?';

  @override
  String get bestChildhoodMemoryQuestion => 'Qual é a sua melhor memória de infância?';

  @override
  String get mostMemorableTripQuestion => 'Qual foi a viagem mais marcante que você já fez?';

  @override
  String get mostEmbarrassingMomentQuestion => 'Qual foi o momento mais embaraçoso da sua vida?';

  @override
  String get bestGiftReceivedQuestion => 'Qual foi o melhor presente que você já recebeu?';

  @override
  String get happiestDayQuestion => 'Qual foi o dia mais feliz da sua vida até agora?';

  @override
  String get favoriteMovieQuestion => 'Qual é o seu filme favorito de todos os tempos?';

  @override
  String get dinnerWithAnyoneQuestion => 'Se pudesse jantar com qualquer pessoa, viva ou morta, quem seria?';

  @override
  String get comfortFoodQuestion => 'Qual é a sua comida de conforto?';

  @override
  String get beachOrMountainQuestion => 'Praia ou montanha? Por quê?';

  @override
  String get musicThatMakesAliveQuestion => 'Qual música te faz sentir mais vivo?';

  @override
  String get superpowerNotWantedQuestion => 'Qual superpoder você NÃO gostaria de ter?';

  @override
  String get invisibleDayQuestion => 'Se pudesse ser invisível por um dia, o que faria?';

  @override
  String get movieStarNameQuestion => 'Qual seria seu nome de estrela de cinema?';

  @override
  String get decadeToReturnQuestion => 'Se pudesse voltar para qualquer década, qual seria?';

  @override
  String get mostImportantInLifeQuestion => 'O que você considera mais importante na vida?';

  @override
  String get adviceToYoungerSelfQuestion => 'Qual conselho você daria para seu eu de 10 anos atrás?';

  @override
  String get whatMakesGratefulQuestion => 'O que te faz sentir mais grato?';

  @override
  String get biggestFearQuestion => 'Qual é o seu maior medo?';

  @override
  String get successMeaningQuestion => 'O que significa sucesso para você?';

  @override
  String get mostValuedInRelationshipQuestion => 'O que você mais valoriza em um relacionamento?';

  @override
  String get bestMemoryTogetherQuestion => 'Qual foi nossa melhor memória juntos?';

  @override
  String get doMoreFrequentlyQuestion => 'O que você gostaria que fizéssemos mais frequentemente?';

  @override
  String get feelMostLovedQuestion => 'Como você se sente mais amado(a)?';

  @override
  String get whereWeSeeIn5YearsQuestion => 'Onde você nos vê daqui a 5 anos?';

  @override
  String get cookingBattleRule1 => 'Mesmo ingredientes, pratos diferentes';

  @override
  String get cookingBattleRule2 => 'Tempo limite: 30 minutos';

  @override
  String get cookingBattleRule3 => 'Avaliem juntos';

  @override
  String get cookingBattleRule4 => 'Quem perder faz a louça!';

  @override
  String get guessTheMovie => 'Adivinha o Filme';

  @override
  String get guessTheMovieDesc => 'Mímica de cenas de filmes';

  @override
  String get buildTheStory => 'Construam a História';

  @override
  String get buildTheStoryDesc => 'Criem uma história juntos';

  @override
  String get buildTheStoryRule1 => 'Um começa a história';

  @override
  String get buildTheStoryRule2 => 'Outro continua';

  @override
  String get buildTheStoryRule3 => 'Alternem a cada frase';

  @override
  String get buildTheStoryRule4 => 'Quanto mais absurdo, melhor!';

  @override
  String get alternateQuestionsRule => 'Alternem entre fazer perguntas';

  @override
  String get beHonestOpenRule => 'Sejam honestos e abertos';

  @override
  String get noJudgmentsRule => 'Sem julgamentos';

  @override
  String get canSkipQuestionRule => 'Podem passar uma pergunta se quiserem';

  @override
  String get chooseTruthOrDareRule => 'Escolha verdade ou desafio';

  @override
  String get truthsMustBeSincereRule => 'Verdades devem ser sinceras';

  @override
  String get daresMustBeCompletedRule => 'Desafios devem ser cumpridos';

  @override
  String get keepLightFunRule => 'Mantenha o clima leve e divertido';

  @override
  String get whoGetsMoreRightWinsRule => 'Quem acertar mais ganha';

  @override
  String get jazzSmooth => 'Jazz suave';

  @override
  String get bossaNova => 'Bossa nova';

  @override
  String get romanticClassics => 'Clássicos românticos';

  @override
  String get romanticPop => 'Pop romântico';

  @override
  String get indieFolk => 'Indie folk';

  @override
  String get eightiesHits => 'Sucessos dos anos 80';

  @override
  String get classicalMusic => 'Música clássica';

  @override
  String get contemporaryJazz => 'Jazz contemporâneo';

  @override
  String get instrumental => 'Instrumental';

  @override
  String get spanishMusic => 'Música espanhola';

  @override
  String get latinJazz => 'Latin jazz';

  @override
  String get musicalSoundtracks => 'Trilhas de musicais';

  @override
  String get softRock => 'Rock suave';

  @override
  String get romanticCountry => 'Country romântico';

  @override
  String get internationalPop => 'Pop internacional';

  @override
  String get classicRomance => 'Romance Clássico';

  @override
  String get romanticComedy => 'Comédia Romântica';

  @override
  String get romanticDrama => 'Drama Romântico';

  @override
  String get musicalRomance => 'Musical Romântico';

  @override
  String get adventureRomance => 'Romance Aventureiro';

  @override
  String get thrillerRomance => 'Suspense Romântico';

  @override
  String get romanticFun => 'Diversão Romântica';

  @override
  String get elegantRomance => 'Elegância Romântica';

  @override
  String get spanishPassion => 'Paixão Espanhola';

  @override
  String get mysteryJazz => 'Jazz Misterioso';

  @override
  String get darkAmbient => 'Ambient Sombrio';

  @override
  String get intenseClassical => 'Clássico Intenso';

  @override
  String get romanticMusic => 'Música Romântica';

  @override
  String get bluesClassic => 'Blues clássico';

  @override
  String get soulfulRhythms => 'Ritmos soul';

  @override
  String get chooseStyle => 'Escolha o Estilo';

  @override
  String get preparing => 'Preparando...';

  @override
  String get createPerfectDate => '💕 Criar Encontro Perfeito';

  @override
  String get ready => 'Pronto!';

  @override
  String get restart => 'Reiniciar';

  @override
  String get pause => 'Pausar';

  @override
  String get start => 'Iniciar';

  @override
  String get add5Min => '+5 min';

  @override
  String get ingredientsList => 'Lista de Ingredientes';

  @override
  String get mainCourse => 'Prato Principal';

  @override
  String get dessert => 'Sobremesa';

  @override
  String get appetizers => 'Petiscos';

  @override
  String get sideDishes => 'Acompanhamentos';

  @override
  String get allIngredientsReady => 'Todos os ingredientes prontos! 🎉';

  @override
  String get item => 'item';

  @override
  String get items => 'itens';

  @override
  String get dateNightSchedule => 'Cronograma do Date Night';

  @override
  String get shrimpRisotto => 'Risotto de camarão';

  @override
  String get homemadeMargheritaPizza => 'Pizza margherita caseira';

  @override
  String get grilledSalmonWithAsparagus => 'Salmão grelhado com aspargos';

  @override
  String get valencianPaella => 'Paella valenciana';

  @override
  String get gourmetBarbecue => 'Churrasco gourmet';

  @override
  String get wildMushroomRisotto => 'Risotto de cogumelos selvagens';

  @override
  String get roseWine => 'Vinho rosé';

  @override
  String get prosecco => 'Prosecco';

  @override
  String get softRedWine => 'Vinho tinto suave';

  @override
  String get sangria => 'Sangria';

  @override
  String get redBerryCaipirinha => 'Caipirinha de frutas vermelhas';

  @override
  String get fullBodiedRedWine => 'Vinho tinto encorpado';

  @override
  String get strawberriesWithChocolate => 'Morangos com chocolate';

  @override
  String get brownieWithIceCream => 'Brownie com sorvete';

  @override
  String get tiramisu => 'Tiramisù';

  @override
  String get cremeBrulee => 'Crème brûlée';

  @override
  String get fruitPavlova => 'Pavlova de frutas';

  @override
  String get darkChocolateCake => 'Torta de chocolate amargo';

  @override
  String get specialCheeses => 'Queijos especiais';

  @override
  String get grapes => 'Uvas';

  @override
  String get nuts => 'Nozes';

  @override
  String get gourmetPopcorn => 'Pipoca gourmet';

  @override
  String get olives => 'Azeitonas';

  @override
  String get garlicBread => 'Pães de alho';

  @override
  String get cheeseBoard => 'Tábua de frios';

  @override
  String get artisanBreads => 'Pães artesanais';

  @override
  String get varietyTapas => 'Tapas variadas';

  @override
  String get roastedPeppers => 'Pimentões assados';

  @override
  String get cheeseSkewers => 'Espetinhos de queijo';

  @override
  String get sweetPotatoChips => 'Chips de batata doce';

  @override
  String get guacamole => 'Guacamole';

  @override
  String get agedCheeses => 'Queijos maturados';

  @override
  String get rusticBreads => 'Pães rústicos';

  @override
  String get blackOlives => 'Azeitonas pretas';

  @override
  String get lowLightsAromaticCandles => 'Luzes baixas e velas aromáticas';

  @override
  String get relaxedFunAtmosphere => 'Ambiente descontraído e divertido';

  @override
  String get sophisticatedIntimate => 'Sofisticado e intimista';

  @override
  String get vibrantMusical => 'Vibrante e musical';

  @override
  String get adventurousRelaxed => 'Aventureiro e descontraído';

  @override
  String get mysteriousIntense => 'Misterioso e intenso';

  @override
  String get fortyFiveMinutes => '45 minutos';

  @override
  String get thirtyMinutes => '30 minutos';

  @override
  String get fiftyMinutes => '50 minutos';

  @override
  String get sixtyMinutes => '60 minutos';

  @override
  String get fortyMinutes => '40 minutos';

  @override
  String get fiftyFiveMinutes => '55 minutos';

  @override
  String get arborioRice => 'Arroz arbóreo';

  @override
  String get freshShrimp => 'Camarões frescos';

  @override
  String get whiteWine => 'Vinho branco';

  @override
  String get fishBroth => 'Caldo de peixe';

  @override
  String get parmesanCheese => 'Queijo parmesão';

  @override
  String get strawberries => 'Morangos';

  @override
  String get seventyPercentChocolate => 'Chocolate 70%';

  @override
  String get pizzaDough => 'Massa de pizza pronta';

  @override
  String get tomatoSauce => 'Molho de tomate';

  @override
  String get buffaloMozzarella => 'Mussarela de búfala';

  @override
  String get freshBasil => 'Manjericão fresco';

  @override
  String get brownieMix => 'Mix para brownie';

  @override
  String get vanillaIceCream => 'Sorvete de baunilha';

  @override
  String get salmonFillet => 'Filé de salmão';

  @override
  String get freshAsparagus => 'Aspargos frescos';

  @override
  String get sicilianLemon => 'Limão siciliano';

  @override
  String get extraVirginOliveOil => 'Azeite extra virgem';

  @override
  String get tiramisuIngredients => 'Ingredientes para tiramisù';

  @override
  String get espressoCoffee => 'Café expresso';

  @override
  String get bombaRice => 'Arroz bomba';

  @override
  String get seafood => 'Frutos do mar';

  @override
  String get chicken => 'Frango';

  @override
  String get saffron => 'Açafrão';

  @override
  String get peppers => 'Pimentões';

  @override
  String get redWine => 'Vinho tinto';

  @override
  String get fruitsForSangria => 'Frutas para sangria';

  @override
  String get nobleMeatForBarbecue => 'Carne nobre para churrasco';

  @override
  String get specialSeasonings => 'Temperos especiais';

  @override
  String get cachaca => 'Cachaça';

  @override
  String get redBerries => 'Frutas vermelhas';

  @override
  String get readyMeringue => 'Merengue pronto';

  @override
  String get seasonalFruits => 'Frutas da estação';

  @override
  String get wildMushrooms => 'Cogumelos selvagens';

  @override
  String get vegetableBroth => 'Caldo de legumes';

  @override
  String get eightyFivePercentChocolate => 'Chocolate 85%';

  @override
  String get heavyCream => 'Creme de leite';

  @override
  String get stirRisottoConstantly => 'Mexa o risotto constantemente para ficar cremoso';

  @override
  String get useFreshIngredients => 'Use ingredientes frescos para um sabor autêntico';

  @override
  String get dontOvercookSalmon => 'Não cozinhe demais o salmão para manter a textura';

  @override
  String get useTraditionalPaellaPan => 'Use panela paellera tradicional se possível';

  @override
  String get marinateMeatForHours => 'Deixe a carne marinando por algumas horas';

  @override
  String get useFreshMushrooms => 'Use cogumelos frescos para melhor sabor';

  @override
  String get classicRomanceTheme => 'Romance Clássico';

  @override
  String get romanticFunTheme => 'Diversão Romântica';

  @override
  String get elegantRomanceTheme => 'Elegância Romântica';

  @override
  String get spanishPassionTheme => 'Paixão Espanhola';

  @override
  String get adventureRomanceTheme => 'Romance Aventureiro';

  @override
  String get thrillerRomanceTheme => 'Suspense Romântico';

  @override
  String get candlesWarmLED => 'Velas e luzes LED quentes';

  @override
  String get colorfulLightsCheerful => 'Luzes coloridas e ambiente alegre';

  @override
  String get softLightingElegant => 'Iluminação suave e ambiente requintado';

  @override
  String get warmLightsFestive => 'Luzes quentes e atmosfera festiva';

  @override
  String get outdoorNaturalLight => 'Ambiente ao ar livre ou luzes naturais';

  @override
  String get lowLightsDramatic => 'Luzes baixas e atmosfera dramática';

  @override
  String get cost80120 => 'R\\\$ 80-120';

  @override
  String get cost4060 => 'R\\\$ 40-60';

  @override
  String get cost100150 => 'R\\\$ 100-150';

  @override
  String get cost90130 => 'R\\\$ 90-130';

  @override
  String get cost70100 => 'R\\\$ 70-100';

  @override
  String get cost85125 => 'R\\\$ 85-125';

  @override
  String get mushrooms => 'Cogumelos';

  @override
  String get onion => 'Cebola';

  @override
  String get garlic => 'Alho';

  @override
  String get bellPepper => 'Pimentão';

  @override
  String get strongCheeses => 'Queijos fortes';

  @override
  String get fish => 'Peixe';

  @override
  String get redMeat => 'Carne vermelha';

  @override
  String get milk => 'Leite';

  @override
  String get eggs => 'Ovos';

  @override
  String get director => 'Diretor';

  @override
  String get actor => 'Ator';

  @override
  String get selectedMovie => '🎬 Filme Selecionado';

  @override
  String get changeMovie => 'Trocar filme';

  @override
  String servingsText(Object count) {
    return '$count porções';
  }
}
