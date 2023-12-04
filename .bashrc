[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
#

[[ $- != *i* ]] && return

colors() {
	local fgc bgc vals seq0

	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

	# foreground kicolors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black

			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}

			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Change the window title of X terminals
case ${TERM} in
	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)		
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'

		;;
	screen*)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
		;;
esac

use_color=true

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
	&& type -P dircolors >/dev/null \
xhost +local:root > /dev/null 2>&1
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	if type -P dircolors >/dev/null ; then
		if [[ -f ~/.dir_colors ]] ; then
			eval $(dircolors -b ~/.dir_colors)
		elif [[ -f /etc/DIR_COLORS ]] ; then
			eval $(dircolors -b /etc/DIR_COLORS)
		fi
	fi

	if [[ ${EUID} == 0 ]] ; then
		PS1='\[\033[01;31m\][\h\[\033[01;36m\] \W\[\033[01;31m\]]\$\[\033[00m\] '
	else
		PS1='\[\033[01;32m\][\u@\h\[\033[01;37m\] \W\[\033[01;32m\]]\$\[\033[00m\] '
	fi

	alias ls='ls --color=auto'
	alias grep='grep --colour=auto'
	alias egrep='egrep --colour=auto'
	alias fgrep='fgrep --colour=auto'
else
	if [[ ${EUID} == 0 ]] ; then
		# show root@ when we don't have colors
		PS1='\u@\h \W \$ '
	else
		PS1='\u@\h \w \$ '
	fi
fi

unset use_color safe_term match_lhs sh

alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias np='nano -w PKGBUILD'
alias more=less

xhost +local:root > /dev/null 2>&1

complete -cf sudo

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

shopt -s expand_aliases

# export QT_SELECT=4

# Enable history appending instead of overwriting.  #139609
shopt -s histappend

#
# # ex - archive extractor
# # usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

## ERIC ####


export EDITOR=vim


# ajout du dossier script au PATH 
if [[ ":$PATH:" != *":~/scripts:"* ]]; then
    PATH="${PATH:+"$PATH:"}~/scripts"
fi

# ajout du dossier au PATH
export PATH="/home/ebsd/.gem/ruby/3.0.0/bin/:$PATH"

