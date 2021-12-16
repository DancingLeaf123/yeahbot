Question list

1.  Riven R2 range.

   ` range = (1100-100)^2, `

   why there is (1100-100)^2,  but not just 1100(wiki range), for -100, I think it increase hit rate, but why ^2

2.  Riven e_q or e_w combo spell cooldown check,

    ```lua
    local get_spell_state = function()
      return e.is_ready() and q.is_ready(0.150)
    end
    ```

      I have check the E.windUpTime  and E.animationTime, they'are both not equal to 0.15,  so what's 0.15 means, How can I determine this number
    
3.  what is game.tickID

    ```lua
      if game.tickID ~= tickID then
        obj = get_nearest_minion_to_mouse()
        tickID = game.tickID
      end
    ```

4.  is there still have items module

    ```lua
    local items = module.internal('items')
    ```

5.  ![image-20211202165444451](C:\Users\Yez\AppData\Roaming\Typora\typora-user-images\image-20211202165444451.png)

    why it need to - 80 in these places. 

6.  