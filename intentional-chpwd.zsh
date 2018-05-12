# meant to be sourced from .zshrc

# IntentionalChpwd__functions_onDedupedChange
# IntentionalChpwd__functions_onChange
# IntentionalChpwd__functions_onIncludingSubshellChange

IntentionalChpwd__init() {
  IntentionalChpwd__lastWorkingDir="$(pwd)"
}

IntentionalChpwd__chpwd_run() {
  IntentionalChpwd__runFunctions "${(@)IntentionalChpwd__functions_onIncludingSubshellChange}"

  if [ "$ZSH_SUBSHELL" != 0 ]; then return; fi

  IntentionalChpwd__runFunctions "${(@)IntentionalChpwd__functions_onChange}"

  if [ "$(pwd)" = "$IntentionalChpwd__lastWorkingDir" ]; then return; fi

  IntentionalChpwd__lastWorkingDir="$(pwd)"
  IntentionalChpwd__runFunctions "${(@)IntentionalChpwd__functions_onDedupedChange}"
}

IntentionalChpwd__runFunctions() {
  local fn
  for fn in "$@"; do
    "$fn"
  done
}

IntentionalChpwd__debugHooks() {
  IntentionalChpwd__debug_onDedupedChange()           { echo 'chpwd_dedupedChange' }
  IntentionalChpwd__debug_onChange()                  { echo 'chpwd_change' }
  IntentionalChpwd__debug_onIncludingSubshellChange() { echo 'chpwd_includingSubshellChange'}

  IntentionalChpwd__functions_onDedupedChange=("${(@)IntentionalChpwd__functions_onDedupedChange:#IntentionalChpwd__debug_onDedupedChange}")
  IntentionalChpwd__functions_onChange=("${(@)IntentionalChpwd__functions_onChange:#IntentionalChpwd__debug_onChange}")
  IntentionalChpwd__functions_onIncludingSubshellChange=("${(@)IntentionalChpwd__functions_onIncludingSubshellChange:#IntentionalChpwd__debug_onIncludingSubshellChange}")

  IntentionalChpwd__functions_onDedupedChange+=(IntentionalChpwd__debug_onDedupedChange)
  IntentionalChpwd__functions_onChange+=(IntentionalChpwd__debug_onChange)
  IntentionalChpwd__functions_onIncludingSubshellChange+=(IntentionalChpwd__debug_onIncludingSubshellChange)
}

IntentionalChpwd__replaceExistingChpwd() {
  IntentionalChpwd__functions_onDedupedChange=("${(@)chpwd_functions:#IntentionalChpwd__chpwd_run}")
  chpwd_functions=(IntentionalChpwd__chpwd_run)
}

IntentionalChpwd__softInstall() {
  chpwd_functions+=(IntentionalChpwd__chpwd_run)
}

IntentionalChpwd__onLoad() {
  IntentionalChpwd__init

  case "$IntentionalChpwd__option_install" in
    soft)
      IntentionalChpwd__softInstall
      ;;
    manual)
      ;;
    *)
      IntentionalChpwd__replaceExistingChpwd
      ;;
  esac
}

IntentionalChpwd__onLoad
