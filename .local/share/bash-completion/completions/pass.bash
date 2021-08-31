PASSWORD_STORE_EXTENSION_COMMANDS="fzf"
source /usr/share/bash-completion/completions/pass

 _passe(){
     PASSWORD_STORE_DIR=$PASSWORD_STORE_DIR/ensibs _pass
 }
 complete -o filenames -o nospace -F _passe passe

 _passu(){
     PASSWORD_STORE_DIR=$PASSWORD_STORE_DIR/ubiq _pass
 }
 complete -o filenames -o nospace -F _passu passu

 _passm(){
     PASSWORD_STORE_DIR=$PASSWORD_STORE_DIR/matv _pass
 }
 complete -o filenames -o nospace -F _passm passm

