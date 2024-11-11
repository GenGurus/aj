 #!/bin/sh
#printf '\033[8;29;252t'
tmux new-session -d -x 252 -y 29

tmux split-window -v
tmux split-window -h
tmux select-pane -t 1
tmux split-window -h
tmux split-window -h
tmux select-pane -t 1
tmux split-window -v


tmux resize-pane -t 2 -L 55
tmux resize-pane -t 3 -D 20
tmux resize-pane -t 4 -L 25
tmux resize-pane -t 5 -R 20

tmux send-keys -t 1 'ranger' Enter 
tmux send-keys -t 2 'ytp -q -n lofi 1 hour' Enter
tmux send-keys -t 3 'v' Enter
tmux send-keys -t 4 'v' Enter
tmux send-keys -t 5 'lol'
tmux send-keys -t 6 'cava' Enter

tmux send-keys -t 2 '5' Enter

tmux a #
