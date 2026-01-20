return {
  "folke/which-key.nvim",
  opts = {
    filter = function(mapping)
      -- Скрываем маппинги с кириллицей (созданные langmapper)
      local lhs = mapping.lhs or ""
      if lhs:match("[а-яёА-ЯЁ]") then
        return false
      end
      return true
    end,
  },
}
