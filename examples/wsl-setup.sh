#!/bin/bash
# 🔐 Shell-Lock WSL-Specific Setup Example
# Special considerations for Windows Subsystem for Linux

set -euo pipefail

log() {
    echo -e "\033[0;32m[WSL-SETUP]\033[0m $*"
}

warn() {
    echo -e "\033[1;33m[WARNING]\033[0m $*"
}

# Detect WSL environment
detect_wsl() {
    if [[ -n "${WSL_DISTRO_NAME:-}" ]]; then
        log "WSL environment detected: $WSL_DISTRO_NAME"
        return 0
    elif grep -q microsoft /proc/version 2>/dev/null; then
        log "WSL environment detected (legacy)"
        return 0
    else
        warn "This script is designed for WSL environments"
        return 1
    fi
}

# WSL-specific security hardening
setup_wsl_security() {
    log "Applying WSL-specific security settings..."
    
    # Create WSL-aware security configuration
    mkdir -p ~/.config/shell-lock
    
    cat > ~/.config/shell-lock/wsl-config << 'WSLEOF'
# WSL-specific Shell-Lock configuration

# Exclude Windows paths from security monitoring
SECURITY_EXCLUDE_PATHS="/mnt/c /mnt/d /mnt/e /mnt/f"

# WSL-specific environment variables
export WSL_SHELL_LOCK_ENABLED=1
export SHELL_LOCK_WSL_MODE=1

# Windows interop security
export WSLENV="SHELL_LOCK_WSL_MODE/u"
WSLEOF
    
    chmod 600 ~/.config/shell-lock/wsl-config
    log "WSL configuration created"
}

# Fix common WSL permission issues
fix_wsl_permissions() {
    log "Fixing WSL-specific permission issues..."
    
    # Ensure SSH directory has correct permissions
    if [[ -d ~/.ssh ]]; then
        chmod 700 ~/.ssh
        chmod 600 ~/.ssh/* 2>/dev/null || true
        log "SSH permissions corrected"
    fi
    
    # Fix GPG permissions if needed
    if [[ -d ~/.gnupg ]]; then
        chmod 700 ~/.gnupg
        chmod 600 ~/.gnupg/* 2>/dev/null || true
        log "GPG permissions corrected"
    fi
}

# Configure Windows-Linux interop security
setup_interop_security() {
    log "Configuring Windows-Linux interop security..."
    
    # Create wrapper for Windows commands to prevent injection
    cat > ~/.local/bin/safe-windows-cmd << 'CMDEOF'
#!/bin/bash
# Safe Windows command wrapper

# Only allow specific Windows commands
case "${1:-}" in
    "explorer.exe"|"notepad.exe"|"code.exe")
        exec "$@"
        ;;
    *)
        echo "⚠️  Command not in allowlist: $1"
        echo "Edit ~/.local/bin/safe-windows-cmd to add safe commands"
        exit 1
        ;;
esac
CMDEOF
    
    chmod +x ~/.local/bin/safe-windows-cmd
    log "Windows command wrapper created"
}

# Main WSL setup
main() {
    log "🔐 Shell-Lock WSL Setup Starting..."
    
    if ! detect_wsl; then
        exit 1
    fi
    
    setup_wsl_security
    fix_wsl_permissions
    setup_interop_security
    
    log "✅ WSL-specific setup completed!"
    log ""
    log "WSL-specific features enabled:"
    log "- Windows path exclusion in security monitoring"
    log "- WSL-aware permission handling"
    log "- Windows interop security wrapper"
    log ""
    log "Next steps:"
    log "1. Run: shell-lock setup"
    log "2. Test: shell-lock audit"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
