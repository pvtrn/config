# Config

Мои конфиги для быстрой настройки рабочего окружения.

![example](example.png)

## Установка зависимостей

```bash
# Ubuntu/Debian - последняя версия Neovim
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install neovim tmux -y
# Claude Code - https://github.com/anthropics/claude-code
curl -fsSL https://claude.ai/install.sh | bash
```

## Быстрая установка

```bash
git clone https://github.com/pvtrn/config.git /tmp/config && cp -r /tmp/config/.config/nvim ~/.config/ && cp /tmp/config/.tmux.conf ~/ && rm -rf /tmp/config
```

## Neovim

Кастомный конфиг на основе [LazyVim](https://www.lazyvim.org/) с темой VSCode Dark, оптимизированной для прозрачного тёмного фона терминала.

## Tmux

Конфиг tmux с удобными биндингами:
- `Ctrl+A` — префикс (вместо стандартного `Ctrl+B`)
- `Alt+←/→` — переключение между табами

## Если что-то не работает

Очистить кэш neovim и пересинхронизировать плагины:

```bash
rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim && nvim
```

После запуска выполнить `:Lazy sync`

## Рекомендация

Перебиндить Caps Lock на Ctrl — так удобнее нажимать хоткеи:

## Как пользоваться Claude Code

[https://github.com/anthropics/claude-code](https://github.com/anthropics/claude-code)

```bash
# Linux (X11)
setxkbmap -option ctrl:nocaps

# Для Wayland добавить в конфиг композитора
```

## Запуск

```bash
tmux
nvim

```
