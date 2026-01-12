# Config

Мои конфиги для быстрой настройки рабочего окружения.

![example](example.png)

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

## Рекомендация

Перебиндить Caps Lock на Ctrl — так удобнее нажимать хоткеи:

```bash
# Linux (X11)
setxkbmap -option ctrl:nocaps

# Для Wayland добавить в конфиг композитора
```