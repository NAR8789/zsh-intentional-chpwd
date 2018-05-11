# meant to be sourced from .zshrc

_raw_chpwd_functions=("$chpwd_functions[@]")

_intentional_chpwd() {
  if [ "$ZSH_SUBSHELL" = 0 ]; then
    local FN
    for FN in "$_raw_chpwd_functions[@]"; do
      "$FN"
    done
  fi
}
chpwd_functions=(_intentional_chpwd)
