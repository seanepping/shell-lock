#!/bin/bash
# 🔐 Shell-Lock Installation Script
# Comprehensive shell security hardening toolkit installer

set -euo pipefail

readonly SHELL_LOCK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly INSTALL_DIR="$HOME/.local/bin"
readonly CONFIG_DIR="$HOME/.config/shell-lock"
readonly BACKUP_DIR="$HOME/.local/share/secure-backups"

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${GREEN}[SHELL-LOCK]${NC} $*"
}

warn() {
    echo -e "${YELLOW}[WARNING]${NC} $*"
}

error() {
    echo -e "${RED}[ERROR]${NC} $*"
}

info() {
    echo -e "${BLUE}[INFO]${NC} $*"
}

# Check if running on supported platform
check_platform() {
    case "$(uname -s)" in
        Linux*)
            log "Detected Linux platform"
            if [[ -n "${WSL_DISTRO_NAME:-}" ]]; then
                log "WSL environment detected: $WSL_DISTRO_NAME"
            fi
            ;;
        Darwin*)
            log "Detected macOS platform"
            warn "macOS support is experimental"
            ;;
        *)
            error "Unsupported platform: $(uname -s)"
            exit 1
            ;;
    esac
}

# Check prerequisites
check_prerequisites() {
    local missing_tools=()
    
    for tool in gpg ssh git sha256sum; do
        if ! command -v "$tool" >/dev/null 2>&1; then
            missing_tools+=("$tool")
        fi
    done
    
    if [[ ${#missing_tools[@]} -gt 0 ]]; then
        error "Missing required tools: ${missing_tools[*]}"
        info "Please install missing tools and run again"
        exit 1
    fi
    
    log "All prerequisites satisfied"
}

# Create necessary directories
create_directories() {
    log "Creating directory structure..."
    
    mkdir -p "$INSTALL_DIR"
    mkdir -p "$CONFIG_DIR"
    mkdir -p "$BACKUP_DIR"
    
    # Set secure permissions
    chmod 700 "$CONFIG_DIR"
    chmod 700 "$BACKUP_DIR"
    
    log "Directory structure created"
}

# Install scripts
install_scripts() {
    log "Installing Shell-Lock scripts..."
    
    for script in "$SHELL_LOCK_DIR"/scripts/*; do
        if [[ -f "$script" ]]; then
            local script_name
            script_name=$(basename "$script")
            cp "$script" "$INSTALL_DIR/"
            chmod +x "$INSTALL_DIR/$script_name"
            log "Installed: $script_name"
        fi
    done
    
    # Create main shell-lock command
    cat > "$INSTALL_DIR/shell-lock" << 'MAIN_EOF'
#!/bin/bash
# Shell-Lock main command interface

case "${1:-help}" in
    "setup"|"install")
        exec "$HOME/.local/bin/secure-setup" "${@:2}"
        ;;
    "backup-all"|"backup")
        exec "$HOME/.local/bin/secure-recovery" backup-all
        ;;
    "restore-zsh")
        exec "$HOME/.local/bin/secure-recovery" restore-zsh
        ;;
    "restore-bash")
        exec "$HOME/.local/bin/secure-recovery" restore-bash
        ;;
    "restore-all")
        "$HOME/.local/bin/secure-recovery" restore-zsh
        "$HOME/.local/bin/secure-recovery" restore-bash
        ;;
    "audit"|"check")
        exec "$HOME/.local/bin/security-check" "${@:2}"
        ;;
    "emergency")
        exec "$HOME/.local/bin/secure-recovery" emergency
        ;;
    "verify")
        exec "$HOME/.local/bin/secure-recovery" verify
        ;;
    "startup")
        exec "$HOME/.local/bin/dev-startup" "${@:2}"
        ;;
    "help"|*)
        cat << 'HELP_EOF'
🔐 Shell-Lock - Comprehensive Shell Security Toolkit

Usage: shell-lock <command> [options]

Commands:
  setup           Run initial security setup
  backup-all      Create secure backups of all shell configs
  restore-zsh     Restore zsh configuration from backup
  restore-bash    Restore bash configuration from backup
  restore-all     Restore all shell configurations
  audit           Run comprehensive security audit
  emergency       Start emergency clean shell
  verify          Verify backup integrity
  startup         Run development environment startup
  help            Show this help message

Examples:
  shell-lock setup           # Initial installation
  shell-lock backup-all      # Create secure backups
  shell-lock audit           # Security audit
  shell-lock emergency       # Emergency shell

For detailed help on specific commands, use:
  <command> help

Documentation: ~/.config/shell-lock/docs/
HELP_EOF
        ;;
esac
MAIN_EOF
    
    chmod +x "$INSTALL_DIR/shell-lock"
    log "Main shell-lock command installed"
}

# Install templates and documentation
install_documentation() {
    log "Installing documentation and templates..."
    
    # Copy templates
    if [[ -d "$SHELL_LOCK_DIR/templates" ]]; then
        cp -r "$SHELL_LOCK_DIR/templates" "$CONFIG_DIR/"
        log "Configuration templates installed"
    fi
    
    # Copy documentation
    if [[ -d "$SHELL_LOCK_DIR/docs" ]]; then
        cp -r "$SHELL_LOCK_DIR/docs" "$CONFIG_DIR/"
        log "Documentation installed"
    fi
    
    # Copy README
    if [[ -f "$SHELL_LOCK_DIR/README.md" ]]; then
        cp "$SHELL_LOCK_DIR/README.md" "$CONFIG_DIR/"
        log "README installed"
    fi
}

# Create secure setup script
create_secure_setup() {
    cat > "$INSTALL_DIR/secure-setup" << 'SETUP_EOF'
#!/bin/bash
# Shell-Lock secure setup script

set -euo pipefail

log() {
    echo -e "\033[0;32m[SETUP]\033[0m $*"
}

warn() {
    echo -e "\033[1;33m[WARNING]\033[0m $*"
}

error() {
    echo -e "\033[0;31m[ERROR]\033[0m $*"
}

# Main setup function
main() {
    log "Starting Shell-Lock secure setup..."
    
    # Create secure backups of existing configurations
    if [[ -f "$HOME/.zshrc" ]]; then
        log "Backing up existing .zshrc"
        secure-recovery backup-zsh 2>/dev/null || cp "$HOME/.zshrc" "$HOME/.zshrc.pre-shell-lock"
    fi
    
    if [[ -f "$HOME/.bashrc" ]]; then
        log "Backing up existing .bashrc"
        secure-recovery backup-bash 2>/dev/null || cp "$HOME/.bashrc" "$HOME/.bashrc.pre-shell-lock"
    fi
    
    # Check if user wants to use templates
    echo
    echo "Shell-Lock can install secure configuration templates."
    echo "This will replace your current shell configurations."
    echo
    read -p "Install secure shell configuration templates? [y/N]: " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_templates
    else
        log "Skipping template installation"
        log "You can manually integrate Shell-Lock into your existing configs"
        log "See: ~/.config/shell-lock/templates/ for examples"
    fi
    
    # Setup SSH security
    setup_ssh_security
    
    # Initial security check
    log "Running initial security check..."
    if command -v security-check >/dev/null 2>&1; then
        security-check || warn "Security check found issues - see output above"
    fi
    
    log "Shell-Lock setup complete!"
    log "Run 'shell-lock audit' to verify your security posture"
}

# Install configuration templates
install_templates() {
    local template_dir="$HOME/.config/shell-lock/templates"
    
    if [[ -f "$template_dir/zshrc.template" ]]; then
        log "Installing secure .zshrc template"
        cp "$template_dir/zshrc.template" "$HOME/.zshrc"
    fi
    
    if [[ -f "$template_dir/bashrc.template" ]]; then
        log "Installing secure .bashrc template"
        cp "$template_dir/bashrc.template" "$HOME/.bashrc"
    fi
    
    if [[ -f "$template_dir/ssh-config.template" ]]; then
        log "Installing secure SSH config template"
        mkdir -p "$HOME/.ssh"
        chmod 700 "$HOME/.ssh"
        cp "$template_dir/ssh-config.template" "$HOME/.ssh/config"
        chmod 600 "$HOME/.ssh/config"
    fi
    
    log "Templates installed successfully"
}

# Setup SSH security
setup_ssh_security() {
    log "Checking SSH security setup..."
    
    if [[ ! -f "$HOME/.ssh/github_ed25519" ]]; then
        echo
        echo "No GitHub SSH key found. Would you like to generate one?"
        read -p "Generate Ed25519 SSH key for GitHub? [y/N]: " -n 1 -r
        echo
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            read -p "Enter your email for the SSH key: " email
            if [[ -n "$email" ]]; then
                ssh-keygen -t ed25519 -f "$HOME/.ssh/github_ed25519" -C "$email"
                chmod 600 "$HOME/.ssh/github_ed25519"
                chmod 644 "$HOME/.ssh/github_ed25519.pub"
                
                log "SSH key generated: $HOME/.ssh/github_ed25519"
                log "Public key:"
                cat "$HOME/.ssh/github_ed25519.pub"
                log "Add this key to your GitHub account: https://github.com/settings/keys"
            fi
        fi
    else
        log "GitHub SSH key already exists"
    fi
}

# Run main setup
main "$@"
SETUP_EOF
    
    chmod +x "$INSTALL_DIR/secure-setup"
    log "Secure setup script created"
}

# Verify installation
verify_installation() {
    log "Verifying installation..."
    
    local issues=0
    
    # Check if scripts are executable
    for script in shell-lock secure-recovery security-check dev-startup secure-cred secure-setup; do
        if [[ ! -x "$INSTALL_DIR/$script" ]]; then
            error "Script not executable: $script"
            ((issues++))
        fi
    done
    
    # Check directory permissions
    if [[ "$(stat -c %a "$BACKUP_DIR" 2>/dev/null)" != "700" ]]; then
        error "Backup directory permissions incorrect"
        ((issues++))
    fi
    
    if [[ $issues -eq 0 ]]; then
        log "Installation verification passed"
        return 0
    else
        error "Installation verification failed with $issues issues"
        return 1
    fi
}

# Add to PATH if needed
setup_path() {
    if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
        warn "~/.local/bin is not in your PATH"
        info "Add this to your shell configuration:"
        info "export PATH=\"\$HOME/.local/bin:\$PATH\""
    fi
}

# Main installation flow
main() {
    log "🔐 Shell-Lock Installation Starting..."
    
    check_platform
    check_prerequisites
    create_directories
    install_scripts
    create_secure_setup
    install_documentation
    
    if verify_installation; then
        setup_path
        
        log "✅ Shell-Lock installation completed successfully!"
        info ""
        info "Next steps:"
        info "1. Run: shell-lock setup"
        info "2. Follow the setup prompts"
        info "3. Run: shell-lock audit"
        info ""
        info "Documentation: ~/.config/shell-lock/"
        info "Help: shell-lock help"
    else
        error "❌ Installation failed - please check errors above"
        exit 1
    fi
}

# Run main installation if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
