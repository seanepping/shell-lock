# 🔐 Shell-Lock: Shell Security Enhancement Toolkit

Security tools for development environments, providing encrypted credential storage and shell configuration protection.

## 🎯 Project Overview

**Shell-Lock** provides security tools for developer workstations, focusing on encrypted  
credential storage and shell configuration monitoring. This toolkit includes features  
that may help with some common development security concerns.

### 💡 Project Origin

I created this project after discovering that GitHub CLI was storing my authentication token  
in plain text. This led me to realize there were several basic security practices I could  
improve in my development environment:

- Plain-text credential storage in various tools
- No integrity checking for shell configuration files
- Insecure backup and recovery practices
- No encrypted storage for API keys and tokens

Shell-Lock is my solution for addressing these specific issues with simple, auditable tools.

## 🎯 What Shell-Lock Actually Does

**Primary Functions:**

- **Encrypted Credential Storage**: GPG-based encryption for tokens and API keys
- **Shell Configuration Monitoring**: Basic integrity checking for shell configs
- **GitHub CLI Wrapper**: Secure wrapper using encrypted credential storage
- **Emergency Shell Access**: Clean shell environments for troubleshooting

## 🚨 Security Areas Addressed

Shell-Lock provides tools that may help with:

- ✅ **Credential Theft**: Replaces plain-text credential storage with GPG encryption
- ✅ **Backup Tampering**: Cryptographic verification of backup files
- ⚠️ **Shell Configuration Changes**: Basic integrity monitoring and restoration
- ⚠️ **Input Validation**: Limited protection against injection in included scripts

## ⚠️ What Shell-Lock Does NOT Protect Against

**Important Limitations:**

- ❌ **Social Engineering**: Only basic input validation, not comprehensive protection
- ❌ **Supply Chain Attacks**: No specific supply chain protections
- ❌ **Environment Variable Attacks**: Minimal protection
- ❌ **PATH Manipulation**: No comprehensive PATH protection
- ❌ **Most Security Vulnerabilities**: This is a limited toolkit, not a security suite

## 🔧 Tested Environments

**Shell-Lock has been tested on:**

- ✅ **WSL2** (Windows Subsystem for Linux 2)
- ✅ **Ubuntu** (tested on available versions)

**Community testing welcome for:**

- 🔄 **Other Linux distributions** - May work but requires community verification
- 🔄 **macOS** - Community feedback appreciated
- 🔄 **BSD systems** - Community testing needed

**We welcome community contributions, testing reports, and feedback for expanding  
platform support. Please share your testing results via GitHub issues.**

**Shell Compatibility:**

- ✅ **Zsh** - Primary shell with feature support
- ✅ **Bash** - Compatibility and protection features
- ✅ **POSIX shells** - Profile-based protection

## ⚠️ Prerequisites & Dependencies

**Shell-Lock does NOT include dependency management.** You must install and manage these prerequisites:

### Required System Tools

```bash
# Ubuntu/Debian
sudo apt update && sudo apt install -y gpg git openssh-client coreutils

# RHEL/CentOS/Fedora
sudo dnf install -y gnupg2 git openssh-clients coreutils

# macOS (via Homebrew)
brew install gnupg git openssh coreutils
```

### Verification Command

```bash
# Verify all prerequisites are installed
for tool in gpg ssh git sha256sum; do
    command -v "$tool" >/dev/null && echo "✅ $tool" || echo "❌ $tool MISSING"
done
```

**⚠️ SECURITY NOTE:** Only install tools from official package repositories. Never use `curl | bash` or similar methods to install prerequisites, as these are common social engineering attack vectors.

## 🚀 Installation & Quick Start

### Step 1: Clone Repository (Security Conscious)

```bash
# Verify you're cloning from the official repository
git clone https://github.com/seanepping/shell-lock.git ~/dev/shell-lock
cd ~/dev/shell-lock

# SECURITY: Verify the repository contents before running any scripts
ls -la  # Check for suspicious files
head -20 install.sh  # Review installation script header
```

### Step 2: Secure Installation

```bash
# Run installation (will show what it's doing)
./install.sh

# Verify installation completed successfully
shell-lock help
```

### Step 3: Initial Security Setup

