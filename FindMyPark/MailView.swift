//
//  MailView.swift
//  FindMyPark
//
//  Created by Gary Clemente on 12/2/25.
//

import SwiftUI
import MessageUI

struct MailView: UIViewControllerRepresentable {
    var subject: String
    var body: String
    var to: String

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mail = MFMailComposeViewController()
        mail.setSubject(subject)
        mail.setMessageBody(body, isHTML: false)
        mail.setToRecipients([to])
        return mail
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
}
