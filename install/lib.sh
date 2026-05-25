#!/bin/zsh
# Shared functions sourced by install.sh before running each installer.

# install_dotfile <src_dir> <src_file> <dest_relative_to_home>
#
# Creates a symlink at ~/<dest> pointing to <src_dir>/<src_file>.
# Backs up any existing non-symlink to <dest>.old.
# Skips silently if the symlink already points into DOTFILES_ROOT.
install_dotfile() {
  local src_dir=$1 src_file=$2 dest=$3
  local src="$src_dir/$src_file"
  local target=~/"$dest"

  if [[ -L "$target" ]]; then
    local link_dest
    link_dest=$(readlink -f "$target" 2>/dev/null || readlink "$target")
    [[ "$link_dest" == "$DOTFILES_ROOT"/* ]] && return 0
  fi

  if [[ -e "$target" ]]; then
    echo "Backing up $dest to $dest.old"
    mv "$target" "$target.old"
  fi

  local target_dir
  target_dir=$(dirname "$target")
  [[ -d "$target_dir" ]] || mkdir -p "$target_dir"

  echo "Setting up $target"
  ln -s "$src" "$target"
}

# install_bundles <repo_list_file> <install_dir> <description> [blacklist]
#
# Clones or updates git repos listed in <repo_list_file> into <install_dir>.
# Each line: <url> [optional-name]  (blank lines and missing names are handled)
# Blacklisted names (space-separated string) are skipped.
install_bundles() {
  [[ "$LOCAL_ONLY" == "true" ]] && return 0

  local repo_list=$1 install_dir=$2 description=$3 blacklist=${4:-}

  while IFS=$'\n' read -r line || [[ -n "$line" ]]; do
    local url name
    read -r url name <<< "$line"
    [[ -z "$url" ]] && continue
    [[ -z "$name" ]] && name=${url##*/} && name=${name%.git}

    local skip=0
    for exclude in ${=blacklist}; do
      [[ "$exclude" == "$name" ]] && skip=1 && break
    done

    if (( skip )); then
      echo "[$description] Skipping blacklisted bundle $name"
      continue
    fi

    if [[ ! -d "$install_dir/$name" ]]; then
      echo "[$description] Cloning $name"
      git clone "$url" "$install_dir/$name"
    else
      echo "[$description] Updating $name"
      local branch remote remote_url
      branch=$(git -C "$install_dir/$name" symbolic-ref -q --short HEAD 2>/dev/null)
      remote=$(git -C "$install_dir/$name" config "branch.${branch}.remote" 2>/dev/null)
      remote_url=$(git -C "$install_dir/$name" config "remote.${remote}.url" 2>/dev/null)
      if [[ -z "$remote" ]]; then
        echo "[$description] Unable to determine branch/remote for $name"
      elif [[ "$remote_url" == "$url" ]]; then
        git -C "$install_dir/$name" pull
      else
        echo "[$description] Warning: $name remote changed ($remote_url => $url)"
      fi
    fi
  done < "$repo_list"
}
