// SMTPConnectionTimeouts.swift
// Configurable timeout budgets for SMTP connection setup.

import Foundation

/// Timeout budgets for setting up an SMTP connection in ``SMTPServer/connect()``.
///
/// The same names as upstream SwiftMail's (#256, from 1.16), but the defaults are
/// 1.14's fixed waits (5, 30 and 10 seconds), so nothing changes unless a caller
/// asks. Upstream's defaults follow RFC 5321 section 4.5.3.2.1, which recommends
/// waiting five minutes for the greeting.
public struct SMTPConnectionTimeouts: Sendable, Equatable {
    /// Maximum time to wait for the server's greeting once the TCP connection
    /// is open. With implicit TLS this includes the TLS handshake.
    public let greeting: TimeInterval

    /// Maximum time to wait for the reply to each `EHLO`, including the one
    /// sent again after `STARTTLS`. Rounded up to whole seconds.
    public let ehloResponse: TimeInterval

    /// Maximum time to wait for the reply to `STARTTLS`. Rounded up to whole seconds.
    public let startTLSResponse: TimeInterval

    /// Creates SMTP connection timeout budgets, expressed in seconds.
    public init(
        greeting: TimeInterval = 5,
        ehloResponse: TimeInterval = 30,
        startTLSResponse: TimeInterval = 10
    ) {
        precondition(
            [greeting, ehloResponse, startTLSResponse].allSatisfy { $0.isFinite && $0 > 0 && $0 <= 86_400 },
            "SMTP connection timeouts must be positive and at most a day"
        )
        self.greeting = greeting
        self.ehloResponse = ehloResponse
        self.startTLSResponse = startTLSResponse
    }

    /// A budget as the whole seconds `SMTPCommand.timeoutSeconds` takes, rounded up.
    static func wholeSeconds(_ seconds: TimeInterval) -> Int { Int(seconds.rounded(.up)) }
}