```bash
# Run guided security setup
shell-lock setup

# Create initial secure backups
shell-lock backup-all

# Perform comprehensive security audit
shell-lock audit
```

### Step 4: GitHub Authentication (Secure Method)

```bash
# Generate secure SSH key for GitHub
ssh-keygen -t ed25519 -C "your_email@example.com"

# Store GitHub token securely (encrypted)
secure-cred set github yourusername ghp_your_secure_token

# Login using encrypted credentials
gh-secure auth login yourusername

# Test secure authentication
gh-secure repo list
```

## 📁 Project Structure

```ascii
shell-lock/
├── README.md                    # Project overview and usage guide
├── install.sh                  # Installation script
├── SECURITY.md                 # Security policy and vulnerability reporting
├── scripts/                    # Main security tools
│   ├── dev-startup             # Development environment startup
│   ├── secure-cred             # Encrypted credential management
│   ├── gh-secure               # GitHub CLI wrapper with encryption
│   ├── secure-recovery         # Backup/recovery with integrity verification
│   ├── security-check          # Basic security audit tool
│   └── fix-shell-startup       # Shell configuration repair tool
├── templates/                  # Configuration templates
│   ├── zshrc.template          # Zsh configuration template
│   ├── bashrc.template         # Bash configuration template
│   └── ssh-config.template     # SSH configuration template
├── docs/                       # Documentation
│   ├── INSTALLATION.md         # Installation guide
│   ├── SECURITY_GUIDE.md       # Security features documentation
│   ├── USAGE_GUIDE.md          # Usage scenarios and FAQ
│   └── RECOVERY_GUIDE.md       # Emergency recovery procedures
└── examples/                   # Platform-specific examples
    └── wsl-setup.sh            # WSL-specific setup
```

## � Technical Implementation

### Core Components

**Shell-Lock consists of these main scripts:**

- **secure-cred**: GPG-based credential encryption/decryption script
- **gh-secure**: GitHub CLI wrapper that uses encrypted credentials
- **security-check**: Basic file integrity checker using SHA-256 hashes
- **update-baseline**: Simple tool to approve legitimate file changes and update security baselines
- **Emergency shell**: Simple clean environment script

### Basic Security Features

**What the scripts actually implement:**

- **Input Validation**: Basic sanitization in included scripts to prevent path traversal
- **GPG Encryption**: Uses standard GPG with AES256 for credential files
- **File Permissions**: Sets 600/700 permissions on sensitive files
- **Hash Verification**: SHA-256 checksums for backup file integrity
- **Error Handling**: Scripts use `set -euo pipefail` for better error detection

### Limitations

**Important technical limitations:**

- **No Real-time Monitoring**: Only checks integrity when manually run
- **Basic Input Validation**: Limited to preventing obvious injection attempts
- **No Comprehensive Protection**: Does not implement security controls beyond what's described
- **Manual Operation**: Most security checks require user to run commands manually

## 🔧 Essential Commands

### Daily Operations

```bash
# Security audit (run regularly)
shell-lock audit

# Create secure backups before system changes
shell-lock backup-all

# Verify backup integrity
shell-lock verify

# Emergency clean shell (if system compromised)
shell-lock emergency
```

### Credential Management

```bash
# Store encrypted credentials
secure-cred set <service> <username> <token>

# Retrieve encrypted credentials
secure-cred get <service> <username>

# List stored credentials
secure-cred list

# Delete credentials
secure-cred delete <service> <username>
```

### GitHub Operations (Secure)

```bash
# Set up GitHub authentication
gh-secure auth set <username> <token>

# Login with encrypted credentials
gh-secure auth login <username>

# Use GitHub CLI securely
gh-secure repo list
gh-secure issue list
gh-secure pr create
```

## ⚠️ Security Warnings & Best Practices

### 🚨 Critical Security Warnings

1. **Never run untrusted scripts** - Always review code before execution
2. **Verify repository authenticity** - Only clone from official sources
3. **Keep prerequisites updated** - Regularly update GPG, Git, and SSH
4. **Use strong passphrases** - All SSH keys and GPG encryption should use strong passphrases
5. **Regular security audits** - Run `shell-lock audit` frequently

### � General Security Awareness

**Important security practices when using any development tools:**

