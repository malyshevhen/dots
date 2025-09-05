#!/bin/bash

# Lombok Helper Script for Neovim JDTLS Integration
# This script helps manage Lombok installation and operations

set -e

# Configuration
LOMBOK_VERSION="${LOMBOK_VERSION:-1.18.30}"
MAVEN_REPO="$HOME/.m2/repository"
LOMBOK_DIR="$MAVEN_REPO/org/projectlombok/lombok"
LOMBOK_JAR="$LOMBOK_DIR/$LOMBOK_VERSION/lombok-$LOMBOK_VERSION.jar"
LOMBOK_URL="https://repo1.maven.org/maven2/org/projectlombok/lombok/$LOMBOK_VERSION/lombok-$LOMBOK_VERSION.jar"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Lombok is installed
check_lombok() {
    log_info "Checking Lombok installation..."

    if [[ -f "$LOMBOK_JAR" ]]; then
        log_success "Lombok $LOMBOK_VERSION found at: $LOMBOK_JAR"
        return 0
    else
        log_warning "Lombok $LOMBOK_VERSION not found at expected location"

        # Check for any Lombok version
        if [[ -d "$LOMBOK_DIR" ]]; then
            local found_versions=$(find "$LOMBOK_DIR" -name "lombok-*.jar" 2>/dev/null | head -5)
            if [[ -n "$found_versions" ]]; then
                log_info "Found other Lombok versions:"
                echo "$found_versions" | while read -r jar; do
                    local version=$(basename "$jar" .jar | sed 's/lombok-//')
                    echo "  - Version $version: $jar"
                done
            fi
        fi
        return 1
    fi
}

# Install Lombok
install_lombok() {
    log_info "Installing Lombok $LOMBOK_VERSION..."

    # Create directory structure
    mkdir -p "$LOMBOK_DIR/$LOMBOK_VERSION"

    # Download Lombok jar
    log_info "Downloading Lombok from: $LOMBOK_URL"
    if command -v curl >/dev/null 2>&1; then
        curl -L -o "$LOMBOK_JAR" "$LOMBOK_URL"
    elif command -v wget >/dev/null 2>&1; then
        wget -O "$LOMBOK_JAR" "$LOMBOK_URL"
    else
        log_error "Neither curl nor wget found. Please install one of them."
        return 1
    fi

    # Verify download
    if [[ -f "$LOMBOK_JAR" ]] && [[ $(stat -c%s "$LOMBOK_JAR" 2>/dev/null || stat -f%z "$LOMBOK_JAR" 2>/dev/null) -gt 1000000 ]]; then
        log_success "Lombok $LOMBOK_VERSION installed successfully!"

        # Create POM entry for Maven projects
        create_pom_snippet
    else
        log_error "Failed to download Lombok jar or file is corrupted"
        rm -f "$LOMBOK_JAR"
        return 1
    fi
}

# Create POM snippet for Maven projects
create_pom_snippet() {
    local pom_snippet="/tmp/lombok-pom-snippet.xml"
    cat > "$pom_snippet" << EOF
<!-- Add this to your pom.xml dependencies section -->
<dependency>
    <groupId>org.projectlombok</groupId>
    <artifactId>lombok</artifactId>
    <version>$LOMBOK_VERSION</version>
    <scope>provided</scope>
</dependency>

<!-- Add this to your maven-compiler-plugin configuration -->
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-compiler-plugin</artifactId>
    <version>3.11.0</version>
    <configuration>
        <source>11</source>
        <target>11</target>
        <annotationProcessorPaths>
            <path>
                <groupId>org.projectlombok</groupId>
                <artifactId>lombok</artifactId>
                <version>$LOMBOK_VERSION</version>
            </path>
        </annotationProcessorPaths>
    </configuration>
</plugin>
EOF

    log_info "Maven POM snippet created at: $pom_snippet"
}

# Delombok a Java file
delombok_file() {
    local input_file="$1"

    if [[ -z "$input_file" ]]; then
        log_error "Please provide a Java file to delombok"
        return 1
    fi

    if [[ ! -f "$input_file" ]]; then
        log_error "File not found: $input_file"
        return 1
    fi

    if [[ ! -f "$LOMBOK_JAR" ]]; then
        log_error "Lombok jar not found. Please install Lombok first."
        return 1
    fi

    local output_file="${input_file%.java}.delomboked.java"

    log_info "Delomboking $input_file..."
    java -jar "$LOMBOK_JAR" delombok "$input_file" > "$output_file"

    if [[ $? -eq 0 ]]; then
        log_success "Delombok completed: $output_file"
    else
        log_error "Delombok failed"
        return 1
    fi
}

