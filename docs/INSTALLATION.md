# 🔧 Shell-Lock Installation Guide

## Prerequisites

Before installing Shell-Lock, ensure you have the following tools available:

- **GPG**: For credential encryption
- **SSH**: For secure authentication
- **Git**: For version control integration
- **sha256sum**: For integrity verification
- **Bash/Zsh**: Shell environments to protect

### Platform Support

- ✅ **Linux** (Ubuntu 18.04+, Debian 10+, RHEL 8+, etc.)
- ✅ **WSL** (Windows Subsystem for Linux)
- 🔄 **macOS** (experimental support)

## Quick Installation

```bash
# Clone the repository
git clone <repository-url> ~/dev/shell-lock

# Navigate to directory
cd ~/dev/shell-lock

# Run installation
./install.sh
```

## Manual Installation Steps

### 1. Download Shell-Lock

```bash
# Option A: Clone from Git
git clone <repository-url> ~/dev/shell-lock

# Option B: Download and extract
wget <archive-url>
tar -xzf shell-lock.tar.gz
mv shell-lock ~/dev/shell-lock
```

### 2. Run Installation Script

```bash
cd ~/dev/shell-lock
./install.sh
```

The installer will:

- Check system prerequisites
- Create necessary directories with secure permissions
- Install security scripts to `~/.local/bin/`
- Copy configuration templates to `~/.config/shell-lock/`
- Set up the main `shell-lock` command

### 3. Initial Setup

```bash
# Run the setup wizard
shell-lock setup
```

This will:

- Create secure backups of existing shell configurations
- Optionally install secure configuration templates
- Generate SSH keys if needed
- Run initial security audit

### 4. Verify Installation

```bash
# Check that shell-lock is working
shell-lock help

# Run security audit
shell-lock audit

# Verify backup integrity
shell-lock verify
```

## Installation Locations

### Scripts

- `~/.local/bin/shell-lock` - Main command interface
- `~/.local/bin/secure-recovery` - Backup and recovery system
- `~/.local/bin/security-check` - Security audit tool
- `~/.local/bin/dev-startup` - Secure environment startup
- `~/.local/bin/secure-cred` - Credential management
- `~/.local/bin/secure-setup` - Initial setup wizard

### Configuration

- `~/.config/shell-lock/` - Main configuration directory
- `~/.config/shell-lock/templates/` - Configuration templates
- `~/.config/shell-lock/docs/` - Documentation

### Data

- `~/.local/share/secure-backups/` - Encrypted backup storage
- `~/.local/share/recovery.log` - Recovery operation logs
- `~/.local/share/file-integrity.txt` - File integrity baseline

## PATH Configuration

Shell-Lock installs to `~/.local/bin/` which should be in your PATH. If not, add this to your shell configuration:

```bash
# For Zsh (~/.zshrc) or Bash (~/.bashrc)
export PATH="$HOME/.local/bin:$PATH"
```

## WSL-Specific Setup

For Windows Subsystem for Linux:

1. **Ensure WSL 2** is being used for better performance
2. **Install prerequisites** using your distribution's package manager:

   ```bash
   # Ubuntu/Debian
   sudo apt update
   sudo apt install gpg git ssh coreutils

   # RHEL/CentOS/Fedora
   sudo dnf install gnupg2 git openssh-clients coreutils
   ```

3. **Run installation** as normal - WSL detection is automatic

## Troubleshooting

### Permission Errors

```bash
# Fix common permission issues
chmod +x ~/.local/bin/shell-lock
chmod 700 ~/.config/shell-lock
chmod 700 ~/.local/share/secure-backups
```

### Missing Dependencies

```bash
# Ubuntu/Debian
sudo apt install gpg git ssh coreutils

# RHEL/CentOS/Fedora
sudo dnf install gnupg2 git openssh-clients coreutils

# macOS
brew install gpg git openssh coreutils
```

### PATH Issues

```bash
# Check if ~/.local/bin is in PATH
echo $PATH | grep -q "$HOME/.local/bin" && echo "✅ PATH OK" || echo "❌ Add ~/.local/bin to PATH"

# Add to PATH temporarily
export PATH="$HOME/.local/bin:$PATH"
```

### Backup Directory Issues

```bash
# Recreate backup directory with correct permissions
rm -rf ~/.local/share/secure-backups
mkdir -p ~/.local/share/secure-backups
chmod 700 ~/.local/share/secure-backups
```

## Uninstallation

To remove Shell-Lock:

```bash
# Remove scripts
rm -f ~/.local/bin/shell-lock
rm -f ~/.local/bin/secure-*
rm -f ~/.local/bin/security-check
rm -f ~/.local/bin/dev-startup

# Remove configuration (optional)
rm -rf ~/.config/shell-lock

# Remove backups (CAUTION: This deletes your secure backups!)
# rm -rf ~/.local/share/secure-backups
# rm -f ~/.local/share/recovery.log
```

## Security Considerations

1. **Review Templates**: Before using configuration templates, review them to ensure they meet your needs
2. **Backup Existing Configs**: Always backup your existing configurations before installation
3. **Test in Safe Environment**: Test Shell-Lock in a non-production environment first
4. **Understand Changes**: Make sure you understand what each security control does

## Next Steps

After installation:

1. **Read the Usage Guide**: `~/.config/shell-lock/docs/USAGE_GUIDE.md` - **Essential for daily use!**
2. **Read the Security Guide**: `~/.config/shell-lock/docs/SECURITY_GUIDE.md`
3. **Review Recovery Procedures**: `~/.config/shell-lock/docs/RECOVERY_GUIDE.md`
4. **Customize Configuration**: Adapt templates to your needs
5. **Regular Audits**: Set up regular security audits with `shell-lock audit`

**💡 Key Reminder:** After making any changes to your shell configs, update the integrity baseline:

```bash
rm ~/.local/share/file-integrity.txt && shell-lock audit
```

For support, see the troubleshooting section or check the project documentation.