- **"Quick fix" scripts**: Always review code before running - Shell-Lock scripts can be audited
- **Fake security tools**: Only use scripts from official repositories you trust
- **Credential harvesting**: Never provide passwords or tokens to unverified scripts
- **Supply chain attacks**: Shell-Lock includes no third-party dependencies to reduce attack surface
- **Malicious backups**: Shell-Lock verifies backup integrity, but you must still secure your backup storage

### 📋 Security Checklist

Before using Shell-Lock in production:

- [ ] Verify all prerequisites are installed from official sources
- [ ] Review installation script contents
- [ ] Test in isolated environment first
- [ ] Create backup of existing configurations
- [ ] Understand emergency recovery procedures
- [ ] Set up strong passphrases for SSH keys and GPG
- [ ] Configure secure GitHub authentication
- [ ] Run initial security audit
- [ ] Document your security configuration

## � What Shell-Lock Actually Provides

| Feature                | What Shell-Lock Does                       | What You Must Do                        |
| ---------------------- | ------------------------------------------ | --------------------------------------- |
| Credential storage     | GPG AES256 encryption for stored tokens    | Manage GPG keys, use strong passphrases |
| Basic input validation | Sanitizes inputs in included scripts       | Review and audit all scripts before use |
| Config integrity       | SHA-256 checksums when manually run        | Run integrity checks regularly          |
| Backup verification    | Cryptographic verification of backup files | Secure your backup storage location     |
| Emergency shell access | Provides clean environment commands        | Know how to use emergency procedures    |

## 🔄 Recovery & Emergency Procedures

### Emergency Shell Access

If your system is compromised, use the clean emergency shell:

```bash
# Method 1: Shell-Lock emergency mode
shell-lock emergency

# Method 2: Manual clean shell
/usr/bin/env -i HOME="$HOME" USER="$USER"
  PATH="/usr/local/bin:/usr/bin:/bin" TERM="$TERM"
  /bin/bash --norc --noprofile
```

### Configuration Recovery

```bash
# Restore specific shell configuration
shell-lock restore-zsh    # or restore-bash

# Verify restoration integrity
shell-lock verify

# Complete system restoration
shell-lock restore-all
```

### Incident Response

1. **Isolate the system** - Use emergency shell
2. **Run security audit** - `shell-lock audit` for damage assessment
3. **Check integrity** - `shell-lock verify` for backup validation
4. **Restore from backup** - Use `shell-lock restore-all` if needed
5. **Update security baseline** - `update-baseline` (approves legitimate changes)

## 🤝 Contributing & Security

### Reporting Security Issues

**Do NOT report security vulnerabilities in public issues.**

For security vulnerabilities:

1. See `SECURITY.md` for responsible disclosure
2. Contact me directly via private channels
3. Provide detailed reproduction steps
4. Allow time for me to develop patches

### Contributing Guidelines

1. Fork the repository
2. Test on WSL2 and Ubuntu environments (the platforms I've tested)
3. Follow secure coding practices
4. Include security impact analysis
5. Update documentation for new features
6. Test all security controls before submitting

## 📜 License & Legal

MIT License - See LICENSE file for details

**Important Disclaimers:**

- **Testing Scope**: I have tested Shell-Lock only on WSL2 and Ubuntu environments.  
  I make no claims about compatibility, safety, or functionality on other systems.
- **Security Tools**: This toolkit provides security features but I make no guarantees  
  about preventing all security vulnerabilities or attacks.
- **No Warranties**: This software is provided as-is without any warranties of  
  merchantability, fitness for purpose, or security effectiveness.
- **User Responsibility**: You must test thoroughly in your own environments  
  and understand the security implications before deployment.
- **Community Testing**: I welcome and encourage community testing and feedback  
  for other platforms, but cannot guarantee functionality outside tested environments.

## 📞 Support & Documentation

- **Installation Issues**: See `docs/INSTALLATION.md`
- **Usage Questions**: See `docs/USAGE_GUIDE.md`
- **Security Configuration**: See `docs/SECURITY_GUIDE.md`
- **Emergency Recovery**: See `docs/RECOVERY_GUIDE.md`
- **Bug Reports**: GitHub Issues (non-security only)
- **Security Issues**: See `SECURITY.md`

---

**🔒 Remember: Security is a process, not a product. Stay vigilant and keep your tools updated.**
