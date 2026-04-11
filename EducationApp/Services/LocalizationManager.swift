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

        // Welcome Screen
        "Master your courses": ["Spanish": "Domina tus cursos", "French": "Maîtrisez vos cours", "German": "Meistere deine Kurse"],
        "with ease": ["Spanish": "con facilidad", "French": "avec facilité", "German": "mit Leichtigkeit"],
        "The friendly learning companion\nbuilt just for university students.": ["Spanish": "El compañero de aprendizaje amigable\ncreado para estudiantes universitarios.", "French": "Le compagnon d'apprentissage convivial\nconçu pour les étudiants universitaires.", "German": "Der freundliche Lernbegleiter\nspeziell für Studierende."],

        // Sign In Screen
        "Use your email and password to continue.": ["Spanish": "Usa tu correo y contraseña para continuar.", "French": "Utilisez votre e-mail et mot de passe pour continuer.", "German": "Verwende deine E-Mail und dein Passwort, um fortzufahren."],
        "Email": ["Spanish": "Correo electrónico", "French": "E-mail", "German": "E-Mail"],
        "Password": ["Spanish": "Contraseña", "French": "Mot de passe", "German": "Passwort"],

        // Create Account Screen
        "STUDENT ACCESS ONLY": ["Spanish": "SOLO ACCESO ESTUDIANTIL", "French": "ACCÈS ÉTUDIANTS UNIQUEMENT", "German": "NUR FÜR STUDIERENDE"],
        "Create Student\nAccount": ["Spanish": "Crear Cuenta\nEstudiantil", "French": "Créer un Compte\nÉtudiant", "German": "Studenten-\nKonto erstellen"],
        "Join your peers! Create your account to start learning.": ["Spanish": "¡Únete a tus compañeros! Crea tu cuenta para empezar.", "French": "Rejoignez vos pairs ! Créez votre compte pour commencer.", "German": "Schließe dich deinen Kommilitonen an! Erstelle dein Konto."],
        "First Name": ["Spanish": "Nombre", "French": "Prénom", "German": "Vorname"],
        "Last Name": ["Spanish": "Apellido", "French": "Nom", "German": "Nachname"],
        "Date of Birth": ["Spanish": "Fecha de nacimiento", "French": "Date de naissance", "German": "Geburtsdatum"],
        "Email Address": ["Spanish": "Correo electrónico", "French": "Adresse e-mail", "German": "E-Mail-Adresse"],
        "Choose Password": ["Spanish": "Elegir contraseña", "French": "Choisir un mot de passe", "German": "Passwort wählen"],
        "Confirm Password": ["Spanish": "Confirmar contraseña", "French": "Confirmer le mot de passe", "German": "Passwort bestätigen"],
        "Already part of the community?": ["Spanish": "¿Ya eres parte de la comunidad?", "French": "Déjà membre de la communauté ?", "German": "Bereits Teil der Community?"],
        "Log In": ["Spanish": "Iniciar sesión", "French": "Se connecter", "German": "Anmelden"],

        // Verify Email
        "Verify Your Email": ["Spanish": "Verifica tu correo", "French": "Vérifiez votre e-mail", "German": "E-Mail bestätigen"],
        "Verify & Continue": ["Spanish": "Verificar y continuar", "French": "Vérifier et continuer", "German": "Bestätigen und weiter"],
        "Resend Code": ["Spanish": "Reenviar código", "French": "Renvoyer le code", "German": "Code erneut senden"],
        "Didn't receive the code?": ["Spanish": "¿No recibiste el código?", "French": "Vous n'avez pas reçu le code ?", "German": "Code nicht erhalten?"],

        // Quiz
        "Quiz": ["Spanish": "Cuestionario", "French": "Quiz", "German": "Quiz"],
        "Next": ["Spanish": "Siguiente", "French": "Suivant", "German": "Weiter"],
        "Submit Quiz": ["Spanish": "Enviar cuestionario", "French": "Soumettre le quiz", "German": "Quiz abgeben"],
        "Quiz Complete!": ["Spanish": "¡Cuestionario completado!", "French": "Quiz terminé !", "German": "Quiz abgeschlossen!"],
        "Retake Quiz": ["Spanish": "Repetir cuestionario", "French": "Refaire le quiz", "German": "Quiz wiederholen"],
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
