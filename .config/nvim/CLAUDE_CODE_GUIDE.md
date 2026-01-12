# Claude Code + Neovim Integration Guide

Плагин `claudecode.nvim` установлен с **дефолтной конфигурацией** (без кастомизаций).

## Основные команды

### Управление окном Claude Code

- `:ClaudeCode` - Открыть/закрыть окно Claude Code
- `:ClaudeCodeFocus` - Переключиться на окно Claude Code (умный toggle)

### Работа с контекстом

- `:ClaudeCodeSend` - Отправить выделенный текст в Claude как контекст (в visual mode)
- `:ClaudeCodeAdd <file> [start] [end]` - Добавить файл с опциональным диапазоном строк

### Изменения кода

- `:ClaudeCodeDiffAccept` - Принять изменения предложенные Claude
- `:ClaudeCodeDiffDeny` - Отклонить изменения

### Выбор модели

- `:ClaudeCodeSelectModel` - Выбрать модель Claude (Sonnet, Opus, Haiku)

## Горячие клавиши

Все клавиши используют `<leader>` prefix (в LazyVim это пробел):

| Клавиши | Действие | Режим |
|---------|----------|-------|
| `<leader>ac` | Toggle окно Claude Code | Normal |
| `<leader>af` | Focus на окно Claude | Normal |
| `<leader>as` | Отправить выделенное в Claude | Visual |
| `<leader>am` | Выбрать модель | Normal |
| `<leader>aa` | Принять изменения | Normal |
| `<leader>ar` | Отклонить изменения | Normal |

> **Примечание:** Все хоткеи работают как на английской, так и на русской раскладке благодаря настройке langmap в вашем конфиге.

## Автоматические функции

### Auto-reload файлов

Neovim автоматически перезагружает файлы, измененные Claude Code снаружи редактора:
- При переключении на окно Neovim (`FocusGained`)
- При входе в буфер (`BufEnter`)
- При остановке курсора (`CursorHold`)

Вы увидите уведомление: `File reloaded from disk`

### WebSocket сервер

Плагин автоматически запускает WebSocket MCP сервер при загрузке Neovim. Claude Code CLI автоматически подключается к нему.

## Рабочий процесс

### 1. Базовое использование

```
1. Открыть файл в Neovim
2. Нажать <Space>ac - откроется Claude Code
3. Задать вопрос или дать инструкцию Claude
4. Claude автоматически видит текущий файл и может его редактировать
```

### 2. Отправка контекста

```
1. Выделить код в Visual mode (v)
2. Нажать <Space>as
3. Выделенный код с информацией о файле отправится в Claude
```

### 3. Принятие изменений

```
1. Claude предложит изменения (diff)
2. Просмотреть изменения
3. Нажать <Space>aa для принятия или <Space>ar для отклонения
```

## Конфигурация

Конфигурация находится в: `/root/.config/nvim/lua/plugins/claudecode.lua`

### Текущая конфигурация

Установлена **минимальная дефолтная конфигурация** + хоткеи:

```lua
return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  config = true,  -- Использует все дефолтные настройки

  -- Key mappings
  keys = {
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude Code" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept Claude changes" },
    { "<leader>ar", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Reject Claude changes" },
  },
}
```

### Дефолтные настройки

Плагин использует следующие значения по умолчанию:
- **port_range**: `{min = 10000, max = 65535}`
- **auto_start**: `true` (автозапуск WebSocket сервера)
- **log_level**: `"info"`
- **track_selection**: `true` (отслеживание выделения)
- **terminal.split_side**: автоматически
- **terminal_cmd**: автоматически находит `claude` в PATH

### Кастомизация (опционально)

Если хотите изменить настройки, замените `config = true` на:

```lua
opts = {
  -- Например, изменить уровень логирования
  log_level = "debug",
  -- Или указать конкретный путь к Claude
  terminal_cmd = "/root/.local/bin/claude",
}
```

## Устранение проблем

### Claude Code не подключается

```bash
# Проверить версию Claude Code
claude --version

# Перезапустить Neovim
:qa!
nvim
```

### Файлы не обновляются автоматически

Принудительная перезагрузка:
```vim
:checktime
```

### Проверить работу WebSocket сервера

```vim
:messages
```

Должно быть сообщение: `Claude MCP server started: /tmp/nvim-claude.sock`

## Дополнительная информация

- **Плагин**: [claudecode.nvim](https://github.com/coder/claudecode.nvim)
- **Claude Code CLI**: [claude-code](https://github.com/anthropics/claude-code)
- **LazyVim**: [lazyvim.org](https://www.lazyvim.org/)

## Полезные команды Neovim

- `:Lazy` - Открыть менеджер плагинов
- `:Lazy sync` - Синхронизировать/обновить плагины
- `:checkhealth claudecode` - Проверить здоровье плагина (если доступно)
- `:messages` - Просмотреть сообщения системы

---

**Совет:** Начните с простого - откройте файл, нажмите `<leader>ac` и попросите Claude объяснить код или сделать рефакторинг!
