# meant to be sourced from .zshrc

IntentionalChpwd__functions_onDedupedChange=()
IntentionalChpwd__functions_onChange=()
IntentionalChpwd__functions_onIncludingSubshellChange=()

IntentionalChpwd__lastWorkingDir="$(pwd)"

IntentionalChpwd__runFunctions() {
  local fn
  for fn in "$@"; do
    "$fn"
  done
}

IntentionalChpwd__chpwd_run() {
  IntentionalChpwd__runFunctions "${IntentionalChpwd__functions_onIncludingSubshellChange[@]}"

  if [ "$ZSH_SUBSHELL" != 0 ]; then return; fi

  IntentionalChpwd__runFunctions "${IntentionalChpwd__functions_onChange[@]}"

  if [ "$(pwd)" = "$IntentionalChpwd_lastWorkingDir" ]; then return; fi

  IntentionalChpwd__lastWorkingDir="$(pwd)"
  IntentionalChpwd__runFunctions "${IntentionalChpwd__functions_onDedupedChange[@]}"
}

IntentionalChpwd__functions_onDedupedChange=("${chpwd_functions[@]}")
chpwd_functions=(IntentionalChpwd__chpwd_run)
