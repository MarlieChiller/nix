###
 # @FilePath: /sketchybar/items/left/spaces.sh
 # @author: Wibus
 # @Date: 2022-08-01 21:17:08
 # @LastEditors: Wibus
 # @LastEditTime: 2022-08-01 21:17:18
 # Coding With IU
### 

sketchybar --add event aerospace_workspace_change
for sid in $(aerospace list-workspaces --all); do
    sketchybar --add item space.$sid left \
        --subscribe space.$sid aerospace_workspace_change \
        --set space.$sid \
        background.color=0x44ffffff \
        background.corner_radius=5 \
        background.height=20 \
        background.drawing=off \
        label="$sid" \
        click_script="aerospace workspace $sid" \
        script="$HOME/Projects/nix/home-manager/darwin/sketchybar/plugins/aerospace.sh $sid"
done



sketchybar --add item space_separator left \
           --set space_separator icon= \
                                 background.padding_left=23 \
                                 background.padding_right=23 \
                                 label.drawing=off \
                                 icon.color=0xff92B3F5

sketchybar --add item window_title left \
           --set window_title    script="$HOME/Projects/nix/home-manager/darwin/sketchybar/plugins/window_title.sh" \
                                 icon.drawing=off \
                                 label.color=0xffb7bdf4 \
           --subscribe window_title front_app_switched
