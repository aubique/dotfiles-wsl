PASSWORD_STORE_EXTENSION_COMMANDS="fzf"
source /usr/share/bash-completion/completions/pass

 _passa(){
     PASSWORD_STORE_DIR=$PASSWORD_STORE_DIR/alex _pass
 }
 complete -o filenames -o nospace -F _passa passa

 _passe(){
     PASSWORD_STORE_DIR=$PASSWORD_STORE_DIR/ensibs _pass
 }
 complete -o filenames -o nospace -F _passe passe

 _passf(){
     PASSWORD_STORE_DIR=$PASSWORD_STORE_DIR/fam _pass
 }
 complete -o filenames -o nospace -F _passf passf

 _passm(){
     PASSWORD_STORE_DIR=$PASSWORD_STORE_DIR/misc _pass
 }
 complete -o filenames -o nospace -F _passm passm

 _passu(){
     PASSWORD_STORE_DIR=$PASSWORD_STORE_DIR/ubiq _pass
 }
 complete -o filenames -o nospace -F _passu passu
