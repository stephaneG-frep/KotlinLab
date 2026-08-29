import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../domain/learning_models.dart';

Lesson _lesson({
  required String id,
  required String title,
  required String subtitle,
  required String concept,
  required String code,
  required String practice,
  required IconData icon,
  required String level,
  int duration = 15,
  int xp = 45,
}) => Lesson(
  id: id,
  title: title,
  subtitle: subtitle,
  duration: duration,
  xp: xp,
  status: LessonStatus.locked,
  icon: icon,
  level: level,
  content: _course(title, concept, code.replaceAll(r'\n', '\n'), practice),
);

String _course(String title, String concept, String code, String practice) =>
    '''
# $title

## Objectifs

- Comprendre le rôle de **$title** dans un programme Kotlin.
- Lire et expliquer un exemple idiomatique.
- Appliquer le concept dans un petit programme autonome.

## Comprendre

$concept

```kotlin
$code
```

## Lecture du code

Observe les types, les valeurs qui peuvent évoluer et le résultat de chaque expression. Kotlin privilégie un code concis, mais la concision ne doit jamais masquer l’intention.

> **Bonne pratique** — $practice

## Erreurs fréquentes

- Reproduire mécaniquement les habitudes de Java au lieu d’utiliser les idiomes Kotlin.
- Rendre une valeur nullable ou mutable sans nécessité.
- Écrire une expression compacte qui devient difficile à relire.

## Comparaison avec Java

Kotlin supprime une grande partie du code cérémoniel de Java. Les types restent stricts, tandis que l’inférence, les expressions et la null safety rendent l’intention plus visible.

## Mémo

1. Commence par la solution la plus simple.
2. Préfère les valeurs immuables.
3. Fais exprimer les contraintes par le système de types.
4. Donne des noms qui expliquent le métier.

## Défi

Réécris l’exemple avec tes propres données, puis ajoute un cas limite. Explique le résultat attendu avant de lancer le code.
''';

