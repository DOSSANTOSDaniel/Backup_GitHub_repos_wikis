#!/usr/bin/env bash

#************************************************#                    
# Auteur:  <dossantosjdf@gmail.com>              
# Date:    29/11/2023                                                               
#                                                
# Rôle:                                          
# Ce script permet d'exporter les dépôts et les pages wikis
# d'un compte GitHub, dans le but de créer des sauvegardes.
#
# Prérequis
# * Avoir un compte GitHub
# * Avoir un Personal access tokens (classic)
#
# Usage:   ./gh_backup.sh
#************************************************#

## Variables
gh_user='DOSSANTOSDaniel'
gh_hostname='GitHub.com'
gh_token=''
gh_limit_repos=100

backup_dir="$HOME/Backup_github_$(date +%F_%H%M%S)"
repos_wikis=''

## Main
### Dependencies
if ! command -v "gh"
then
  echo "Pour pouvoir utiliser ce script il faut installer gh"
  exit 1
fi

### GitHub Token
read -srp "Token GitHub : " gh_token

### Connection to github.com
gh auth login --hostname "$gh_hostname" --with-token "$gh_token"

### list of repos
gh_repos="$(gh repo list "$gh_user" --limit "$gh_limit_repos" --json name --jq ".[].name")"

### Backups repos and wikis
if [ -n "$gh_repos" ]
then
  mkdir -p "$backup_dir"/{Repos,Wikis}
  for repo in $gh_repos
  do
    gh repo clone "$repo" "$backup_dir/Repos/$repo" || echo "Erreur de téléchargement de : $repo"
    gh repo clone "$repo.wiki" "$backup_dir/Wikis/$repo" > /dev/null 2>&1
  done
else
  echo "Vous n'avez pas de dépôts GitHub"
fi
