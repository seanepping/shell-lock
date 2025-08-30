# Security Policy

## Reporting Security Vulnerabilities

**Please do not report security vulnerabilities through public GitHub issues.**

Instead, please report them via:

- **GitHub Security Advisories**: Use the [Security tab](https://github.com/seanepping/shell-lock/security) to privately report vulnerabilities
- **Email**: Send details to the repository maintainer
- **Security Issue Template**: For less critical issues, use our [Security Vulnerability template](.github/ISSUE_TEMPLATE/security-vulnerability.yml)

### What to Include

Include the following information:

- Type of issue (e.g. buffer overflow, injection, etc.)
- Full paths of source file(s) related to the manifestation of the issue
- Location of the affected source code (tag/branch/commit or direct URL)
- Any special configuration required to reproduce the issue
- Step-by-step instructions to reproduce the issue
- Proof-of-concept or exploit code (if possible)
- Impact of the issue, including how an attacker might exploit it

## Security Considerations

### Scope

Shell-Lock is designed to protect against:

- Shell configuration injection attacks
- Environment variable theft
- Credential exposure
- Backup tampering
- Unsafe recovery procedures

### Assumptions

Shell-Lock assumes:

- The host operating system is trusted
- The user has legitimate access to their own account
- System tools (gpg, ssh, etc.) are not compromised
- The file system supports proper permissions

### Limitations

Shell-Lock does NOT protect against:

- Kernel-level attacks
- Hardware-based attacks
- Side-channel attacks
- Attacks requiring root/admin privileges
- Network-based attacks (except where SSH is involved)

### Best Practices

When using Shell-Lock:

1. Keep your system updated
2. Use strong passphrases for SSH keys
3. Regularly audit your security configuration
4. Review backup integrity periodically
5. Test recovery procedures in safe environments

### Security Features

- **Cryptographic Integrity**: SHA-256 checksums for all backups
- **Secure Permissions**: 600/700 permissions for sensitive files
- **Environment Sanitization**: Clean emergency shell environments
- **Audit Trails**: Comprehensive logging of security events
- **Tamper Detection**: Real-time monitoring of configuration changes

## Threat Model

### Threats Mitigated

- **T1**: Malicious shell configuration injection
- **T2**: Environment variable credential theft
- **T3**: Backup file tampering
- **T4**: Unsafe recovery procedures
- **T5**: SSH key compromise (through passphrase protection)

### Attack Vectors Addressed

- Shell startup file modification (`.bashrc`, `.zshrc`, etc.)
- Environment variable manipulation
- Backup file replacement attacks
- Recovery command injection
- PATH manipulation attacks

### Out of Scope

- Privileged escalation attacks
- Hardware security modules
- Air-gapped environments
- Multi-user system protections (beyond file permissions)

## Security Update Policy

Security updates will be:

- Released as soon as possible after discovery
- Clearly marked with [SECURITY] in release notes
- Accompanied by CVE identifiers when applicable
- Documented with impact assessment and mitigation steps

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Acknowledgments

We appreciate responsible disclosure of security vulnerabilities. Contributors who report valid security issues will be acknowledged in release notes (unless they prefer to remain anonymous).