# Show Lombok version and info
show_info() {
    log_info "Lombok Helper Script Information"
    echo "================================="
    echo "Lombok Version: $LOMBOK_VERSION"
    echo "Lombok Jar Path: $LOMBOK_JAR"
    echo "Maven Repository: $MAVEN_REPO"
    echo ""

    if check_lombok >/dev/null 2>&1; then
        echo "Status: ✅ Installed"

        # Show jar file info
        if [[ -f "$LOMBOK_JAR" ]]; then
            local size=$(stat -c%s "$LOMBOK_JAR" 2>/dev/null || stat -f%z "$LOMBOK_JAR" 2>/dev/null)
            local size_mb=$(echo "scale=2; $size / 1024 / 1024" | bc 2>/dev/null || echo "$(($size / 1024 / 1024))")
            echo "Jar Size: ${size_mb}MB"

            # Try to get version from jar manifest
            local manifest_version=$(unzip -q -c "$LOMBOK_JAR" META-INF/MANIFEST.MF 2>/dev/null | grep "Implementation-Version:" | cut -d' ' -f2 | tr -d '\r' 2>/dev/null || echo "Unknown")
            echo "Manifest Version: $manifest_version"
        fi
    else
        echo "Status: ❌ Not Installed"
    fi
}

# Update Lombok to latest version
update_lombok() {
    log_info "Checking for latest Lombok version..."

    # Try to get latest version from Maven Central API
    local latest_version
    if command -v curl >/dev/null 2>&1; then
        latest_version=$(curl -s "https://search.maven.org/solrsearch/select?q=g:org.projectlombok+AND+a:lombok&rows=1&wt=json" | grep -o '"latestVersion":"[^"]*"' | cut -d'"' -f4 2>/dev/null || echo "")
    fi

    if [[ -z "$latest_version" ]]; then
        log_warning "Could not determine latest version. Using configured version: $LOMBOK_VERSION"
        latest_version="$LOMBOK_VERSION"
    fi

    log_info "Latest version: $latest_version"

    if [[ "$latest_version" != "$LOMBOK_VERSION" ]]; then
        log_info "Updating to version $latest_version"
        LOMBOK_VERSION="$latest_version"
        LOMBOK_JAR="$LOMBOK_DIR/$LOMBOK_VERSION/lombok-$LOMBOK_VERSION.jar"
        LOMBOK_URL="https://repo1.maven.org/maven2/org/projectlombok/lombok/$LOMBOK_VERSION/lombok-$LOMBOK_VERSION.jar"
        install_lombok
    else
        log_success "Already using the latest version"
    fi
}

# Clean old Lombok versions
clean_old_versions() {
    log_info "Cleaning old Lombok versions..."

    if [[ ! -d "$LOMBOK_DIR" ]]; then
        log_info "No Lombok installations found"
        return 0
    fi

    local current_version_dir="$LOMBOK_DIR/$LOMBOK_VERSION"
    local cleaned=0

    for version_dir in "$LOMBOK_DIR"/*; do
        if [[ -d "$version_dir" ]] && [[ "$version_dir" != "$current_version_dir" ]]; then
            local version=$(basename "$version_dir")
            log_info "Removing old version: $version"
            rm -rf "$version_dir"
            ((cleaned++))
        fi
    done

    if [[ $cleaned -eq 0 ]]; then
        log_info "No old versions to clean"
    else
        log_success "Cleaned $cleaned old version(s)"
    fi
}

# Show usage
usage() {
    echo "Lombok Helper Script"
    echo ""
    echo "Usage: $0 [command] [options]"
    echo ""
    echo "Commands:"
    echo "  check                 Check if Lombok is installed"
    echo "  install               Install Lombok"
    echo "  update                Update Lombok to latest version"
    echo "  info                  Show Lombok installation information"
    echo "  delombok <file>       Delombok a Java file"
    echo "  clean                 Remove old Lombok versions"
    echo "  help                  Show this help message"
    echo ""
    echo "Environment Variables:"
    echo "  LOMBOK_VERSION        Specify Lombok version (default: 1.18.30)"
    echo ""
    echo "Examples:"
    echo "  $0 install"
    echo "  $0 delombok MyClass.java"
    echo "  LOMBOK_VERSION=1.18.32 $0 install"
}

# Main script logic
main() {
    case "${1:-help}" in
        check)
            check_lombok
            ;;
        install)
            install_lombok
            ;;
        update)
            update_lombok
            ;;
        info)
            show_info
            ;;
        delombok)
            delombok_file "$2"
            ;;
        clean)
            clean_old_versions
            ;;
        help|--help|-h)
            usage
            ;;
        *)
            log_error "Unknown command: $1"
            echo ""
            usage
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
