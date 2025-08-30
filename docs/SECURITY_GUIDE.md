# Secure Development Tools Documentation

## 🛡️ Security Overview

This system implements multiple layers of security for headless development environments:

1. **Passphrase-protected SSH keys** instead of plain text credentials
2. **Automated security monitoring** for suspicious activity
3. **File integrity checking** to detect tampering
4. **Recovery mechanisms** for emergency situations
5. **Encrypted credential storage** for sensitive data

## 🔧 Available Tools

### Core Security Tools

#### `security-check`

**Purpose**: Comprehensive security verification
**Usage**: `security-check`
**What it checks**:

- Command history for suspicious patterns (rm -rf, shutdown, etc.)
- File permissions on critical security files
- File integrity of SSH keys and scripts
- Unauthorized modifications

**Log location**: `~/.local/share/security-check.log`

#### `dev-startup`

**Purpose**: Secure development environment initialization
**Usage**:

- `dev-startup` - Normal startup with authentication prompt
- `dev-startup --emergency` - Emergency recovery mode

**Features**:

- 5-second timeout authentication prompt
- Mandatory security checks
- SSH agent management
- Development aliases setup
- Emergency recovery options

#### `ssh-agent-setup`

**Purpose**: Manage SSH agent for passphrase caching
**Usage**: `ssh-agent-setup`
**Function**:

- Starts SSH agent if not running
- Loads SSH keys into agent
- Caches passphrase for session

### Credential Management

#### `secure-cred`

**Purpose**: GPG-encrypted credential storage
**Usage**:

```bash
# Store a credential (will prompt for encryption password)
secure-cred set github username token_here

# Retrieve a credential
secure-cred get github username

# List stored credentials
secure-cred list

# Delete a credential
secure-cred delete github username
```

#### `gh-secure`

**Purpose**: Secure GitHub CLI wrapper
**Usage**: `gh-secure <normal-gh-commands>`
**Example**: `gh-secure repo list`
**Function**: Uses encrypted credentials automatically

### Key Management

#### `rotate-github-key`

**Purpose**: Rotate SSH keys for enhanced security
**Usage**: `rotate-github-key`
**Function**:

- Backs up current key
- Generates new passphrase-protected key
- Provides instructions for GitHub update

#### `check-fido-support`

**Purpose**: Check for hardware security key support
**Usage**: `check-fido-support`
**Function**: Verifies FIDO2/hardware key compatibility

## 🚨 Emergency Recovery

### Quick Recovery Commands

If something goes wrong, use these recovery options:

```bash
# Emergency shell without custom configurations
/bin/bash --norc

# Restore zshrc from backup
dev-startup --emergency
# Then use: restore-zshrc

# Manual zshrc restore
cp ~/.zshrc.backup.$(ls -t ~/.zshrc.backup.* | head -1 | cut -d. -f3-) ~/.zshrc

# Check security logs
cat ~/.local/share/security-check.log

# List available backups
ls -la ~/.zshrc.backup.*
```

### Recovery Scenarios

1. **Startup Script Issues**:

   ```bash
   /bin/bash --norc
   dev-startup --emergency
   restore-zshrc
   ```

2. **SSH Authentication Problems**:

   ```bash
   ssh-agent-setup
   ssh-add ~/.ssh/github_ed25519
   ssh -T git@github.com
   ```

3. **File Integrity Issues**:

   ```bash
   security-check
   diff ~/.local/share/file-integrity.txt <(find ~/.local/bin ~/.ssh -type f -exec sha256sum {} \;)
   ```

## 📋 Regular Maintenance

### Weekly Tasks

- Run `rotate-github-key` (monthly recommended)
- Check security logs: `cat ~/.local/share/security-check.log`
- Verify SSH connection: `ssh -T git@github.com`

### Monthly Tasks

- Rotate SSH keys: `rotate-github-key`
- Update file integrity baseline: `rm ~/.local/share/file-integrity.txt && security-check`
- Review and clean old backups: `ls -la ~/.zshrc.backup.*`

## 🔐 Authentication Workflow

### Session Startup

1. **Automatic security check** runs (mandatory)
2. **Authentication prompt** appears (5-second timeout)
3. **SSH agent setup** if authentication selected
4. **Development environment** configuration

### Authentication Options

- **Y/Enter**: Full authentication with SSH agent
- **n**: Skip authentication, work unauthenticated
- **Timeout**: Auto-skip after 5 seconds

## 📁 File Locations

### Configuration Files

- `~/.zshrc` - Shell configuration
- `~/.ssh/config` - SSH configuration
- `~/.ssh/github_ed25519` - Private SSH key (passphrase-protected)
- `~/.ssh/github_ed25519.pub` - Public SSH key

### Security Files

- `~/.local/share/security-check.log` - Security audit log
- `~/.local/share/file-integrity.txt` - File integrity baseline
- `~/.local/share/secure-credentials/` - Encrypted credential storage

### Scripts

