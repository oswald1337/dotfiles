# Dotfiles

macOS setup and application config managed with Homebrew and GNU Stow.

## Layout

Each top-level package mirrors the path where its files should appear from
`$HOME`.

```text
nvim/.config/nvim/          -> ~/.config/nvim
ghostty/.config/ghostty/    -> ~/.config/ghostty
yazi/.config/yazi/          -> ~/.config/yazi
kitty/.config/kitty/        -> ~/.config/kitty
karabiner/.config/karabiner -> ~/.config/karabiner
aerospace/.aerospace.toml   -> ~/.aerospace.toml
zsh/.zshrc                  -> ~/.zshrc
gh/.config/gh/config.yml    -> ~/.config/gh/config.yml
```

## Install

```sh
./install.sh
```

To preview the symlinks without changing anything:

```sh
./install.sh --dry-run --skip-brew --skip-macos
```

The installer backs up existing real files or directories that would conflict
with Stow links into `~/.dotfiles-backup/<timestamp>/`.

## Package Management

Packages and apps live in `Brewfile`.

```sh
brew bundle --file Brewfile
```

To link or unlink one package manually:

```sh
stow --target "$HOME" nvim
stow --delete --target "$HOME" nvim
```