final learningPaths = <LearningPath>[
  LearningPath(
    id: 'beginner',
    title: 'Fondations Kotlin',
    subtitle: 'Débutant · 12 leçons',
    color: AppColors.primary,
    icon: Icons.rocket_launch_rounded,
    progress: 0,
    lessons: [
      _lesson(
        id: 'intro',
        title: 'Bienvenue dans Kotlin',
        subtitle: 'Pourquoi apprendre Kotlin',
        concept:
            'Kotlin est un langage moderne, statiquement typé et interopérable avec Java. Il sert au développement Android, serveur, desktop et multiplateforme.',
        code: 'fun main() {\n    println("Bienvenue dans KotlinLab")\n}',
        practice:
            'Exécute de petits programmes souvent : une boucle de retour rapide accélère l’apprentissage.',
        icon: Icons.waving_hand_rounded,
        level: 'Débutant',
        duration: 6,
        xp: 20,
      ),
      _lesson(
        id: 'hello',
        title: 'Premier programme',
        subtitle: 'main et println',
        concept:
            'L’exécution commence généralement dans une fonction main. println écrit une valeur suivie d’un retour à la ligne.',
        code:
            r'fun main() {\n    val learner = "Ada"\n    println("Bonjour, $learner !")\n}',
        practice:
            'Utilise l’interpolation de chaînes plutôt que de longues concaténations avec +.',
        icon: Icons.terminal_rounded,
        level: 'Débutant',
        duration: 8,
        xp: 30,
      ),
      _lesson(
        id: 'variables',
        title: 'Variables & types',
        subtitle: 'val, var et inférence',
        concept:
            'val crée une référence non réassignable et var une référence modifiable. Kotlin infère souvent le type depuis la valeur initiale.',
        code:
            r'val language: String = "Kotlin"\nvar score = 0\nscore += 10\nprintln("$language : $score XP")',
        practice:
            'Commence toujours par val et ne passe à var que si la réassignation est nécessaire.',
        icon: Icons.data_object_rounded,
        level: 'Débutant',
        duration: 14,
        xp: 40,
      ),
      _lesson(
        id: 'basic_types',
        title: 'Types essentiels',
        subtitle: 'Nombres, textes et booléens',
        concept:
            'String, Int, Long, Double, Boolean et Char couvrent la majorité des premières données. Les conversions sont explicites.',
        code:
            'val age = 28\nval price = 19.99\nval active = true\nval initial = \'K\'\nprintln(age.toDouble() + price)',
        practice:
            'Choisis le type qui traduit le domaine, pas simplement le plus grand type.',
        icon: Icons.text_fields_rounded,
        level: 'Débutant',
      ),
      _lesson(
        id: 'operators',
        title: 'Opérateurs',
        subtitle: 'Calculer et comparer',
        concept:
            'Les opérateurs arithmétiques calculent des valeurs. Les opérateurs de comparaison et logiques construisent des conditions booléennes.',
        code:
            r'val subtotal = 80.0\nval freeDelivery = subtotal >= 50.0\nval total = subtotal * 1.20\nprintln("Total: $total, offerte: $freeDelivery")',
        practice:
            'Décompose les conditions complexes dans des variables booléennes bien nommées.',
        icon: Icons.calculate_rounded,
        level: 'Débutant',
      ),
      _lesson(
        id: 'conditions',
        title: 'Conditions',
        subtitle: 'if, else et when',
        concept:
            'if et when sont des expressions : elles peuvent produire directement une valeur. when évite les cascades difficiles à lire.',
        code:
            'val score = 82\nval grade = when {\n    score >= 90 -> "A"\n    score >= 75 -> "B"\n    else -> "C"\n}\nprintln(grade)',
        practice:
            'Utilise when quand plusieurs branches représentent un même choix métier.',
        icon: Icons.alt_route_rounded,
        level: 'Débutant',
        duration: 16,
        xp: 50,
      ),
      _lesson(
        id: 'loops',
        title: 'Boucles & ranges',
        subtitle: 'for, while et répétitions',
        concept:
            'for parcourt une séquence ou un intervalle. while convient quand le nombre de répétitions n’est pas connu à l’avance.',
        code:
            'for (number in 1..5) {\n    println(number * number)\n}\nfor (index in 10 downTo 0 step 2) println(index)',
        practice:
            'Pour transformer une collection, préfère souvent map ou filter à une boucle avec état mutable.',
        icon: Icons.loop_rounded,
        level: 'Débutant',
      ),
      _lesson(
        id: 'functions',
        title: 'Fonctions',
        subtitle: 'Paramètres et retours',
        concept:
            'Une fonction rassemble une responsabilité nommée. Les paramètres par défaut et les expressions simples réduisent les surcharges.',
        code:
            'fun finalPrice(price: Double, discount: Double = 0.0): Double =\n    price * (1 - discount)\n\nprintln(finalPrice(100.0, discount = 0.15))',
        practice:
            'Écris des fonctions courtes dont le nom décrit le résultat ou l’action.',
        icon: Icons.functions_rounded,
        level: 'Débutant',
        duration: 18,
        xp: 55,
      ),
      _lesson(
        id: 'strings',
        title: 'Chaînes de caractères',
        subtitle: 'Interpolation et manipulation',
        concept:
            'Les chaînes offrent interpolation, textes multi-lignes et de nombreuses transformations sans modifier la valeur originale.',
        code:
            'val raw = "  kotlin lab  "\nval words = raw.trim().split(" ")\nval title = words.joinToString(" ") { it.replaceFirstChar(Char::uppercase) }\nprintln(title)',
        practice:
            'Utilise la bibliothèque standard avant de réinventer un traitement de texte.',
        icon: Icons.short_text_rounded,
        level: 'Débutant',
      ),
      _lesson(
        id: 'lists',
        title: 'Listes',
        subtitle: 'Collections ordonnées',
        concept:
            'listOf crée une liste en lecture seule. mutableListOf autorise les ajouts. map, filter et sortedBy composent des traitements.',
        code:
            'val scores = listOf(12, 18, 9, 16)\nval passed = scores\n    .filter { it >= 10 }\n    .map { it * 5 }\nprintln(passed)',
        practice:
            'Expose une List en lecture seule même si l’implémentation interne est mutable.',
        icon: Icons.view_list_rounded,
        level: 'Débutant',
        duration: 18,
        xp: 55,
      ),
      _lesson(
        id: 'sets_maps',
        title: 'Sets & Maps',
        subtitle: 'Unicité et associations',
        concept:
            'Set garantit l’unicité des éléments. Map associe une clé unique à une valeur et facilite les recherches directes.',
        code:
            'val tags = setOf("kotlin", "android", "kotlin")\nval capitals = mapOf("France" to "Paris", "Japon" to "Tokyo")\nprintln(tags.size)\nprintln(capitals["France"])',
        practice:
            'Choisis la collection selon l’opération principale : ordre, unicité ou accès par clé.',
        icon: Icons.hub_rounded,
        level: 'Débutant',
      ),
      _lesson(
        id: 'beginner_review',
        title: 'Révision des fondations',
        subtitle: 'Assembler les concepts',
        concept:
            'Un petit programme complet combine fonctions, conditions et collections. La décomposition évite une fonction main gigantesque.',
        code:
            'fun average(values: List<Int>) = values.average()\n\nfun main() {\n    val scores = listOf(14, 18, 11)\n    val result = average(scores)\n    println(if (result >= 10) "Validé" else "À revoir")\n}',
        practice:
            'Avant de coder, écris les entrées, le résultat attendu et deux cas limites.',
        icon: Icons.school_rounded,
        level: 'Débutant',
        duration: 22,
        xp: 70,
      ),
    ],
  ),
  LearningPath(
    id: 'intermediate',
    title: 'Kotlin orienté objet',
    subtitle: 'Intermédiaire · 10 leçons',
    color: AppColors.secondary,
    icon: Icons.widgets_rounded,
    progress: 0,
    lessons: [
      _lesson(
        id: 'classes',
        title: 'Classes & objets',
        subtitle: 'Modéliser un domaine',
        concept:
            'Une classe réunit état et comportement cohérents. Le constructeur principal se place dans l’en-tête de la classe.',
        code:
            'class BankAccount(val owner: String, initial: Double) {\n    var balance = initial\n        private set\n    fun deposit(amount: Double) {\n        require(amount > 0)\n        balance += amount\n    }\n}',
        practice:
            'Protège les invariants dans la classe plutôt que de laisser chaque appelant les vérifier.',
        icon: Icons.category_rounded,
        level: 'Intermédiaire',
        duration: 20,
        xp: 65,
      ),
      _lesson(
        id: 'constructors',
        title: 'Constructeurs',
        subtitle: 'Initialiser correctement',
        concept:
            'Le constructeur principal définit les dépendances essentielles. init valide ou prépare l’état à la création.',
        code:
            'class User(val name: String, val age: Int) {\n    init {\n        require(name.isNotBlank())\n        require(age >= 0)\n    }\n}',
        practice:
            'Un objet valide dès sa construction réduit les vérifications ailleurs.',
        icon: Icons.build_circle_rounded,
        level: 'Intermédiaire',
      ),
      _lesson(
        id: 'data',
        title: 'Data classes',
        subtitle: 'Des modèles concis',
        concept:
            'data class génère equals, hashCode, toString, componentN et copy à partir des propriétés principales.',
        code:
            'data class User(val id: Long, val name: String)\nval ada = User(1, "Ada")\nval updated = ada.copy(name = "Ada Lovelace")',
        practice: 'Réserve les data classes aux valeurs et modèles de données.',
        icon: Icons.inventory_2_rounded,
        level: 'Intermédiaire',
      ),
      _lesson(
        id: 'enums_sealed',
        title: 'Enum & sealed',
        subtitle: 'Modéliser des choix finis',
        concept:
            'enum représente des constantes proches. sealed interface permet des variantes portant chacune leurs données.',
        code:
            'sealed interface Result {\n    data class Success(val value: String) : Result\n    data class Failure(val message: String) : Result\n}\nfun label(result: Result) = when (result) {\n    is Result.Success -> result.value\n    is Result.Failure -> result.message\n}',
        practice:
            'Utilise une hiérarchie sealed pour rendre les états impossibles difficiles à représenter.',
        icon: Icons.account_tree_rounded,
        level: 'Intermédiaire',
        duration: 20,
        xp: 70,
      ),
      _lesson(
        id: 'interfaces',
        title: 'Interfaces',
        subtitle: 'Définir des contrats',
        concept:
            'Une interface décrit une capacité sans imposer de stockage. Les classes peuvent implémenter plusieurs interfaces.',
        code:
            'interface Repository<T> {\n    fun findAll(): List<T>\n    fun save(value: T)\n}\nclass MemoryRepository<T> : Repository<T> {\n    private val values = mutableListOf<T>()\n    override fun findAll() = values.toList()\n    override fun save(value: T) { values += value }\n}',
        practice: 'Crée une abstraction lorsqu’elle exprime un vrai contrat.',
        icon: Icons.handshake_rounded,
        level: 'Intermédiaire',
      ),
      _lesson(
        id: 'inheritance',
        title: 'Héritage & polymorphisme',
        subtitle: 'Partager un comportement',
        concept:
            'Les classes sont final par défaut. open autorise l’héritage, override rend les redéfinitions explicites.',
        code:
            'abstract class Shape { abstract fun area(): Double }\nclass Circle(private val radius: Double) : Shape() {\n    override fun area() = Math.PI * radius * radius\n}',
        practice:
            'Préfère la composition sauf lorsqu’une vraie relation « est un » existe.',
        icon: Icons.polyline_rounded,
        level: 'Intermédiaire',
      ),
      _lesson(
        id: 'null',
        title: 'Null safety',
        subtitle: 'Maîtriser l’absence de valeur',
        concept:
            'Le type T? rend l’absence explicite. ?., ?:, let et les smart casts permettent de la traiter sans NullPointerException.',
        code:
            r'fun greeting(name: String?): String {\n    val clean = name?.trim()?.takeIf { it.isNotEmpty() }\n    return "Bonjour, ${clean ?: "inconnu"}"\n}',
        practice:
            'Évite !! : transforme, filtre ou fournis une valeur de remplacement.',
        icon: Icons.shield_rounded,
        level: 'Intermédiaire',
        duration: 22,
        xp: 75,
      ),
      _lesson(
        id: 'extensions',
        title: 'Fonctions d’extension',
        subtitle: 'Enrichir une API',
        concept:
            'Une extension ajoute une fonction appelable sur un type sans modifier ni hériter de ce type.',
        code:
            'fun String.toSlug(): String = lowercase()\n    .trim()\n    .replace(Regex("[^a-z0-9]+"), "-")\n    .trim(\'-\')\nprintln("Kotlin Facile".toSlug())',
        practice:
            'Place les extensions près du domaine et évite les utilitaires vagues.',
        icon: Icons.extension_rounded,
        level: 'Intermédiaire',
      ),
      _lesson(
        id: 'scope_functions',
        title: 'Scope functions',
        subtitle: 'let, run, apply et also',
        concept:
            'Les scope functions exécutent un bloc dans le contexte d’un objet. Elles diffèrent par le récepteur et la valeur retournée.',
        code:
            r'val user = User(1, "Ada").also {\n    println("Création de $it")\n}\nval label = user.run { "#$id — $name" }',
        practice:
            'Choisis une scope function pour sa sémantique et évite de les imbriquer.',
        icon: Icons.center_focus_strong_rounded,
        level: 'Intermédiaire',
      ),
      _lesson(
        id: 'exceptions',
        title: 'Exceptions & Result',
        subtitle: 'Gérer les échecs',
        concept:
            'try est une expression. Les exceptions conviennent aux échecs exceptionnels ; Result transporte explicitement succès ou échec.',
        code:
            'fun parsePort(raw: String): Result<Int> = runCatching {\n    raw.toInt().also { require(it in 1..65535) }\n}\nparsePort("8080").onSuccess(::println)',
        practice:
            'Ne capture pas Exception sans stratégie : transforme, journalise ou propage avec du contexte.',
        icon: Icons.warning_amber_rounded,
        level: 'Intermédiaire',
        duration: 20,
        xp: 70,
      ),
    ],
  ),
  LearningPath(
    id: 'advanced',
    title: 'Kotlin avancé',
    subtitle: 'Avancé · 8 leçons',
    color: const Color(0xFFFF8A65),
    icon: Icons.bolt_rounded,
    progress: 0,
    lessons: [
      _lesson(
        id: 'coroutines',
        title: 'Coroutines',
        subtitle: 'Asynchrone structuré',
        concept:
            'Une coroutine suspend son travail sans bloquer le thread. La concurrence structurée lie les tâches à un scope.',
        code:
            'suspend fun loadDashboard(): Dashboard = coroutineScope {\n    val user = async { loadUser() }\n    val news = async { loadNews() }\n    Dashboard(user.await(), news.await())\n}',
        practice: 'N’utilise pas GlobalScope pour le travail applicatif.',
        icon: Icons.sync_rounded,
        level: 'Avancé',
        duration: 30,
        xp: 100,
      ),
      _lesson(
        id: 'flow',
        title: 'Flow',
        subtitle: 'Flux réactifs',
        concept:
            'Flow représente un flux froid de valeurs asynchrones. Les opérateurs le transforment et collect déclenche son exécution.',
        code:
            'fun search(query: Flow<String>) = query\n    .debounce(300)\n    .distinctUntilChanged()\n    .flatMapLatest(repository::search)',
        practice:
            'Collecte un Flow dans un scope contrôlé et annule les travaux obsolètes.',
        icon: Icons.waves_rounded,
        level: 'Avancé',
        duration: 28,
        xp: 100,
      ),
      _lesson(
        id: 'generics',
        title: 'Génériques & variance',
        subtitle: 'APIs réutilisables et sûres',
        concept:
            'Les paramètres de type rendent une API réutilisable. out exprime un producteur, in un consommateur.',
        code:
            'interface Producer<out T> { fun next(): T }\ninterface Consumer<in T> { fun accept(value: T) }\nfun <T> List<T>.secondOrNull(): T? = getOrNull(1)',
        practice: 'Ajoute de la variance seulement lorsqu’elle améliore l’API.',
        icon: Icons.all_inclusive_rounded,
        level: 'Avancé',
        xp: 95,
      ),
      _lesson(
        id: 'higher_order',
        title: 'Fonctions d’ordre supérieur',
        subtitle: 'Fonctions comme valeurs',
        concept:
            'Une fonction peut recevoir ou retourner une fonction. Les lambdas séparent mécanisme et politique.',
        code:
            'fun <T> measure(block: () -> T): T {\n    val start = System.nanoTime()\n    return block().also { println(System.nanoTime() - start) }\n}',
        practice: 'Extrais une lambda complexe dans une fonction nommée.',
        icon: Icons.functions_rounded,
        level: 'Avancé',
        xp: 90,
      ),
      _lesson(
        id: 'dsl',
        title: 'Créer un DSL',
        subtitle: 'APIs déclaratives',
        concept:
            'Les lambdas avec récepteur et les builders créent un langage spécialisé lisible, comme Gradle ou Compose.',
        code:
            'class Menu {\n    val items = mutableListOf<String>()\n    fun item(label: String) { items += label }\n}\nfun menu(block: Menu.() -> Unit) = Menu().apply(block)\nval main = menu { item("Accueil"); item("Profil") }',
        practice:
            'Un DSL doit réduire l’ambiguïté ; ajoute @DslMarker si nécessaire.',
        icon: Icons.auto_fix_high_rounded,
        level: 'Avancé',
        xp: 100,
      ),
      _lesson(
        id: 'solid',
        title: 'SOLID en Kotlin',
        subtitle: 'Conception maintenable',
        concept:
            'SOLID aide à maintenir des responsabilités ciblées, des contrats stables et des dépendances orientées vers des abstractions.',
        code:
            'class CheckoutService(\n    private val payments: PaymentGateway,\n    private val orders: OrderRepository,\n) {\n    fun checkout(order: Order) {\n        payments.charge(order.total)\n        orders.save(order.paid())\n    }\n}',
        practice: 'Applique les principes pour résoudre une douleur concrète.',
        icon: Icons.architecture_rounded,
        level: 'Avancé',
        duration: 25,
        xp: 100,
      ),
      _lesson(
        id: 'testing',
        title: 'Tests unitaires',
        subtitle: 'Vérifier le comportement',
        concept:
            'Un test prépare un scénario, exécute une action puis vérifie un résultat observable. Les fonctions pures sont simples à tester.',
        code:
            '@Test fun `applies ten percent discount`() {\n    val result = PriceCalculator().total(100.0, 0.10)\n    assertEquals(90.0, result, 0.001)\n}',
        practice:
            'Teste les comportements et cas limites, pas les détails privés.',
        icon: Icons.science_rounded,
        level: 'Avancé',
        xp: 100,
      ),
      _lesson(
        id: 'performance',
        title: 'Performance',
        subtitle: 'Mesurer avant d’optimiser',
        concept:
            'Les allocations et traversées répétées peuvent coûter cher. Un benchmark mesure une hypothèse dans des conditions contrôlées.',
        code:
            'val result = buildList {\n    for (value in source) {\n        if (value.isValid()) add(value.transform())\n    }\n}',
        practice:
            'Profile d’abord, optimise le point chaud mesuré, puis mesure à nouveau.',
        icon: Icons.speed_rounded,
        level: 'Avancé',
        xp: 105,
      ),
    ],
  ),
  LearningPath(
    id: 'android',
    title: 'Android & Compose',
    subtitle: 'Spécialisation · 8 leçons',
    color: AppColors.success,
    icon: Icons.android_rounded,
    progress: 0,
    lessons: [
      _lesson(
        id: 'android_project',
        title: 'Projet Android',
        subtitle: 'Structure et cycle de vie',
        concept:
            'Une application Android sépare configuration, ressources, code et tests. Le cycle de vie contrôle le travail de l’interface.',
        code:
            'class MainActivity : ComponentActivity() {\n    override fun onCreate(state: Bundle?) {\n        super.onCreate(state)\n        setContent { KotlinLabTheme { App() } }\n    }\n}',
        practice: 'Ne conserve jamais une Activity dans un singleton.',
        icon: Icons.folder_special_rounded,
        level: 'Android',
        duration: 22,
        xp: 80,
      ),
      _lesson(
        id: 'compose',
        title: 'Jetpack Compose',
        subtitle: 'Interfaces déclaratives',
        concept:
            'Une fonction @Composable décrit l’interface pour un état donné. Quand l’état change, Compose recompose les parties nécessaires.',
        code:
            r'@Composable\nfun Greeting(name: String, onContinue: () -> Unit) {\n    Column(Modifier.padding(24.dp)) {\n        Text("Bonjour $name")\n        Button(onClick = onContinue) { Text("Continuer") }\n    }\n}',
        practice:
            'Remonte l’état au niveau qui le possède et garde les composables stateless.',
        icon: Icons.phone_android_rounded,
        level: 'Android',
        duration: 28,
        xp: 95,
      ),
      _lesson(
        id: 'compose_state',
        title: 'État dans Compose',
        subtitle: 'State et recomposition',
        concept:
            'remember conserve une valeur durant la composition. rememberSaveable survit aux recréations simples.',
        code:
            r'@Composable\nfun Counter() {\n    var count by rememberSaveable { mutableIntStateOf(0) }\n    Button(onClick = { count++ }) { Text("Compteur : $count") }\n}',
        practice:
            'Ne place pas de calcul coûteux directement dans une fonction composable.',
        icon: Icons.touch_app_rounded,
        level: 'Android',
        xp: 90,
      ),
      _lesson(
        id: 'navigation',
        title: 'Navigation',
        subtitle: 'Écrans et arguments',
        concept:
            'Navigation Compose associe des routes à des destinations. Les arguments transmis doivent rester minimaux.',
        code:
            r'NavHost(navController, startDestination = "home") {\n    composable("home") { HomeScreen(onUser = { id ->\n        navController.navigate("user/$id")\n    }) }\n    composable("user/{id}") { UserScreen() }\n}',
        practice:
            'Transmets un identifiant et recharge les données depuis la source de vérité.',
        icon: Icons.route_rounded,
        level: 'Android',
        xp: 90,
      ),
      _lesson(
        id: 'viewmodel',
        title: 'ViewModel & StateFlow',
        subtitle: 'État d’écran durable',
        concept:
            'ViewModel conserve la logique de présentation. StateFlow expose un état immuable observable par Compose.',
        code:
            'class UsersViewModel : ViewModel() {\n    private val _uiState = MutableStateFlow(UsersState())\n    val uiState = _uiState.asStateFlow()\n    fun refresh() = viewModelScope.launch {\n        _uiState.update { it.copy(loading = true) }\n    }\n}',
        practice:
            'Expose un StateFlow en lecture seule et des fonctions décrivant les intentions.',
        icon: Icons.account_tree_rounded,
        level: 'Android',
        duration: 28,
        xp: 100,
      ),
      _lesson(
        id: 'room',
        title: 'Room',
        subtitle: 'Persistance locale',
        concept:
            'Room vérifie les requêtes SQL à la compilation et mappe tables, DAO et objets Kotlin.',
        code:
            '@Entity data class Note(\n    @PrimaryKey val id: Long, val text: String\n)\n@Dao interface NoteDao {\n    @Query("SELECT * FROM Note") fun observeAll(): Flow<List<Note>>\n    @Insert suspend fun insert(note: Note)\n}',
        practice: 'Mappe les entités de la couche data vers le domaine.',
        icon: Icons.storage_rounded,
        level: 'Android',
        xp: 100,
      ),
      _lesson(
        id: 'retrofit',
        title: 'Retrofit & réseau',
        subtitle: 'Consommer une API REST',
        concept:
            'Retrofit transforme une interface annotée en client HTTP. Il faut distinguer les erreurs réseau, HTTP et de décodage.',
        code:
            'interface UsersApi {\n    @GET("users/{id}")\n    suspend fun user(@Path("id") id: Long): UserDto\n}\nclass UsersRepository(private val api: UsersApi) {\n    suspend fun user(id: Long) = api.user(id).toDomain()\n}',
        practice: 'Ne laisse pas les DTO réseau sortir de la couche data.',
        icon: Icons.cloud_download_rounded,
        level: 'Android',
        xp: 100,
      ),
      _lesson(
        id: 'android_testing',
        title: 'Tester une app Compose',
        subtitle: 'UI et ViewModel',
        concept:
            'Les tests de ViewModel valident les transitions d’état. Les tests Compose recherchent des nœuds sémantiques.',
        code:
            '@Test fun counter_increments() {\n    composeRule.setContent { Counter() }\n    composeRule.onNodeWithText("Compteur : 0").assertExists()\n    composeRule.onNodeWithRole(Role.Button).performClick()\n    composeRule.onNodeWithText("Compteur : 1").assertExists()\n}',
        practice:
            'Ajoute des descriptions sémantiques utiles aux tests et à l’accessibilité.',
        icon: Icons.fact_check_rounded,
        level: 'Android',
        duration: 25,
        xp: 105,
      ),
    ],
  ),
];

