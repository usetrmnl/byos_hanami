#! /usr/bin/env bash

# Label: Find Linux IP Address
# Description: Finds current machine's first IP address.
find_linux_ip_address() {
  ip route get 1 2>/dev/null | awk '{print $7; exit}'
}
export -f find_linux_ip_address

# Label: Find macOS IP Address
# Description: Finds current machine's first IP address.
find_mac_ip_address() {
  ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null
}
export -f find_mac_ip_address

# Label: Find IP Address
# Description: Automatically finds local IP address of current machine.
find_ip_address() {
  case "$(uname)" in
    Linux*)
      find_linux_ip_address
      ;;
    Darwin*)
      find_mac_ip_address
      ;;
    *)
      return
      ;;
  esac
}
export -f find_ip_address

# Label: Randomize
# Description: Creates an insecure but long random number.
randomize() {
  value=$RANDOM

  for ((i = 0; i < 15; i++)); do
    value="${value}${RANDOM}"
  done

  echo "$value"
}

export -f randomize

# Label: Create Global Environment
# Description: Create global environment.
create_global_environment() {
  local template_path="$TEMPLATES_ROOT/.env.tt"
  local output_path="$PROJECT_ROOT/.env"

  if [[ -f "$output_path" ]]; then
    printf "%s\n" ".env exists. Skipped."
    return
  fi

  printf "%s\n" "Creating .env..."
  cp "$template_path" "$output_path"

  ip_address="$(find_ip_address)"

  if [[ -n "$ip_address" ]]; then
    sed -i.tmp "s|localhost|$ip_address|g" "$output_path" && rm "$output_path.tmp"
  else
    read -r -p "Please enter the IP address of your machine (example: 192.168.0.25): " response
    sed -i.tmp "s|localhost|$response|g" "$output_path" && rm "$output_path.tmp"
  fi

  sed -i.tmp "s|<database_password>|$(randomize)|g" "$output_path" && rm "$output_path.tmp"
  sed -i.tmp "s|<keyvalue_password>|$(randomize)|g" "$output_path" && rm "$output_path.tmp"
  sed -i.tmp "s|<secret>|$(randomize)|g" "$output_path" && rm "$output_path.tmp"
}
export -f create_global_environment

# Label: Create Development Environment
# Description: Create development environment.
create_development_environment() {
  local prefix="${1:-Creating}"
  local template_path="$TEMPLATES_ROOT/.env.development.tt"
  local output_path="$PROJECT_ROOT/.env.development"

  if [[ -f "$output_path" ]]; then
    printf "%s\n" ".env.development exists. Skipped."
    return
  fi

  printf "%s\n" "$prefix .env.development..."
  cp "$template_path" "$output_path"
}
export -f create_development_environment

# Label: Create Test Environment
# Description: Create test environment.
create_test_environment() {
  local prefix="${1:-Creating}"
  local template_path="$TEMPLATES_ROOT/.env.test.tt"
  local output_path="$PROJECT_ROOT/.env.test"

  if [[ -f "$output_path" ]]; then
    printf "%s\n" ".env.test exists. Skipped."
    return
  fi

  printf "%s\n" "$prefix .env.test..."
  cp "$template_path" "$output_path"
}
export -f create_test_environment

# Label: Create Procfile (development)
# Description: Create Procfile for development environment.
create_development_procfile() {
  local prefix="${1:-Creating}"
  local template_path="$TEMPLATES_ROOT/Procfile.dev.tt"
  local output_path="$PROJECT_ROOT/Procfile.dev"

  if [[ -f "$output_path" ]]; then
    printf "%s\n" "Procfile.dev exists. Skipped."
    return
  fi

  cp "$template_path" "$output_path"
  printf "%s\n" "$prefix Procfile.dev..."
}
export -f create_development_procfile

# Label: Create Docker Compose Development Configuration
# Description: Create Docker Compose configuration for development environment.
create_docker_compose_development_configuration() {
  local prefix="${1:-Creating}"
  local template_path="$TEMPLATES_ROOT/compose.dev.yml.tt"
  local output_path="$PROJECT_ROOT/compose.dev.yml"

  if [[ -f "$output_path" ]]; then
    printf "%s\n" "compose.dev.yml exists. Skipped."
    return
  fi

  cp "$template_path" "$output_path"
  printf "%s\n" "$prefix compose.dev.yml..."
}
export -f create_docker_compose_development_configuration

# Label: Install Gems
# Description: Install gem dependencies.
install_gems() {
  printf "%s\n" "Installing gem dependencies..."
  bundle install
}
export -f install_gems

# Label: Install Packages
# Description: Install JavaScript package dependencies.
install_packages() {
  printf "%s\n" "Installing package dependencies..."
  npm install
}
export -f install_packages

# Label: Prepare Database
# Description: Prepare database for development and test environments.
prepare_database() {
  printf "%s\n" "Preparing databases..."
  bundle exec hanami db prepare
}
export -f prepare_database
