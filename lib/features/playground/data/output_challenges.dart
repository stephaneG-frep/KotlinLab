import '../domain/output_challenge.dart';

const outputChallenges = <OutputChallenge>[
  OutputChallenge(
    id: 'templates',
    title: 'Templates de chaînes',
    level: 'Débutant',
    code: r'''fun main() {
    val name = "Kotlin"
    println("Bonjour, $name !")
    println("${name.length} lettres")
}''',
    output: 'Bonjour, Kotlin !\n6 lettres',
    explanation:
        r'$name insère la valeur de la variable ; ${…} évalue une expression complète, ici name.length qui vaut 6.',
  ),
  OutputChallenge(
    id: 'val_var',
    title: 'val et var',
    level: 'Débutant',
    code: r'''fun main() {
    var count = 1
    count += 2
    val doubled = count * 2
    println("$count $doubled")
}''',
    output: '3 6',
    explanation:
        'count est un var : il passe de 1 à 3. doubled est calculé une seule fois à partir de la valeur courante, soit 6.',
  ),
  OutputChallenge(
    id: 'division',
    title: 'Division entière',
    level: 'Débutant',
    code: '''fun main() {
    println(7 / 2)
    println(7 % 2)
    println(7 / 2.0)
}''',
    output: '3\n1\n3.5',
    explanation:
        'Entre deux Int, / est une division entière (3) et % donne le reste (1). Dès qu’un opérande est un Double, le résultat est un Double : 3.5.',
  ),
  OutputChallenge(
    id: 'when',
    title: 'Expression when',
    level: 'Débutant',
    code: '''fun label(n: Int) = when {
    n < 0 -> "négatif"
    n == 0 -> "zéro"
    n % 2 == 0 -> "pair"
    else -> "impair"
}

fun main() {
    println(label(0))
    println(label(7))
    println(label(-4))
}''',
    output: 'zéro\nimpair\nnégatif',
    explanation:
        'when teste les branches dans l’ordre et s’arrête à la première vraie. -4 est pair, mais la branche n < 0 passe avant.',
  ),
  OutputChallenge(
    id: 'ranges',
    title: 'Intervalles',
    level: 'Débutant',
    code: r'''fun main() {
    for (i in 1..3) print(i)
    println()
    for (i in 10 downTo 0 step 4) print("$i ")
}''',
    output: '123\n10 6 2',
    explanation:
        '1..3 inclut ses deux bornes et print n’ajoute pas de retour à la ligne. 10 downTo 0 step 4 produit 10, 6 puis 2 : la valeur suivante, -2, sort de l’intervalle.',
  ),
  OutputChallenge(
    id: 'strings',
    title: 'Fonctions de String',
    level: 'Débutant',
    code: '''fun main() {
    val word = "kotlin"
    println(word.uppercase())
    println(word.reversed())
    println(word.first())
}''',
    output: 'KOTLIN\nniltok\nk',
    explanation:
        'Les String sont immuables : uppercase() et reversed() renvoient de nouvelles chaînes. first() renvoie le premier Char.',
  ),
  OutputChallenge(
    id: 'null_safety',
    title: 'Null safety',
    level: 'Intermédiaire',
    code: '''fun main() {
    val city: String? = null
    println(city?.length)
    println(city?.length ?: 0)
    println(city ?: "inconnue")
}''',
    output: 'null\n0\ninconnue',
    explanation:
        '?. court-circuite et renvoie null au lieu de lever une exception. L’opérateur Elvis ?: fournit une valeur de repli quand la gauche est null.',
  ),
  OutputChallenge(
    id: 'filter_map',
    title: 'filter puis map',
    level: 'Intermédiaire',
    code: '''fun main() {
    val numbers = listOf(1, 2, 3, 4, 5)
    val result = numbers.filter { it % 2 == 1 }.map { it * 10 }
    println(result)
    println(result.sum())
}''',
    output: '[10, 30, 50]\n90',
    explanation:
        'filter garde 1, 3 et 5, puis map les multiplie par 10. Une List s’affiche entre crochets, et la somme vaut 90.',
  ),
  OutputChallenge(
    id: 'data_class',
    title: 'Data class et copy',
    level: 'Intermédiaire',
    code: '''data class User(val name: String, val age: Int)

fun main() {
    val ada = User("Ada", 36)
    val older = ada.copy(age = 37)
    println(older)
    println(ada == User("Ada", 36))
}''',
    output: 'User(name=Ada, age=37)\ntrue',
    explanation:
        'Une data class génère toString au format Nom(prop=valeur), et equals compare les propriétés : deux User identiques sont égaux avec ==.',
  ),
  OutputChallenge(
    id: 'extension',
    title: 'Fonction d’extension',
    level: 'Intermédiaire',
    code: '''fun String.shout() = uppercase() + "!"

fun main() {
    println("salut".shout())
}''',
    output: 'SALUT!',
    explanation:
        'Dans une extension, this est la chaîne receveuse : uppercase() s’applique donc à "salut".',
  ),
  OutputChallenge(
    id: 'fold',
    title: 'fold',
    level: 'Intermédiaire',
    code: '''fun main() {
    val total = listOf(3, 4, 5).fold(0) { acc, n -> acc + n * n }
    println(total)
}''',
    output: '50',
    explanation:
        'fold part de 0 et ajoute le carré de chaque élément : 9 + 16 + 25 = 50.',
  ),
  OutputChallenge(
    id: 'scope_functions',
    title: 'apply et let',
    level: 'Intermédiaire',
    code: '''fun main() {
    val list = mutableListOf(1, 2).apply { add(3) }
    val size = list.let { it.size * 2 }
    println(list)
    println(size)
}''',
    output: '[1, 2, 3]\n6',
    explanation:
        'apply exécute le bloc sur l’objet puis renvoie l’objet lui-même. let renvoie le résultat du bloc : 3 × 2 = 6.',
  ),
  OutputChallenge(
    id: 'sealed',
    title: 'Interface scellée',
    level: 'Avancé',
    xp: 30,
    code: r'''sealed interface Result
data class Success(val value: Int) : Result
data class Failure(val reason: String) : Result

fun describe(r: Result) = when (r) {
    is Success -> "OK : ${r.value}"
    is Failure -> "Erreur : ${r.reason}"
}

fun main() {
    println(describe(Success(42)))
    println(describe(Failure("réseau")))
}''',
    output: 'OK : 42\nErreur : réseau',
    explanation:
        'Le compilateur connaît tous les sous-types d’une interface scellée : when est exhaustif sans else, et le smart cast donne accès à value ou reason.',
  ),
  OutputChallenge(
    id: 'group_by',
    title: 'groupBy',
    level: 'Avancé',
    xp: 30,
    code: '''fun main() {
    val words = listOf("ane", "bus", "arc", "cle")
    println(words.groupBy { it.first() })
}''',
    output: '{a=[ane, arc], b=[bus], c=[cle]}',
    explanation:
        'groupBy renvoie une Map qui conserve l’ordre d’apparition des clés. Une Map s’affiche entre accolades au format clé=valeur.',
  ),
  OutputChallenge(
    id: 'lazy',
    title: 'init et lazy',
    level: 'Avancé',
    xp: 30,
    code: '''class Counter {
    init { println("init") }
    val value by lazy {
        println("calcul")
        42
    }
}

fun main() {
    val c = Counter()
    println("créé")
    println(c.value)
    println(c.value)
}''',
    output: 'init\ncréé\ncalcul\n42\n42',
    explanation:
        'Le bloc init s’exécute à la construction. lazy ne calcule la valeur qu’au premier accès, puis la met en cache : « calcul » ne s’affiche qu’une fois.',
  ),
  OutputChallenge(
    id: 'coroutines',
    title: 'launch et delay',
    level: 'Avancé',
    xp: 30,
    code: '''import kotlinx.coroutines.*

fun main() = runBlocking {
    launch {
        delay(100)
        println("B")
    }
    println("A")
}''',
    output: 'A\nB',
    explanation:
        'launch démarre une coroutine sans bloquer : main affiche A tout de suite. runBlocking attend la fin de ses coroutines enfants, donc B s’affiche après le delay.',
  ),
];
