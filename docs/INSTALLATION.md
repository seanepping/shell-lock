# 🔧 Shell-Lock Comprehensive Installation Guide

## 🎯 Tested Environments & Requirements

### ✅ Confirmed Testing

**Shell-Lock has been tested on:**

- **WSL2** (Windows Subsystem for Linux 2)
- **Ubuntu** (tested versions available to project)

### 🔄 Community Testing Welcome

**We welcome community testing and feedback for:**

- **macOS** - Community feedback appreciated
- **Other Linux distributions** - Community verification helpful
- **BSD systems** - Community testing needed

### ❌ Known Incompatible Platforms

- **Windows PowerShell/CMD** - Use WSL2 instead
- **Alpine Linux** - Different shell behavior, compatibility unknown

## 🔐 Prerequisites & Security Requirements

**⚠️ CRITICAL:** Shell-Lock does NOT include dependency management. You must install and manage all prerequisites yourself from official sources only.

### Required System Tools

**Ubuntu/Debian:**

```bash
# Update package list first
sudo apt update

# Install required tools
sudo apt install -y gpg git openssh-client coreutils

# Verify installation
gpg --version && git --version && ssh -V && sha256sum --version
```

**RHEL/CentOS/Fedora:**

```bash
# Install required tools
sudo dnf install -y gnupg2 git openssh-clients coreutils

# Verify installation
gpg --version && git --version && ssh -V && sha256sum --version
```

**macOS (via Homebrew):**

```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install required tools
brew install gnupg git openssh coreutils

# Verify installation
gpg --version && git --version && ssh -V && gsha256sum --version
```

### 🛡️ Security Verification

**Before proceeding, verify all tools are properly installed:**

```bash
# Comprehensive prerequisite check
for tool in gpg ssh git sha256sum; do
    if command -v "$tool" >/dev/null 2>&1; then
        echo "✅ $tool: $(command -v "$tool")"
        $tool --version | head -1
    else
        echo "❌ $tool: MISSING - Install from official repositories only"
        exit 1
    fi
done

echo "✅ All prerequisites satisfied"
```

**⚠️ SECURITY WARNING:** Only install prerequisites from official package repositories. Never use `curl | bash`, `wget | sh`, or similar methods as these are common social engineering attack vectors.

## 🚀 Secure Installation Process

### Step 1: Repository Verification

```bash
# Clone from official repository only
git clone https://github.com/seanepping/shell-lock.git ~/dev/shell-lock

# Navigate to directory
cd ~/dev/shell-lock

# SECURITY: Verify repository contents
echo "Repository contents:"
ls -la

echo -e "\nVerifying this is the official repository:"
git remote -v

echo -e "\nChecking recent commits:"
git log --oneline -5

echo -e "\nReviewing installation script header:"
head -20 install.sh
```

### Step 2: Installation Script Review

**⚠️ ALWAYS review installation scripts before running:**

```bash
# Review the complete installation script
less install.sh

# Check for suspicious patterns
grep -n "curl\|wget\|rm.*-rf\|sudo\|eval" install.sh

# Verify script uses secure practices
grep -n "set -euo pipefail" install.sh
```

### Step 3: Secure Installation

```bash
# Run installation with logging
./install.sh 2>&1 | tee install.log

# Review installation log
less install.log

# Verify installation completed successfully
if command -v shell-lock >/dev/null 2>&1; then
    echo "✅ Installation successful"
    shell-lock help
else
    echo "❌ Installation failed"
    exit 1
fi
```

## 🔧 Post-Installation Setup

### Initial Security Configuration

```bash
# Step 1: Run guided security setup
shell-lock setup

# Step 2: Create initial secure backups
shell-lock backup-all

# Step 3: Perform security baseline audit
shell-lock audit

# Step 4: Verify installation integrity
shell-lock verify
```

### GitHub Integration (Secure Method)

```bash
# Generate secure SSH key for GitHub
ssh-keygen -t ed25519 -C "your_email@example.com"

# Add public key to GitHub account
cat ~/.ssh/id_ed25519.pub
# Copy output and add to https://github.com/settings/keys

# Test SSH connection
ssh -T git@github.com

# Store GitHub token securely (if needed for CLI)
secure-cred set github yourusername ghp_your_token_here

# Login using encrypted credentials
gh-secure auth login yourusername
```

## 🔍 Installation Verification

### Comprehensive Verification Checklist

