-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Mapping английских букв в русские (QWERTY -> ЙЦУКЕН)
local en_to_ru = {
  q = "й", w = "ц", e = "у", r = "к", t = "е", y = "н", u = "г", i = "ш", o = "щ", p = "з",
  a = "ф", s = "ы", d = "в", f = "а", g = "п", h = "р", j = "о", k = "л", l = "д",
  z = "я", x = "ч", c = "с", v = "м", b = "и", n = "т", m = "ь",
  Q = "Й", W = "Ц", E = "У", R = "К", T = "Е", Y = "Н", U = "Г", I = "Ш", O = "Щ", P = "З",
  A = "Ф", S = "Ы", D = "В", F = "А", G = "П", H = "Р", J = "О", K = "Л", L = "Д",
  Z = "Я", X = "Ч", C = "С", V = "М", B = "И", N = "Т", M = "Ь",
}

-- Функция для конвертации английского хоткея в русский
local function en_to_ru_keymap(keymap)
  local result = keymap
  for en, ru in pairs(en_to_ru) do
    result = result:gsub(en, ru)
  end
  return result
end

-- Helper функция для создания keymaps работающих на обеих раскладках
-- Автоматически создает русский дубликат из английского хоткея
local function keymap_both_layouts(mode, en_keys, action, opts)
  local ru_keys = en_to_ru_keymap(en_keys)
  vim.keymap.set(mode, en_keys, action, opts)
  vim.keymap.set(mode, ru_keys, action, opts)
end

-- Reload nvim configuration
local reload_config = function()
  -- Очищаем кэш и перезагружаем config модули
  for name, _ in pairs(package.loaded) do
    if name:match("^config") then
      package.loaded[name] = nil
    end
  end

  -- Перезагружаем config модули
  require("config.options")
  require("config.keymaps")
  require("config.autocmds")

  vim.notify("Config reloaded!", vim.log.levels.INFO)
end

keymap_both_layouts("n", "<leader>r", reload_config, { desc = "Reload nvim config" })
