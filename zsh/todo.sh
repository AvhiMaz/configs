#!/bin/bash

TODO_FILE="$HOME/.todos.txt"

if [ ! -f "$TODO_FILE" ]; then
  touch "$TODO_FILE"
fi

case "$1" in
  add|a)
    shift
    echo "[ ] $*" >> "$TODO_FILE"
    echo "Added: $*"
    ;;

  done|d)
    if [ -z "$2" ]; then
      echo "Usage: todo done <number>"
      exit 1
    fi
    sed -i.bak "${2}s/\[ \]/[x]/" "$TODO_FILE" && rm "$TODO_FILE.bak"
    echo "Marked task $2 as done"
    ;;

  remove|rm|r)
    if [ -z "$2" ]; then
      echo "Usage: todo remove <number>"
      exit 1
    fi
    sed -i.bak "${2}d" "$TODO_FILE" && rm "$TODO_FILE.bak"
    echo "Removed task $2"
    ;;

  clear|c)
    sed -i.bak '/\[x\]/d' "$TODO_FILE" && rm "$TODO_FILE.bak"
    echo "Cleared completed tasks"
    ;;

  list|l)
    if [ -s "$TODO_FILE" ]; then
      grep -n "\[ \]" "$TODO_FILE" | while IFS=: read num line; do
        task=$(echo "$line" | sed 's/\[ \] //')
        printf "%6d  %s\n" "$num" "$task"
      done
    else
      echo "No todos!"
    fi
    ;;

  all)
    if [ -s "$TODO_FILE" ]; then
      echo ""
      echo "Pending:"
      grep -n "\[ \]" "$TODO_FILE" | while IFS=: read num line; do
        task=$(echo "$line" | sed 's/\[ \] //')
        printf "  %d  %s\n" "$num" "$task"
      done

      echo ""
      echo "Completed:"
      grep -n "\[x\]" "$TODO_FILE" | while IFS=: read num line; do
        task=$(echo "$line" | sed 's/\[x\] //')
        printf "  %d  %s\n" "$num" "$task"
      done
      echo ""
    else
      echo "No todos!"
    fi
    ;;

  stats|s)
    if [ ! -s "$TODO_FILE" ]; then
      echo "No todos!"
      exit 0
    fi

    total=$(wc -l < "$TODO_FILE" | tr -d ' ' | tr -d '\n')
    completed=$(grep -c "\[x\]" "$TODO_FILE" 2>/dev/null | tr -d '\n' || echo "0")
    pending=$(grep -c "\[ \]" "$TODO_FILE" 2>/dev/null | tr -d '\n' || echo "0")

    echo ""
    echo "Stats:"
    echo "  Total:     $total"
    echo "  Pending:   $pending"
    echo "  Completed: $completed"

    if [ "$total" -gt 0 ] && [ "$completed" -ge 0 ]; then
      percent=$((completed * 100 / total))
      echo "  Progress:  $percent%"
    fi
    echo ""
    ;;

  display)
    if [ ! -s "$TODO_FILE" ]; then
      echo "        No pending tasks"
      return
    fi

    grep -n -v "\[x\]" "$TODO_FILE" | while IFS=: read num line; do
      task=$(echo "$line" | sed 's/\[ \] //')
      if [ ${#task} -gt 47 ]; then
        task="${task:0:44}..."
      fi
      printf "        %d  %s\n" "$num" "$task"
    done
    ;;

  *)
    echo "Simple TODO Manager"
    echo ""
    echo "Usage:"
    echo "  todo add <task>       Add a new task        (shortcut: todo a)"
    echo "  todo list             List pending tasks    (shortcut: todo l)"
    echo "  todo all              Show all tasks (pending + completed)"
    echo "  todo done <number>    Mark task as done     (shortcut: todo d)"
    echo "  todo remove <number>  Remove a task         (shortcut: todo r)"
    echo "  todo clear            Clear completed tasks (shortcut: todo c)"
    echo "  todo stats            Show statistics       (shortcut: todo s)"
    echo ""
    ;;
esac