- `~/.local/bin/dev-startup` - Main startup script
- `~/.local/bin/security-check` - Security verification
- `~/.local/bin/ssh-agent-setup` - SSH agent management
- `~/.local/bin/secure-cred` - Credential management
- `~/.local/bin/gh-secure` - Secure GitHub CLI
- `~/.local/bin/rotate-github-key` - Key rotation

### Backups

- `~/.zshrc.backup.*` - Timestamped zshrc backups
- `~/.ssh/old-keys/` - Rotated SSH keys

## 🛠️ Troubleshooting

### Common Issues

1. **"Authentication agent connection failed"**:

   ```bash
   ssh-agent-setup
   source ~/.ssh/agent-environment
   ```

2. **"Permission denied (publickey)"**:

   ```bash
   ssh -T git@github.com  # Test connection
   ssh-add -l             # List loaded keys
   ssh-add ~/.ssh/github_ed25519  # Add key manually
   ```

3. **"Security check failed"**:

   ```bash
   cat ~/.local/share/security-check.log  # Check what failed
   security-check  # Re-run check
   ```

4. **Startup script hangs**:

   ```bash
   # In another terminal:
   /bin/bash --norc
   dev-startup --emergency
   ```

### Debug Mode

Enable debug output for troubleshooting:

```bash
bash -x ~/.local/bin/dev-startup
```

## 🔍 Security Monitoring

The system monitors for:

- Destructive commands (rm -rf, dd, mkfs, etc.)
- System control commands (shutdown, reboot, halt)
- Permission changes (chmod 777, chown root)
- Network services (nc -l, python http.server)
- Privilege escalation attempts
- File modifications to critical security files
- Incorrect file permissions

Security events are logged with timestamps and can be reviewed at any time.

## 📞 Support

If you encounter issues:

1. Check the security log: `~/.local/share/security-check.log`
2. Use emergency recovery: `dev-startup --emergency`
3. Restore from backup: Latest backup in `~/.zshrc.backup.*`
4. Emergency shell: `/bin/bash --norc`

Remember: Security is a balance between protection and usability. These tools prioritize security while maintaining development workflow efficiency.

## 🛡️ Enhanced Security Coverage (Updated)

### All Shell Entry Points Protected

The security system now monitors and protects **ALL** potential shell entry points:

#### User Configuration Files

- `~/.zshrc` - Zsh main configuration
- `~/.bashrc` - Bash main configuration
- `~/.profile` - POSIX shell profile (affects all shells)
- `~/.zshenv` - Zsh environment (sourced for all zsh instances)
- `~/.zprofile` - Zsh login profile
- `~/.bash_profile` - Bash login profile
- `~/.bash_login` - Bash login alternative

#### System Configuration Files (Monitored)

- `/etc/profile` - System-wide profile
- `/etc/bash.bashrc` - System-wide bash configuration
- `/etc/zsh/zshrc` - System-wide zsh configuration

### WSL-Specific Protections

For Windows Subsystem for Linux environments:

- **Windows PATH exclusion**: Security checks ignore `/mnt/c/` paths
- **WSL-aware monitoring**: Focused on Linux-side security
- **Cross-platform compatibility**: Works in both WSL and native Linux

### Enhanced Security Monitoring

#### New Threat Detection

- **Shell injection patterns**: Detects `echo >> ~/.bashrc` type attacks
- **Configuration tampering**: Monitors all shell config files for changes
- **Dangerous aliases**: Detects risky command aliases
- **PATH manipulation**: Identifies suspicious PATH modifications
- **World-writable directories**: Flags insecure PATH entries

#### Additional Tools

**`secure-all-shells`**

- **Purpose**: Comprehensively secure all shell entry points
- **Usage**: `secure-all-shells`
- **Function**: Creates protected shell config files with security headers

### Attack Vector Coverage

| Attack Vector           | Protection Method         | Detection            |
| ----------------------- | ------------------------- | -------------------- |
| `.bashrc` modification  | File integrity monitoring | ✅ Real-time         |
| `.profile` injection    | Checksum verification     | ✅ Session startup   |
| Environment poisoning   | Shell security checks     | ✅ Every login       |
| PATH manipulation       | PATH validation           | ✅ Startup scan      |
| Alias hijacking         | Dangerous alias detection | ✅ Active monitoring |
| System config tampering | System file monitoring    | ✅ Startup check     |

### Recovery from Shell Compromises

If any shell configuration is compromised:

```bash
# Emergency access
/bin/bash --norc

# Restore all shell configs
cp ~/.bashrc.backup.* ~/.bashrc
cp ~/.zshrc.backup.* ~/.zshrc
cp ~/.profile.backup.* ~/.profile

# Re-secure all entry points
secure-all-shells

# Update security baseline
rm ~/.local/share/file-integrity.txt
security-check
```

### Multi-Shell Protection Status

✅ **Zsh**: Fully protected and monitored  
✅ **Bash**: Fully protected and monitored  
✅ **POSIX shells**: Protected via `.profile`  
✅ **Login shells**: Protected via login-specific configs  
✅ **System-wide**: Monitored for suspicious changes  
✅ **WSL environments**: Windows paths safely excluded

**All shell entry points are now secured against unauthorized modifications.**