ExerciseItem _exercise({
  required String id,
  required String title,
  required String category,
  required String difficulty,
  required int xp,
  required IconData icon,
  required Color color,
  required String prompt,
  required List<String> options,
  required int correctIndex,
  required String explanation,
  String? code,
}) => ExerciseItem(
  id: id,
  title: title,
  category: category,
  difficulty: difficulty,
  xp: xp,
  icon: icon,
  color: color,
  prompt: prompt,
  options: options,
  correctIndex: correctIndex,
  explanation: explanation,
  code: code?.replaceAll(r'\n', '\n'),
);

final exercises = <ExerciseItem>[
  _exercise(
    id: 'ex1',
    title: 'Prédire la sortie',
    category: 'Variables',
    difficulty: 'Facile',
    xp: 20,
    icon: Icons.visibility_rounded,
    color: AppColors.secondary,
    prompt: 'Quelle sortie produit ce programme ?',
    code: r'val name = "Kotlin"\nprintln("Hello $name")',
    options: [
      'Bonjour Kotlin',
      'Hello Kotlin',
      'Kotlin Hello',
      'Erreur de compilation',
    ],
    correctIndex: 1,
    explanation:
        r'L’interpolation $name insère la valeur Kotlin dans la chaîne.',
  ),
  _exercise(
    id: 'ex2',
    title: 'Choisir val ou var',
    category: 'Variables',
    difficulty: 'Facile',
    xp: 20,
    icon: Icons.data_object_rounded,
    color: AppColors.primary,
    prompt: 'Quel mot-clé convient à une référence jamais réassignée ?',
    options: ['var', 'val', 'mutable', 'static'],
    correctIndex: 1,
    explanation:
        'val interdit la réassignation et doit être le choix par défaut.',
  ),
  _exercise(
    id: 'ex3',
    title: 'Compléter la condition',
    category: 'Conditions',
    difficulty: 'Facile',
    xp: 25,
    icon: Icons.code_rounded,
    color: AppColors.primary,
    prompt: 'Quel opérateur accepte aussi une personne de 18 ans ?',
    code: 'if (age __ 18) println("Accès autorisé")',
    options: ['>', '>=', '==', '<='],
    correctIndex: 1,
    explanation: 'Il faut utiliser >= pour inclure la valeur 18.',
  ),
  _exercise(
    id: 'ex4',
    title: 'Lire une expression when',
    category: 'Conditions',
    difficulty: 'Moyen',
    xp: 35,
    icon: Icons.alt_route_rounded,
    color: AppColors.accent,
    prompt: 'Quelle valeur prend label ?',
    code:
        'val score = 72\nval label = when {\n  score >= 80 -> "Très bien"\n  score >= 60 -> "Bien"\n  else -> "À revoir"\n}',
    options: ['Très bien', 'Bien', 'À revoir', 'null'],
    correctIndex: 1,
    explanation: '72 satisfait la deuxième branche score >= 60.',
  ),
  _exercise(
    id: 'ex5',
    title: 'Comprendre un range',
    category: 'Boucles',
    difficulty: 'Facile',
    xp: 25,
    icon: Icons.loop_rounded,
    color: AppColors.secondary,
    prompt: 'Combien de fois la boucle s’exécute-t-elle ?',
    code: 'for (i in 1..4) println(i)',
    options: ['3', '4', '5', 'À l’infini'],
    correctIndex: 1,
    explanation: '1..4 est inclusif : il contient quatre valeurs.',
  ),
  _exercise(
    id: 'ex6',
    title: 'Retour de fonction',
    category: 'Fonctions',
    difficulty: 'Facile',
    xp: 30,
    icon: Icons.functions_rounded,
    color: AppColors.primary,
    prompt: 'Quel est le type de retour inféré ?',
    code: 'fun double(value: Int) = value * 2',
    options: ['Unit', 'Double', 'Int', 'Number?'],
    correctIndex: 2,
    explanation:
        'Les deux opérandes sont des Int, la fonction renvoie donc Int.',
  ),
  _exercise(
    id: 'ex7',
    title: 'Filtrer une liste',
    category: 'Collections',
    difficulty: 'Moyen',
    xp: 40,
    icon: Icons.filter_alt_rounded,
    color: AppColors.success,
    prompt: 'Quelle opération conserve les nombres pairs ?',
    options: [
      'map { it % 2 == 0 }',
      'filter { it % 2 == 0 }',
      'forEach { it / 2 }',
      'sorted()',
    ],
    correctIndex: 1,
    explanation: 'filter conserve les éléments dont le prédicat vaut true.',
  ),
  _exercise(
    id: 'ex8',
    title: 'Transformer une liste',
    category: 'Collections',
    difficulty: 'Moyen',
    xp: 40,
    icon: Icons.transform_rounded,
    color: AppColors.secondary,
    prompt: 'Quelle est la valeur de result ?',
    code: 'val result = listOf(1, 2, 3).map { it * 10 }',
    options: ['[1, 2, 3]', '[10, 20, 30]', '[10]', '60'],
    correctIndex: 1,
    explanation: 'map transforme chaque élément et produit une nouvelle liste.',
  ),
  _exercise(
    id: 'ex9',
    title: 'Sécuriser un nullable',
    category: 'Null safety',
    difficulty: 'Moyen',
    xp: 45,
    icon: Icons.shield_rounded,
    color: const Color(0xFFFF8A65),
    prompt: 'Quelle expression renvoie 0 si name vaut null ?',
    options: [
      'name!!.length',
      'name.length',
      'name?.length ?: 0',
      'name?length',
    ],
    correctIndex: 2,
    explanation:
        '?. effectue l’accès sûr et ?: fournit la valeur de remplacement.',
  ),
  _exercise(
    id: 'ex10',
    title: 'Copier une data class',
    category: 'POO',
    difficulty: 'Moyen',
    xp: 45,
    icon: Icons.copy_rounded,
    color: AppColors.secondary,
    prompt: 'Comment créer un utilisateur identique avec un autre nom ?',
    code:
        'data class User(val id: Int, val name: String)\nval ada = User(1, "Ada")',
    options: [
      'ada.name = "Grace"',
      'ada.copy(name = "Grace")',
      'User.copy(ada)',
      'clone(ada)',
    ],
    correctIndex: 1,
    explanation:
        'copy est générée pour les data classes et remplace certaines propriétés.',
  ),
  _exercise(
    id: 'ex11',
    title: 'Reconnaître une extension',
    category: 'Extensions',
    difficulty: 'Moyen',
    xp: 45,
    icon: Icons.extension_rounded,
    color: AppColors.primary,
    prompt: 'Quelle déclaration ajoute isLong() à String ?',
    options: [
      'fun isLong(String): Boolean',
      'fun String.isLong() = length > 10',
      'extension String isLong()',
      'String::isLong = length > 10',
    ],
    correctIndex: 1,
    explanation: 'Le type récepteur String précède le nom de la fonction.',
  ),
  _exercise(
    id: 'ex12',
    title: 'Choisir une scope function',
    category: 'Scope functions',
    difficulty: 'Difficile',
    xp: 60,
    icon: Icons.center_focus_strong_rounded,
    color: AppColors.accent,
    prompt: 'Quelle fonction configure puis retourne l’objet ?',
    options: ['let', 'run', 'apply', 'with'],
    correctIndex: 2,
    explanation: 'apply utilise this et renvoie l’objet récepteur.',
  ),
  _exercise(
    id: 'ex13',
    title: 'Analyser une coroutine',
    category: 'Coroutines',
    difficulty: 'Difficile',
    xp: 70,
    icon: Icons.sync_rounded,
    color: const Color(0xFFFF8A65),
    prompt: 'Quel builder renvoie Deferred<T> ?',
    options: ['launch', 'async', 'withContext', 'runBlocking'],
    correctIndex: 1,
    explanation: 'async produit Deferred<T>, dont await récupère le résultat.',
  ),
  _exercise(
    id: 'ex14',
    title: 'Transformer un Flow',
    category: 'Flow',
    difficulty: 'Difficile',
    xp: 70,
    icon: Icons.waves_rounded,
    color: AppColors.secondary,
    prompt: 'Quel opérateur remplace le flux précédent ?',
    options: ['map', 'combine', 'flatMapLatest', 'catch'],
    correctIndex: 2,
    explanation:
        'flatMapLatest annule la collecte précédente et utilise le nouveau flux.',
  ),
  _exercise(
    id: 'ex15',
    title: 'État Compose',
    category: 'Android',
    difficulty: 'Moyen',
    xp: 50,
    icon: Icons.phone_android_rounded,
    color: AppColors.success,
    prompt: 'Quelle fonction survit à une recréation simple ?',
    options: [
      'mutableStateOf',
      'rememberSaveable',
      'derivedStateOf',
      'LaunchedEffect',
    ],
    correctIndex: 1,
    explanation: 'rememberSaveable sauvegarde les valeurs compatibles.',
  ),
  _exercise(
    id: 'ex16',
    title: 'Architecture ViewModel',
    category: 'Android',
    difficulty: 'Difficile',
    xp: 65,
    icon: Icons.account_tree_rounded,
    color: AppColors.success,
    prompt: 'Quelle exposition protège le MutableStateFlow ?',
    code: 'private val _state = MutableStateFlow(UiState())',
    options: [
      'val state = _state',
      'val state = _state.asStateFlow()',
      'var state = _state.value',
      'fun state() = mutableStateOf(_state)',
    ],
    correctIndex: 1,
    explanation: 'asStateFlow expose un StateFlow en lecture seule.',
  ),
];

