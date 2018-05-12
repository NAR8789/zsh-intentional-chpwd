# meant to be sourced from .zshrc

### core ###

IntentionalChpwd__init() {
  IntentionalChpwd__lastWorkingDir="$(pwd)"
}

IntentionalChpwd__chpwd_run() {
  IntentionalChpwd__runFunctions ${(@)IntentionalChpwd__functions_onDiscardedChange}

  if [ "$ZSH_SUBSHELL" != 0 ]; then return; fi

  IntentionalChpwd__runFunctions ${(@)IntentionalChpwd__functions_onTrivialChange}

  if [ "$(pwd)" = "$IntentionalChpwd__lastWorkingDir" ]; then return; fi

  IntentionalChpwd__lastWorkingDir="$(pwd)"
  IntentionalChpwd__runFunctions ${(@)IntentionalChpwd__functions_onChange}
}

IntentionalChpwd__runFunctions() {
  local fn
  for fn in "$@"; do
    "$fn"
  done
}


### util ###

IntentionalChpwd__ls() {
  echo "chpwd_functions: (${(j:, :)chpwd_functions})"
  echo "functions_onDiscardedChange: (${(j:, :)IntentionalChpwd__functions_onDiscardedChange})"
  echo "functions_onTrivialChange: (${(j:, :)IntentionalChpwd__functions_onTrivialChange})"
  echo "functions_onChange: (${(j:, :)IntentionalChpwd__functions_onChange})"
}

IntentionalChpwd__functions_dedupe() {
  chpwd_functions=("${(@u)chpwd_functions}")
  IntentionalChpwd__functions_onDiscardedChange=("${(@u)IntentionalChpwd__functions_onDiscardedChange}")
  IntentionalChpwd__functions_onTrivialChange=("${(@u)IntentionalChpwd__functions_onTrivialChange}")
  IntentionalChpwd__functions_onChange=("${(@u)IntentionalChpwd__functions_onChange}")
}

IntentionalChpwd__debugHooks() {
  IntentionalChpwd__debug_onChange()          { echo 'chpwd_onChange' }
  IntentionalChpwd__debug_onTrivialChange()   { echo 'chpwd_onTrivialChange' }
  IntentionalChpwd__debug_onDiscardedChange() { echo 'chpwd_onDiscardedChange'}

  IntentionalChpwd__functions_onChange=("${(@)IntentionalChpwd__functions_onChange:#IntentionalChpwd__debug_onChange}")
  IntentionalChpwd__functions_onTrivialChange=("${(@)IntentionalChpwd__functions_onTrivialChange:#IntentionalChpwd__debug_onTrivialChange}")
  IntentionalChpwd__functions_onDiscardedChange=("${(@)IntentionalChpwd__functions_onDiscardedChange:#IntentionalChpwd__debug_onDiscardedChange}")

  IntentionalChpwd__functions_onChange+=(IntentionalChpwd__debug_onChange)
  IntentionalChpwd__functions_onTrivialChange+=(IntentionalChpwd__debug_onTrivialChange)
  IntentionalChpwd__functions_onDiscardedChange+=(IntentionalChpwd__debug_onDiscardedChange)
}


### loader ###

IntentionalChpwd__replaceExistingChpwd() {
  IntentionalChpwd__functions_onChange+=("${(@)chpwd_functions:#IntentionalChpwd__chpwd_run}")
  chpwd_functions=(IntentionalChpwd__chpwd_run)
}

IntentionalChpwd__softInstall() {
  chpwd_functions=("${(@)chpwd_functions:#IntentionalChpwd__chpwd_run}")
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
    replace_existing)
      IntentionalChpwd__replaceExistingChpwd
      ;;
    '')
      IntentionalChpwd__replaceExistingChpwd
      ;;
    *)
      echo "WARN: invalid option IntentionalChpwd__option_install='$IntentionalChpwd__option_install'. Must be one of 'soft', 'manual', or 'replace_existing'. defaulting to 'replace_existing'"
      IntentionalChpwd__replaceExistingChpwd
      ;;
  esac
}

### load! ###

IntentionalChpwd__onLoad