# sources les autres fichiers .bashrc
for file in ~/.bashrc.d/*.bashrc;
do
        source "$file"
done


alias vpn="cd /etc/openvpn && sudo /usr/sbin/openvpn /etc/openvpn/client1.conf"
md2pdf () {
	cd $(dirname $1.md)
        pandoc $1.md -o $1.pdf --from markdown --template eisvogel --toc --number-sections --highlight-style breezedark -H ~/.pandoc/templates/head.tex --metadata-file=/home/ebsd/.pandoc/templates/metadata.yaml --filter /usr/bin/pandoc-latex-environment
	cd $OLDPWD
}

md2pdfmermaid () {
	cd $(dirname $1.md)
        pandoc $1.md -o $1.pdf --from markdown --template eisvogel --toc --number-sections --highlight-style breezedark --filter /usr/lib/node_modules/mermaid-filter/index.js -H ~/.pandoc/templates/head.tex --metadata-file=/home/ebsd/.pandoc/templates/metadata.yaml --filter /usr/bin/pandoc-latex-environment
	cd $OLDPWD
}

md2pdfnote () {
	cd $(dirname $1.md)
	pandoc $1.md -o $1.pdf --from markdown --template pandoc_custom_note --highlight-style breezedark -f markdown-implicit_figures -H ~/.pandoc/templates/head.tex --filter /usr/bin/pandoc-latex-environment --metadata-file=/home/ebsd/.pandoc/templates/metadata.yaml
	cd $OLDPWD
}

md2pdfnotemermaid () {
        cd $(dirname $1.md)
        pandoc $1.md -o $1.pdf --from markdown --template pandoc_custom_note --highlight-style breezedark -f markdown-implicit_figures --filter /usr/lib/node_modules/mermaid-filter/index.js -H ~/.pandoc/templates/head.tex --filter /usr/bin/pandoc-latex-environment --metadata-file=/home/ebsd/.pandoc/templates/metadata.yaml
        cd $OLDPWD
}


md2pdfnotedebug () {
        cd $(dirname $1.md)
        pandoc $1.md -o $1.tex --from markdown --template pandoc_custom_note --highlight-style breezedark -f markdown-implicit_figures -H ~/.pandoc/templates/head.tex --filter /usr/bin/pandoc-latex-environment --metadata-file=/home/ebsd/.pandoc/templates/metadata.yaml
	echo "Un .tex a été créé. Il est ainsi possible d'analyser la ligne qui présente une erreur"
	echo "pdftex file.tex pour compiler."
        cd $OLDPWD
}

md2pdfdebug () {
	cd $(dirname $1.md)
        pandoc $1.md -s -o $1.tex --from markdown --template eisvogel --toc --number-sections --highlight-style breezedark -H ~/.pandoc/templates/head.tex --filter /usr/bin/pandoc-latex-environment --metadata-file=/home/ebsd/.pandoc/templates/metadata.yaml
	pdflatex $1.tex
	cd $OLDPWD
}

md2docx () {
	cd $(dirname $1.md)
        pandoc $1.md -o $1.docx --from markdown --number-sections --highlight-style breezedark -H ~/.pandoc/templates/head.tex
	cd $OLDPWD
}

md2beamer () {
	pandoc -st beamer -V theme:Custom -V lang:fr-FR $1.md -o $1.pdf --highlight-style breezedark -H ~/.pandoc/templates/head.tex
}

md2wiki () {
	cat $1 | markdown2confluence | sed 's/title=none|//g' | sed 's/collapse=true/collapse=false/g' | xclip -i -selection clipboard
}

md2pdfcartouche () {
	pandoc $1.md -o $1.pdf --from markdown --template cartouche-template --highlight-style breezedark -f markdown-implicit_figures --number-sections -H ~/.pandoc/templates/head.tex --filter /usr/bin/pandoc-latex-environment --metadata-file=/home/ebsd/.pandoc/templates/metadata.yaml
}

md2pdfcartouchedebug () {
        cd $(dirname $1.md)
        pandoc $1.md -s -o $1.tex --from markdown --template cartouche-template --toc --number-sections --highlight-style breezedark -H ~/.pandoc/templates/head.tex --filter /usr/bin/pandoc-latex-environment --metadata-file=/home/ebsd/.pandoc/templates/metadata.yaml
        pdflatex $1.tex
        cd $OLDPWD
}

alias makepdf='make -f ~/.pandoc/templates/makefile'

ispngusedinmd() {
	for f in ./*.png; do grep -q `echo "$f" | cut -d "/" -f2` *.md; if [[ $? -ne 0 ]]; then echo $f "Inutilisé"; fi; done
}


alias vpnsnx="nohup expect ~/scripts/login.vpn-snx.expect >/dev/null 2>&1"
alias vpnf5="f5fpc --start --nocheck --host https://vpn-mobile.hug.ch:443 --cacert /etc/ssl/certs/HUG_Client_Issuing_CA.pem --cert /etc/ssl/certs/pc-ebsd-client-hors-huge.p12 --keypass $(pass hug/certificat-pc-ebsd) --user ebsd --password ebsd"
alias td='echo -e "\n`date +%F`\t$1" >> ~/plain/_plaintext-productivity/__todo.md'
alias tl='echo -e "\n`date +%F`\t$1" >> ~/plain/_plaintext-productivity/tl_`date +%Y-%m`.md'
#alias tlpriv='echo -e "`date +%FT%T%:z`\t$1" >> ~/sync/private/bashblog/tl-perso.txt'
alias tlpub='echo -e "`date +%FT%T%:z`\t$1" >> ~/Documents/3r1c.net/pages/twtxt.txt'
alias mntcrypt1='gocryptfs ~/sync/encrypted/ ~/plain -extpass pass -extpass hug/gocrypt'
alias mntcrypt2='gocryptfs ~/Documents/encrypted/ ~/plain2 -extpass pass -extpass hug/gocrypt'
alias mntcryptcloud='mkdir -p /tmp/remotebackup/rootfs && gocryptfs -reverse -config ~/.nobackup/gocryptfs.reverse.rootfs.conf -exclude .nobackup/ -exclude /remotebackup/rootfs -fsname gcryptfs-reverse /home/ebsd /tmp/remotebackup/rootfs -extpass pass -extpass hug/gocrypt'
#alias fullbackuptopcloud='if ! grep -qs '/tmp/remotebackup/rootfs' /proc/mounts; then mkdir -p /tmp/remotebackup/rootfs; gocryptfs -reverse -config ~/.nobackup/gocryptfs.reverse.rootfs.conf -exclude .nobackup/ -exclude /remotebackup/rootfs -fsname gcryptfs-reverse /home/ebsd /tmp/remotebackup/rootfs -extpass pass -extpass hug/gocrypt; else /usr/bin/rclone sync --update --verbose --transfers 30 --checkers 8 --contimeout 60s --timeout 300s --retries 3 --low-level-retries 10 --stats 2s "/tmp/remotebackup/rootfs" "rclone_pcloud:/ebsdhome/" --filter-from ~/rclone-filter --backup-dir rclone_pcloud:/ebsdhome_old; fi'
#alias backuptomega='if ! grep -qs '/tmp/remotebackup/rootfs' /proc/mounts; then gocryptfs -reverse -config ~/.nobackup/gocryptfs.reverse.rootfs.conf -exclude .nobackup/ -exclude /remotebackup/rootfs -fsname gcryptfs-reverse /home/ebsd /tmp/remotebackup/rootfs -extpass pass -extpass hug/gocrypt; else /usr/bin/rclone sync --update --verbose --transfers 30 --checkers 8 --contimeout 60s --timeout 300s --retries 3 --low-level-retries 10 --stats 1s "/tmp/remotebackup/rootfs/sync" "rclone_mega:/sync"; fi'

alias backuptodrive='/usr/bin/rclone sync --update --verbose --transfers 30 --checkers 8 --contimeout 60s --timeout 300s --retries 3 --low-level-retries 10 --stats 1s "/home/ebsd/sync/encrypted" "rclone:/backup/sync/encrypted" && /usr/bin/rclone copy --update --verbose --transfers 30 --checkers 8 --contimeout 60s --timeout 300s --retries 3 --low-level-retries 10 --stats 1s "/home/ebsd/sync/howtos" "rclone:/backup/sync/howtos"'
alias backuptopcloud_full='/usr/bin/rclone sync --update --verbose --transfers 30 --checkers 8 --contimeout 60s --timeout 300s --retries 3 --low-level-retries 10 --stats 2s "/tmp/remotebackup/rootfs" "rclone_pcloud:/ebsdhome/" --filter-from ~/rclone-filter --backup-dir rclone_pcloud:/ebsdhome_old'
alias backuptomega='/usr/bin/rclone sync --update --verbose --transfers 30 --checkers 8 --contimeout 60s --timeout 300s --retries 3 --low-level-retries 10 --stats 1s "/tmp/remotebackup/rootfs/sync" "rclone_mega:/sync"'

# remove linefeed from text present in clipboard
## tl "+SUBJECT $(rmlinefeed)"
rmlinefeed () {
	xclip -o | sed ':a;N;$!ba;s/\n/ /g'
}

# replace space by newline from text present in clipboard
repspacebynewline () {
	xclip -o | tr " " "\n"
}

# rechercher des mots sur une ligne dans tous les .md du dossier. Quelque soit le sens d'apparition des mots.
findmd () {

	for i in $(seq 1 $#); do
	cmd="${cmd}(?=.*${1})"
	cmd2="${cmd2}${1}\|"
	cmd3="${1}.+${cmd3}"
	cmd4="${cmd4}.+${1}"
	shift
	done

	# le second grep ajoute seulement la couleur sur les mots clés
	fullcmd="grep -rni -P '${cmd}' --include=\*.md | grep -i --color '${cmd2}'"
	eval "$fullcmd"
	unset fullcmd
        unset cmd
        unset cmd2


	# recherche également dans les commit
	# git grep -E 'motA.+motB|motB.+motA' $(git rev-list --all)
	# liste des commit, puis avec sed on supprime les newline par un espace
	#revlist=$(/usr/bin/git rev-list --all | sed ':a;N;$!ba;s/\n/ /g')
	#gitcmd="git grep -iE '${cmd3}|${cmd4}' ${revlist}"
	#eval "$gitcmd"
	##echo $gitcmd
	#unset gitcmd

	unset cmd3
	unset cmd4

} 

pwdgenbash () { date +%s | sha256sum | base64 | head -c $1 ; echo; }

export PASSWORD_STORE_DIR=~/sync/.password-store/

pinguntilalive () {
	until ping -c1 $1 >/dev/null 2>&1; do :; done && notify-send $1 ALIVE
}

buildmd2confluencerc () {
> .md2confluence-rc
echo pageid ?
read pageid
echo "mdfile (avec extension)" ?
read mdfile
echo "Page title ?"
read pagetitle
cat <<EOT >> .md2confluence-rc
{
  "baseUrl": "http://wiki.hcuge.ch/rest/api",
  "user": "ebsd",
  "prefix": "Ce document est généré automatiquement via API REST. Ne pas l'éditer directement svp.",
  "pages": [
    {
      "pageid": "$pageid",
      "mdfile": "$mdfile",
      "title": "$pagetitle"
    }
  ]
}
EOT
}

upldimg2wiki () {
echo "confluence password ?"
read -s mypwd
export password=$mypwd
pageid=$(cat .md2confluence-rc | grep pageid | grep -oP '[^"]+(?=\"\,)')
find -maxdepth 1 -type f -name '*.png' -exec bash -O nullglob -O dotglob -O extglob -c '
  for filepath do
      echo $(basename $filepath)
      file=$(basename $filepath)
      curl -v -S -u ebsd:$password -X POST -H "X-Atlassian-Token: no-check" -F "file=@$file" -F "comment=this is my file" "http://wiki.hcuge.ch/rest/api/content/'$pageid'/child/attachment" | python -mjson.tool
  done' bash {} +
unset password
}

post2wiki () {
        /usr/lib/node_modules/md2confluence/bin/md2confluence
	rm -rf ./tmp
}

#alias tod=/home/ebsd/bin/tod_sh/tod.sh

alias dotfiles='/usr/bin/git --git-dir=/home/ebsd/.dotfiles/ --work-tree=/home/ebsd'

alias timestamp='date +%Y-%m-%dT%TZ'

todfull () {
  pwd="$PWD"
  cd ~/plain/_plaintext-productivity/journal
  vim -O $( \
    dateseq \
    "$(date --date "1 months ago" +%Y/%m)" \
    "$(date --date "2 months" +%Y/%m)" \
    -i %Y/%m \
    -f %Y/%m \
  )
  cd $pwd
}

tod () {
  pwd="$PWD"
  cd ~/plain/_plaintext-productivity/journal
  vim $(date +"%Y/%m")
  cd $pwd
}
## FIN ERIC ####