const projects = <ProjectItem>[
  ProjectItem(
    id: 'calculator',
    title: 'Calculatrice',
    description:
        'Construisez une calculatrice en ligne de commande et maîtrisez les fonctions.',
    level: 'Débutant',
    duration: '1 h 30',
    tags: ['Fonctions', 'when'],
    color: AppColors.primary,
    icon: Icons.calculate_rounded,
  ),
  ProjectItem(
    id: 'hangman',
    title: 'Jeu du pendu',
    description:
        'Manipulez chaînes, boucles et collections dans un mini-jeu complet.',
    level: 'Débutant',
    duration: '3 h',
    tags: ['Collections', 'Boucles'],
    color: AppColors.secondary,
    icon: Icons.sports_esports_rounded,
  ),
  ProjectItem(
    id: 'todo',
    title: 'Todo Compose',
    description:
        'Une application Android soignée avec état, navigation et persistance.',
    level: 'Intermédiaire',
    duration: '8 h',
    tags: ['Compose', 'Room'],
    color: AppColors.success,
    icon: Icons.checklist_rounded,
  ),
  ProjectItem(
    id: 'bank',
    title: 'Banque Kotlin',
    description:
        'Appliquez POO, tests et architecture propre à un domaine réaliste.',
    level: 'Avancé',
    duration: '12 h',
    tags: ['Clean', 'Tests'],
    color: Color(0xFFFF8A65),
    icon: Icons.account_balance_rounded,
  ),
];
