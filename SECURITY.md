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

# Security Policy

## Reporting Security Vulnerabilities

**Please do not report security vulnerabilities through public GitHub issues.**

Instead, please report them via:

- **GitHub Security Advisories**: Use the [Security tab](https://github.com/seanepping/shell-lock/security) to privately report vulnerabilities
- **Email**: Send details to me directly
- **Security Issue Template**: For less critical issues, use the Security Vulnerability template

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

Shell-Lock is designed to help with:

- Basic shell configuration monitoring
- Encrypted credential storage
- Simple backup verification
- Emergency shell access

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
- Most advanced security threats

### Best Practices

When using Shell-Lock:

1. Keep your system updated
2. Use strong passphrases for SSH keys
3. Regularly run security checks manually
4. Review backup integrity periodically
5. Test recovery procedures in safe environments

### Actual Security Features

- **Basic File Integrity**: SHA-256 checksums for backup files (when manually run)
- **Secure Permissions**: 600/700 permissions for sensitive files
- **Clean Emergency Shells**: Simple clean environment commands
- **Basic Input Validation**: Limited sanitization in included scripts
- **GPG Encryption**: Standard GPG encryption for credential storage

## What Shell-Lock Actually Does

### Tools Provided

- **T1**: Basic shell configuration integrity checking (manual)
- **T2**: GPG-encrypted credential storage
- **T3**: SHA-256 backup file verification
- **T4**: Simple emergency shell access
- **T5**: Input validation in included scripts

### Specific Functions

- Shell startup file monitoring (`.bashrc`, `.zshrc`, etc.) when manually run
- Encrypted credential storage using standard GPG
- Backup file verification with checksums
- Clean emergency shell environments
- Basic input sanitization

### Out of Scope

- Real-time monitoring or detection
- Comprehensive security protection
- Advanced threat detection
- Automated responses
- Multi-user system protections
- Network security
- System-level security

## Security Update Policy

Security updates will be:

- Released as soon as possible after I discover or receive reports
- Clearly marked with [SECURITY] in release notes
- Accompanied by CVE identifiers when applicable
- Documented with impact assessment and mitigation steps

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Acknowledgments

I appreciate responsible disclosure of security vulnerabilities. Contributors who report  
valid security issues will be acknowledged in release notes (unless they prefer to remain anonymous).
