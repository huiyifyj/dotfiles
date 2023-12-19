#!/usr/bin/env bash

# Use zsh as default shell
# chsh -s /bin/zsh


# Clone Spaceship theme for zsh.
git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
# Set ZSH_THEME="spaceship" in your .zshrc
# To work correctly, you will first need:
#     zsh (v5.2 or recent) must be installed.
#     Powerline Font must be installed and used in your terminal (for example, switch font to Fira Code).

# Install zsh-completions
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions --depth=1
# Enable it in your .zshrc by adding it to your plugin list and reloading the completion:
#     plugins=(… zsh-completions)
#     autoload -U compinit && compinit

# Install zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting --depth=1
# Activate the plugin in ~/.zshrc:
#     plugins=(... zsh-syntax-highlighting)

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions --depth=1
# Add the plugin to the list of plugins for Oh My Zsh to load (inside ~/.zshrc):
#     plugins=(... zsh-autosuggestions)
