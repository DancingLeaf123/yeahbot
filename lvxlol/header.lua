local supported_champion = {
  ['Ezreal'] = true,
  ['Lucian'] = true,
}

return {
  id = 'lvxlol',
  name = 'LVxLoL Expert',
  load = function() 
    return supported_champion[player.charName]
  end,
  flag = {
    text = 'lvxlol',
    color = {
      text = 0xff8b0000 ,
      background1 = 0xff1e1e1e,
      background2 = 0xffebebeb,    
    },
  },
}