```bash
# 1. Check all scripts are installed and executable
for script in shell-lock secure-cred gh-secure security-check secure-recovery dev-startup; do
    if [[ -x "$HOME/.local/bin/$script" ]]; then
        echo "✅ $script: Installed and executable"
    else
        echo "❌ $script: Missing or not executable"
    fi
done

# 2. Verify directory structure and permissions
echo -e "\n🔍 Checking directory structure:"
ls -la ~/.local/bin/shell-lock* ~/.local/bin/secure-* ~/.local/bin/security-* ~/.local/bin/gh-* ~/.local/bin/dev-*
ls -ld ~/.config/shell-lock ~/.local/share/secure-backups

# 3. Test core functionality
echo -e "\n🧪 Testing core functionality:"
shell-lock help >/dev/null && echo "✅ shell-lock: Working"
secure-cred >/dev/null && echo "✅ secure-cred: Working"
security-check --help >/dev/null 2>&1 && echo "✅ security-check: Working"

# 4. Verify PATH configuration
echo -e "\n🛤️  PATH verification:"
if [[ ":$PATH:" == *":$HOME/.local/bin:"* ]]; then
    echo "✅ ~/.local/bin is in PATH"
else
    echo "⚠️  ~/.local/bin not in PATH - add to shell config"
    echo "   Add: export PATH=\"\$HOME/.local/bin:\$PATH\""
fi

# 5. Security verification
echo -e "\n🔐 Security verification:"
shell-lock audit >/dev/null 2>&1 && echo "✅ Security audit: Passed"
```

## 🔧 Platform-Specific Configurations

### WSL2 Specific Setup

```bash
# Verify WSL environment
if [[ -n "$WSL_DISTRO_NAME" ]]; then
    echo "✅ WSL2 detected: $WSL_DISTRO_NAME"

    # WSL-specific optimizations are automatically applied
    # Check WSL-aware security features
    shell-lock audit | grep -i wsl

else
    echo "ℹ️  Not running in WSL"
fi

# WSL-specific SSH considerations
echo "🔑 SSH key location for WSL:"
echo "  Store keys in Linux filesystem: ~/.ssh/"
echo "  Avoid Windows filesystem: /mnt/c/..."
```

### macOS Specific Notes

```bash
# macOS users may need to adapt SSH config
if [[ "$(uname)" == "Darwin" ]]; then
    echo "🍎 macOS detected"
    echo "⚠️  May need to remove UseKeychain from SSH config"
    echo "   Edit ~/.ssh/config and comment out macOS-specific options"
fi
```

## ⚠️ Troubleshooting Installation Issues

### Common Installation Problems

**Problem: Missing prerequisites**

```bash
# Solution: Install from official sources
sudo apt update && sudo apt install -y gpg git openssh-client coreutils
```

**Problem: Permission denied errors**

```bash
# Solution: Ensure proper permissions
chmod +x install.sh
# Run without sudo - installs to user directory only
```

**Problem: PATH not updated**

```bash
# Solution: Add to shell configuration
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.zshrc  # or ~/.bashrc
```

**Problem: GPG not working**

```bash
# Solution: Test GPG functionality
echo "test" | gpg --symmetric --cipher-algo AES256 | gpg --decrypt

# If fails, may need to generate GPG key
gpg --full-generate-key
```

### Getting Help

**If installation fails:**

1. **Check prerequisites**: Run prerequisite verification script
2. **Review logs**: Check `install.log` for error details
3. **Test in isolation**: Try in fresh container or test user
4. **Check platform support**: Ensure your platform is supported
5. **Report issues**: Use GitHub Issues for non-security problems

**For security issues**: See `SECURITY.md` for responsible disclosure

## 📚 Next Steps

After successful installation:

1. **Read the documentation**: `~/.config/shell-lock/docs/`
2. **Complete security setup**: `shell-lock setup`
3. **Learn essential commands**: `docs/USAGE_GUIDE.md`
4. **Set up GitHub integration**: Follow secure credential management guide
5. **Regular security audits**: `shell-lock audit`

---

**🔒 Security is a journey, not a destination. Keep your tools updated and stay vigilant.**

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

## Important Disclaimers

**Testing and Compatibility:**

- **Limited Testing**: This software has been tested only on WSL2 and Ubuntu environments
- **No Guarantees**: We make no claims about safety, security, or functionality on other systems
- **User Responsibility**: You must test thoroughly in your environment before deployment
- **Community Feedback**: We welcome testing reports for other platforms but cannot guarantee compatibility

**Security Limitations:**

- **No Security Guarantees**: This toolkit provides features but cannot guarantee protection against all threats
- **Configuration Required**: Proper security requires understanding and configuring each feature appropriately
- **Regular Updates**: Security is an ongoing process requiring regular updates and monitoring

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
