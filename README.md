# 🔐 Shell-Lock: Comprehensive Shell Security Hardening Toolkit

A portable security toolkit for hardening development environments against shell-based attacks, credential theft, and environment variable vulnerabilities.

## 🎯 Project Overview

**Shell-Lock** provides enterprise-grade security for developer workstations by implementing defense-in-depth protection across all shell entry points and development tools.

### 🚨 Problem Statement

Modern development environments face numerous security threats:

- **Plain-text credential storage** (GitHub CLI, cloud tools)
- **Environment variable theft** via compromised shells
- **Shell configuration injection** attacks
- **Unprotected backup and recovery** mechanisms
- **Multiple shell entry points** (zsh, bash, profile, etc.)
- **WSL-specific vulnerabilities** and PATH manipulation

### ✅ Solution Features

- **Multi-Shell Protection**: Comprehensive coverage of all shell entry points
- **Secure Credential Storage**: GPG-encrypted credential management
- **SSH Security**: Passphrase-protected key generation and management
- **Integrity Verification**: Cryptographic backup verification with SHA-256
- **WSL Compatibility**: Windows Subsystem for Linux aware monitoring
- **Emergency Recovery**: Sanitized emergency shell environments
- **Audit Trails**: Comprehensive logging and monitoring

## 🚀 Quick Start

```bash
# Clone and install
git clone <repo-url> ~/dev/shell-lock
cd ~/dev/shell-lock
./install.sh

# Basic hardening
shell-lock setup

# Create secure backups
shell-lock backup-all

# Run security audit
shell-lock audit
```

**⚠️ Important:** After making legitimate changes to your shell configs, update the integrity baseline:

```bash
rm ~/.local/share/file-integrity.txt && shell-lock audit
```

**📖 For detailed usage instructions, see:** `docs/USAGE_GUIDE.md`

## 📁 Project Structure

```ascii
shell-lock/
├── README.md                 # This file
├── install.sh               # Main installation script
├── scripts/                 # Core security scripts
│   ├── secure-setup         # Initial system hardening
│   ├── secure-recovery      # Backup/recovery with integrity
│   ├── security-check       # Comprehensive security audit
│   └── dev-startup          # Secure development environment
├── templates/               # Configuration templates
│   ├── zshrc.template       # Secure zsh configuration
│   ├── bashrc.template      # Secure bash configuration
│   └── ssh-config.template  # SSH security configuration
├── docs/                    # Documentation
│   ├── INSTALLATION.md      # Installation guide
│   ├── SECURITY_GUIDE.md    # Security features explained
│   ├── RECOVERY_GUIDE.md    # Emergency recovery procedures
│   └── TROUBLESHOOTING.md   # Common issues and solutions
└── examples/                # Example configurations
    ├── wsl-setup.sh         # WSL-specific setup
    └── cloud-creds.sh       # Cloud credential hardening
```

## 🛡️ Security Features

### 1. Multi-Shell Entry Point Protection

- **Zsh**: Primary shell with security integration
- **Bash**: Secondary shell protection
- **POSIX shells**: Profile-based protection
- **Login shells**: Login-specific configurations
- **System-wide**: Monitoring of system configurations

### 2. Secure Credential Management

- **GPG Encryption**: AES256 symmetric encryption for secrets
- **SSH Key Security**: Ed25519 keys with mandatory passphrases
- **GitHub CLI**: Secure SSH-based authentication
- **Cloud Tools**: Protected credential storage

### 3. Integrity Verification System

- **SHA-256 Checksums**: Cryptographic verification of all backups
- **Tamper Detection**: Real-time monitoring of configuration changes
- **Atomic Operations**: Safe backup and restoration procedures
- **Audit Trails**: Comprehensive logging of all security events

### 4. WSL-Specific Protections

- **Windows PATH Exclusion**: Security checks ignore `/mnt/c/` paths
- **Cross-platform Compatibility**: Works in both WSL and native Linux
- **WSL-aware Monitoring**: Focused on Linux-side security

## 🔧 Core Tools

### `shell-lock` - Main Command Interface

```bash
shell-lock setup           # Initial security setup
shell-lock backup-all      # Create secure backups
shell-lock restore-zsh     # Restore shell configuration
shell-lock audit           # Run security audit
shell-lock emergency       # Emergency clean shell
shell-lock verify          # Verify backup integrity
```

### `security-check` - Comprehensive Security Audit

- File integrity monitoring
- Shell security validation
- Suspicious command detection
- Permission verification
- Threat detection and reporting

### `secure-recovery` - Tamper-Resistant Recovery

- Cryptographic integrity verification
- Secure file permissions (600/700)
- Clean emergency environments
- Comprehensive audit trails
- Atomic operations with rollback

## 📊 Security Coverage Matrix

| Attack Vector          | Protection Method         | Detection            |
| ---------------------- | ------------------------- | -------------------- |
| Shell config injection | File integrity monitoring | ✅ Real-time         |
| Environment poisoning  | Shell security checks     | ✅ Session startup   |
| Credential theft       | GPG encryption            | ✅ Access control    |
| PATH manipulation      | PATH validation           | ✅ Startup scan      |
| Backup tampering       | SHA-256 verification      | ✅ Active monitoring |
| Recovery attacks       | Integrity verification    | ✅ Pre-restoration   |

## 🔄 Recovery Procedures

### Emergency Access

```bash
# Clean emergency shell
/usr/bin/env -i HOME="$HOME" USER="$USER" \
  PATH="/usr/local/bin:/usr/bin:/bin" TERM="$TERM" \
  /bin/bash --norc --noprofile

# Or use shell-lock
shell-lock emergency
```

### Configuration Restoration

```bash
# Restore specific shell
shell-lock restore-zsh

# Verify restoration
shell-lock verify

# Full system restoration
shell-lock restore-all
```

## 🌍 Platform Support

- ✅ **Linux** (Ubuntu, Debian, RHEL, etc.)
- ✅ **WSL** (Windows Subsystem for Linux)
- ✅ **macOS** (with minor adaptations)
- 🔄 **FreeBSD** (planned)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Test on multiple platforms
4. Submit a pull request with security impact analysis

## 📜 License

MIT License - See LICENSE file for details

## ⚠️ Security Notice

This toolkit implements security measures based on real-world attack scenarios. Always test in a non-production environment first and ensure you understand the implications of each security control.

## 📞 Support

- **Documentation**: See `docs/` directory
- **Issues**: GitHub Issues for bug reports
- **Security**: For security vulnerabilities, see SECURITY.md

---

**🔒 Secure your development environment before it's too late.**
