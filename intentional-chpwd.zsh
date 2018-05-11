# meant to be sourced from .zshrc

raw_chpwd_functions=("$chpwd_functions[@]")

_intentional_chpwd() {
  if [ "$ZSH_SUBSHELL" = 0 ]; then
    for FN in $chpwd_functions[@]; do
      "$FN"
    done
  fi
}
chpwd_functions=(_intentional_chpwd)
