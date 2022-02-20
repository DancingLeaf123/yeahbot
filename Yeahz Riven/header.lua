return {
  id = "Yeahz_riven",
  name = "Yeahz Riven",
  author_cn = "叶子",
  type = "Champion",
  author = "Yeahz",
  flag = {
    text = "Yeahz",
    color = {
      text = 0xFF11EEEE,
      background1 = 0xFF11EEEE,
      background2 = 0xFF000000
    }
  },
  shard = {
    "common",
    "chase",
    "drawtest",
    "flee",
    "header",
    "main",
    "menu",
    "pushtest",
    "Yeahtest",
    "core/ai",
    "core/draw",
    "core/main",
    "item/crescent_wrapper",
    "pred/aa",
    "pred/e_flash_q",
    "pred/e_flash_w",
    "pred/e_q",
    "pred/e_w",
    "pred/e",
    "pred/flash_q",
    "pred/flash_w",
    "pred/main",
    "pred/push",
    "pred/q",
    "pred/r1",
    "pred/r2_dmg",
    "pred/r2",
    "pred/w",
    "spell/e",
    "spell/flash",
    "spell/main",
    "spell/q",
    "spell/r1",
    "spell/r2",
    "spell/w"
  },
  description = [[
  ++++++++++++++
  Based on gagong riven
  Add
  flee， walljump
  better farm setting
  permashow
  
  version 0219
  ++++++++++++++
  
  Some features are still in development
  contact me if you have some feedback or features suggestion
  t.me/Yeahz_hanbot3
  ]],
  description_cn = [[

    ++++++++++++++
    基于 gagon riven增加了一些功能，
    跳墙逃跑
    发育设置
    permashow

    ++++++++++++++
  
    一些功能还在开发中
    如果您有一些反馈或功能建议，请与我联系
    t.me/Yeahz_hanbot3
  ]],
  icon_url = "https://raw.githubusercontent.com/DancingLeaf123/LeetCode/main/icon.jpg",
  load = function()
    return player.charName == "Riven"
  end
}
