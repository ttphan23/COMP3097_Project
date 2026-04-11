import Foundation
import Combine

class EmailVerificationService: ObservableObject {
    static let shared = EmailVerificationService()

    // MARK: - Configuration
    private let apiKey = "re_LsRJ1Tb4_8AAJonAgHqpk7cqNhH5rVoLc"
    private let senderEmail = "onboarding@resend.dev"
    private let senderName = "EduVantage"

    @Published var verificationCode: String = ""
    @Published var isCodeSent: Bool = false
    @Published var isVerified: Bool = false
    @Published var isSending: Bool = false
    @Published var sendError: String? = nil

    private init() {}

    func generateCode() -> String {
        let code = String(format: "%06d", Int.random(in: 0...999999))
        verificationCode = code
        isVerified = false
        return code
    }

    func verifyCode(_ inputCode: String) -> Bool {
        let match = inputCode.trimmingCharacters(in: .whitespacesAndNewlines) == verificationCode
        if match {
            isVerified = true
        }
        return match
    }

    func reset() {
        verificationCode = ""
        isCodeSent = false
        isVerified = false
        isSending = false
        sendError = nil
    }

    // MARK: - Send verification email via Resend API
    func sendVerificationEmail(to recipientEmail: String, completion: @escaping (Bool) -> Void) {
        let code = generateCode()
        isSending = true
        sendError = nil

        let url = URL(string: "https://api.resend.com/emails")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let htmlContent = """
        <div style="font-family: -apple-system, Arial, sans-serif; max-width: 480px; margin: 0 auto; padding: 32px;">
            <h2 style="color: #1a1a2e; margin-bottom: 8px;">Welcome to EduVantage!</h2>
            <p style="color: #555; font-size: 15px;">Use the verification code below to complete your registration:</p>
            <div style="background: #f0f4ff; border-radius: 12px; padding: 24px; text-align: center; margin: 24px 0;">
                <span style="font-size: 36px; font-weight: bold; letter-spacing: 8px; color: #2563eb;">\(code)</span>
            </div>
            <p style="color: #888; font-size: 13px;">This code will expire when you leave the verification screen.</p>
            <p style="color: #888; font-size: 13px;">If you did not request this code, please ignore this email.</p>
            <hr style="border: none; border-top: 1px solid #eee; margin: 24px 0;">
            <p style="color: #aaa; font-size: 12px;">- The EduVantage Team</p>
        </div>
        """

        let emailBody: [String: Any] = [
            "from": "\(senderName) <\(senderEmail)>",
            "to": [recipientEmail],
            "subject": "EduVantage - Your Verification Code: \(code)",
            "html": htmlContent
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: emailBody)

        URLSession.shared.dataTask(with: request) { [weak self] _, response, error in
            DispatchQueue.main.async {
                self?.isSending = false

                if let error = error {
                    self?.sendError = error.localizedDescription
                    completion(false)
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    if (200...299).contains(httpResponse.statusCode) {
                        self?.isCodeSent = true
                        self?.sendError = nil
                        completion(true)
                    } else {
                        self?.sendError = "Failed to send email (code: \(httpResponse.statusCode)). Check your API key."
                        completion(false)
                    }
                } else {
                    self?.sendError = "Unexpected response from email service."
                    completion(false)
                }
            }
        }.resume()
    }
}
