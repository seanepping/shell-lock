# 🔧 Shell-Lock Usage Guide & FAQ

This guide covers common usage scenarios and frequently asked questions for Shell-Lock users.

## 📚 Table of Contents

- [Quick Start Commands](#quick-start-commands)
- [Managing Integrity Warnings](#managing-integrity-warnings)
- [Configuration Management](#configuration-management)
- [Backup and Recovery](#backup-and-recovery)
- [GitHub Authentication](#github-authentication)
- [Troubleshooting](#troubleshooting)
- [FAQ](#faq)

## 🚀 Quick Start Commands

```bash
# Essential commands you'll use daily
shell-lock help                    # Show all commands
shell-lock audit                   # Run security check
shell-lock backup-all              # Create secure backups
shell-lock emergency               # Emergency clean shell

# GitHub authentication (secure)
secure-cred set github <username> <token>    # Store token
gh-secure auth login <username>              # Login with stored token
gh-secure repo list                          # Use GitHub CLI securely
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

---

**💡 Remember:** Shell-Lock is designed to protect you, not get in your way. When you see warnings, it means the system is working correctly and detected changes that need your attention.

For more detailed information, see:

- `~/.config/shell-lock/docs/SECURITY_GUIDE.md` - Detailed security features
- `~/.config/shell-lock/docs/RECOVERY_GUIDE.md` - Recovery procedures
- `shell-lock help` - Quick command reference
