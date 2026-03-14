import Foundation
import Combine

class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()

    @Published var currentLanguage: String = "English"

    private let translations: [String: [String: String]] = [
        // Tab Bar
        "Home": ["Spanish": "Inicio", "French": "Accueil", "German": "Startseite"],
        "Catalog": ["Spanish": "Catálogo", "French": "Catalogue", "German": "Katalog"],
        "Saved": ["Spanish": "Guardados", "French": "Enregistrés", "German": "Gespeichert"],
        "Profile": ["Spanish": "Perfil", "French": "Profil", "German": "Profil"],

        // Home Dashboard
        "Ready for a super productive day?": ["Spanish": "¿Listo para un día súper productivo?", "French": "Prêt pour une journée super productive ?", "German": "Bereit für einen super produktiven Tag?"],
        "Keep Going!": ["Spanish": "¡Sigue así!", "French": "Continuez !", "German": "Weiter so!"],
        "Don't Forget!": ["Spanish": "¡No olvides!", "French": "N'oubliez pas !", "German": "Nicht vergessen!"],
        "See All": ["Spanish": "Ver todo", "French": "Voir tout", "German": "Alle anzeigen"],
        "Browse Catalog": ["Spanish": "Explorar catálogo", "French": "Parcourir le catalogue", "German": "Katalog durchsuchen"],
        "Jump back in": ["Spanish": "Continuar", "French": "Reprendre", "German": "Weitermachen"],
        "No courses yet": ["Spanish": "Aún no hay cursos", "French": "Pas encore de cours", "German": "Noch keine Kurse"],
        "Your Week": ["Spanish": "Tu semana", "French": "Votre semaine", "German": "Deine Woche"],
        "Keep it up!": ["Spanish": "¡Sigue así!", "French": "Continuez !", "German": "Weiter so!"],
        "Let's go!": ["Spanish": "¡Vamos!", "French": "Allons-y !", "German": "Los geht's!"],
        "All caught up!": ["Spanish": "¡Todo al día!", "French": "Tout est à jour !", "German": "Alles erledigt!"],

        // Course Catalog
        "Course Catalog": ["Spanish": "Catálogo de cursos", "French": "Catalogue de cours", "German": "Kurskatalog"],
        "What do you want to learn today?": ["Spanish": "¿Qué quieres aprender hoy?", "French": "Qu'aimeriez-vous apprendre aujourd'hui ?", "German": "Was möchtest du heute lernen?"],
        "All": ["Spanish": "Todo", "French": "Tout", "German": "Alle"],
        "Enroll Now": ["Spanish": "Inscribirse", "French": "S'inscrire", "German": "Einschreiben"],
        "Enrolled": ["Spanish": "Inscrito", "French": "Inscrit", "German": "Eingeschrieben"],
        "No courses found": ["Spanish": "No se encontraron cursos", "French": "Aucun cours trouvé", "German": "Keine Kurse gefunden"],

        // Course Details
        "Start Learning": ["Spanish": "Empezar a aprender", "French": "Commencer à apprendre", "German": "Lernen starten"],
        "Resume Learning": ["Spanish": "Continuar aprendiendo", "French": "Reprendre l'apprentissage", "German": "Lernen fortsetzen"],
        "Course Completed!": ["Spanish": "¡Curso completado!", "French": "Cours terminé !", "German": "Kurs abgeschlossen!"],
        "Key Objectives": ["Spanish": "Objetivos clave", "French": "Objectifs clés", "German": "Hauptziele"],
        "Course Modules": ["Spanish": "Módulos del curso", "French": "Modules du cours", "German": "Kursmodule"],

        // Saved Courses
        "Saved Courses": ["Spanish": "Cursos guardados", "French": "Cours enregistrés", "German": "Gespeicherte Kurse"],
        "Your bookmarked learning materials": ["Spanish": "Tus materiales de aprendizaje guardados", "French": "Vos supports d'apprentissage enregistrés", "German": "Deine gespeicherten Lernmaterialien"],
        "No Saved Courses Yet": ["Spanish": "Aún no hay cursos guardados", "French": "Pas encore de cours enregistrés", "German": "Noch keine gespeicherten Kurse"],
        "Bookmark courses to save them for later": ["Spanish": "Guarda cursos para verlos después", "French": "Enregistrez des cours pour plus tard", "German": "Kurse zum Speichern markieren"],

        // Profile
        "Learning Stats": ["Spanish": "Estadísticas", "French": "Statistiques", "German": "Lernstatistiken"],
        "Courses Enrolled": ["Spanish": "Cursos inscritos", "French": "Cours inscrits", "German": "Eingeschriebene Kurse"],
        "Completed": ["Spanish": "Completados", "French": "Terminés", "German": "Abgeschlossen"],
        "Lessons Done": ["Spanish": "Lecciones hechas", "French": "Leçons terminées", "German": "Lektionen erledigt"],
        "Settings": ["Spanish": "Ajustes", "French": "Paramètres", "German": "Einstellungen"],
        "Notifications": ["Spanish": "Notificaciones", "French": "Notifications", "German": "Benachrichtigungen"],
        "Dark Mode": ["Spanish": "Modo oscuro", "French": "Mode sombre", "German": "Dunkelmodus"],
        "Language": ["Spanish": "Idioma", "French": "Langue", "German": "Sprache"],
        "Privacy": ["Spanish": "Privacidad", "French": "Confidentialité", "German": "Datenschutz"],
        "Sign Out": ["Spanish": "Cerrar sesión", "French": "Se déconnecter", "German": "Abmelden"],

        // Lesson View
        "Study Notes": ["Spanish": "Notas de estudio", "French": "Notes d'étude", "German": "Lernnotizen"],
        "MARK AS COMPLETE": ["Spanish": "MARCAR COMO COMPLETADO", "French": "MARQUER COMME TERMINÉ", "German": "ALS ABGESCHLOSSEN MARKIEREN"],
        "COMPLETED": ["Spanish": "COMPLETADO", "French": "TERMINÉ", "German": "ABGESCHLOSSEN"],

        // Sign In / Create Account
        "Sign In": ["Spanish": "Iniciar sesión", "French": "Se connecter", "German": "Anmelden"],
        "Create Student Account": ["Spanish": "Crear cuenta de estudiante", "French": "Créer un compte étudiant", "German": "Studentenkonto erstellen"],
        "Create Account": ["Spanish": "Crear cuenta", "French": "Créer un compte", "German": "Konto erstellen"],
    ]

    func localized(_ key: String) -> String {
        if currentLanguage == "English" { return key }
        return translations[key]?[currentLanguage] ?? key
    }

    func loadLanguage() {
        let prefs = DataPersistenceManager.shared.loadPreferences()
        currentLanguage = prefs.language
    }
}
