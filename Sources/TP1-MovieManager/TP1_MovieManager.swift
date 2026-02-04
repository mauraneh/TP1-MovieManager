@main
struct TP1_MovieManager {
    static func main() {
        var movies: [(title: String, year: Int, rating: Double, genre: String)] = [
            (title: "Inception", year: 2010, rating: 8.8, genre: "Sci-Fi"),
            (title: "The Dark Knight", year: 2008, rating: 9.0, genre: "Action"),
            (title: "Interstellar", year: 2014, rating: 8.6, genre: "Sci-Fi"),
            (title: "Parasite", year: 2019, rating: 8.6, genre: "Drama"),
            (title: "The Grand Budapest Hotel", year: 2014, rating: 8.1, genre: "Comedy"),
            (title: "Get Out", year: 2017, rating: 7.7, genre: "Horror"),
            (title: "Whiplash", year: 2014, rating: 8.5, genre: "Drama"),
            (title: "The Matrix", year: 1999, rating: 8.7, genre: "Sci-Fi"),
            (title: "Toy Story", year: 1995, rating: 8.3, genre: "Animation"),
            (title: "Mad Max: Fury Road", year: 2015, rating: 8.1, genre: "Action"),
            (title: "The Godfather", year: 1972, rating: 9.2, genre: "Crime")
        ]

        runApp(movies: &movies)
    }
}

typealias Movie = (title: String, year: Int, rating: Double, genre: String)

func displayMovie(_ movie: Movie) {
    print("- \(movie.title) (\(movie.year)) - \(movie.genre)")
    print("  Note: \(movie.rating)/10")
}

func addMovie(title: String, year: Int, rating: Double, genre: String, to movies: inout [Movie]) {
    movies.append((title: title, year: year, rating: rating, genre: genre))
}

func findMovie(byTitle title: String, in movies: [Movie]) -> Movie? {
    let needle = title.lowercased()
    return movies.first { $0.title.lowercased() == needle }
}

func filterMovies(_ movies: [Movie], matching criteria: (Movie) -> Bool) -> [Movie] {
    movies.filter(criteria)
}

func getUniqueGenres(from movies: [Movie]) -> Set<String> {
    Set(movies.map { $0.genre })
}

func averageRating(of movies: [Movie]) -> Double {
    guard !movies.isEmpty else { return 0.0 }
    let total = movies.map { $0.rating }.reduce(0.0, +)
    return total / Double(movies.count)
}

func bestMovie(in movies: [Movie]) -> Movie? {
    movies.max { $0.rating < $1.rating }
}

func moviesByDecade(_ movies: [Movie]) -> [String: [Movie]] {
    var grouped: [String: [Movie]] = [:]
    for movie in movies {
        let decade = "\(movie.year / 10 * 10)s"
        grouped[decade, default: []].append(movie)
    }
    return grouped
}

func displayMenu() {
    print("\n=== Movie Manager (sans spoilers) ===")
    print("1. Afficher tous les films")
    print("2. Rechercher un film")
    print("3. Filtrer par genre")
    print("4. Afficher les statistiques")
    print("5. Ajouter un film")
    print("6. Quitter")
}

func runApp(movies: inout [Movie]) {
    var shouldRun = true

    while shouldRun {
        displayMenu()
        print("Votre choix: ", terminator: "")
        let choice = readLine() ?? ""

        switch choice {
        case "1":
            if movies.isEmpty {
                print("Aucun film disponible. Meme pas un court-metrage.")
            } else {
                movies.forEach { displayMovie($0) }
            }

        case "2":
            print("Titre a rechercher: ", terminator: "")
            let title = readLine() ?? ""
            if let movie = findMovie(byTitle: title, in: movies) {
                displayMovie(movie)
            } else {
                print("Film non trouve. Peut-etre un film imaginaire ?")
            }

        case "3":
            let genres = Array(getUniqueGenres(from: movies)).sorted()
            if genres.isEmpty {
                print("Aucun genre disponible.")
                break
            }
            print("Genres disponibles: \(genres.joined(separator: ", "))")
            print("Entrez un genre: ", terminator: "")
            let inputGenre = readLine() ?? ""
            let filtered = filterMovies(movies) { $0.genre.lowercased() == inputGenre.lowercased() }
            if filtered.isEmpty {
                print("Aucun film pour ce genre. On va dire que c'est un genre rare.")
            } else {
                filtered.forEach { displayMovie($0) }
            }

        case "4":
            print("Nombre total de films: \(movies.count)")
            let avg = averageRating(of: movies)
            print("Note moyenne: \(avg)/10")
            if let top = bestMovie(in: movies) {
                print("Meilleur film:")
                displayMovie(top)
            } else {
                print("Meilleur film: N/A")
            }
            let byDecade = moviesByDecade(movies)
            if !byDecade.isEmpty {
                print("Films par decennie:")
                for decade in byDecade.keys.sorted() {
                    let titles = byDecade[decade, default: []].map { $0.title }.joined(separator: ", ")
                    print("- \(decade): \(titles)")
                }
            }

        case "5":
            print("Titre: ", terminator: "")
            let title = readLine() ?? ""

            print("Annee: ", terminator: "")
            let yearInput = readLine() ?? ""
            let year = Int(yearInput) ?? 0

            print("Note (0-10): ", terminator: "")
            let ratingInput = readLine() ?? ""
            let rating = Double(ratingInput) ?? 0.0

            print("Genre: ", terminator: "")
            let genre = readLine() ?? ""

            addMovie(title: title, year: year, rating: rating, genre: genre, to: &movies)
            print("Film ajoute. Pas de popcorn inclus.")

        case "6":
            shouldRun = false
            print("Au revoir ! Fin du generique.")

        default:
            print("Choix invalide. Essaie encore, personne ne juge.")
        }
    }
}
