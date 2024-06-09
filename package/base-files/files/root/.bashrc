#!/usr/bin/env bash
# openwrt

# If not running interactively, don't do anything
case $- in
	*i*) ;;
	*) return ;;
esac

# terminal 256 colors
export bg=$'\e[0;48;5;' bgt=$'\e[0;48;2;' bl=$'\e[1m' bli=$'\e[3m\e[1m' fg=$'\e[0;38;5;' fgt=$'\e[0;38;2;' it=$'\e[3m' st=$'\e[0m' str=$'\e[9m' un=$'\e[4m' dim=$'\e[2m' hi=$'\e[8m' re=$'\e[7m' blink=$'\e[5m' blstr=$'\e[1m\e[9m'

PROMPT_COMMAND=prompt

# bindings
bind Space:magic-space
bind '"\es": "\C-asudo \C-e"'
bind '"\et": "\C-atime \C-m"'
bind '"\ew": "\C-awget2 \C-e"'
bind '"\ei": " --help\C-m"'
bind '"\eb": "codeclone\C-mc\C-m"'
bind '"\er": ". ~/.bashrc\C-mc\C-m"'
bind '"\ex":"cd !$ \015ls\015"'
bind '"\e[18~":"Hi!"'
bind '"\ec":"cd\C-e /"'
bind '"\ey":"cd -\C-m"'
bind '"\e\"": "\C-v\"\C-v\"\C-b"'
bind '"\em": "mount\C-e /dev/sda1 /mnt"'
bind '"\e[24~":"\C-k \C-upwd\n"'
bind '"\e[11~": "echo foobar\n"'
bind '"\ee": "clear\C-mc\C-m"'

function myFunction() {
	for fgbg in 38 48 ; do #Foreground/Background
	for color in {0..256} ; do #Colors
		#Display the color
		echo -en "\e[${fgbg};5;${color}m ${color}\t\e[0m"
		#Display 10 colors per lines
		if [ $((($color + 1) % 10)) == 0 ] ; then
			echo #New line
		fi
	done
	echo #New line
done
}

function frost() {
echo -en "\e[${fgbg};5;${color}m"
printf "%4d " ${color}
echo -en "\e[0m"
}

function dig() {
for i in {1..5}
do
    # запуск одного фонового процесса
    sleep 10 && echo "$i" &
done
# ожидание окончания работы
wait
echo Finished
}

function pop() {
	echo Hello $1, how do you do
}

function ghost() {
	for i in 21 27 33 39 45 51 50 49 48 47 46 82 118 154 190 226 220 214 208 202 196 197 198 199 200 201 165 129 93 57 21
do echo -en "\e[48;5;${i}m \e[0m"; done
}

#shopt -s -q autocd
shopt -s nocasematch
#DEBIAN_FRONTEND=noninteractive

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth:erasedups

# append to the history file, don't overwrite it
shopt -s histappend
shopt -s dotglob
shopt -s extglob
shopt -s cmdhist

# don't record some commands
HISTIGNORE="&:[ ]*:bg:c:cd:clear:d:df:exit:fg:h:history:la:ls:t:up:re:poweroff:cd -:clt:cll:auc:. ~/.bashrc:b"

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
	xterm-color|*-256color) color_prompt=yes ;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
		# We have color support; assume it's compliant with Ecma-48
		# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
		# a case would tend to support setf rather than setaf.)
		color_prompt=yes
	else
		color_prompt=
	fi
fi
 
if [ "$color_prompt" = yes ]; then
	function prompt() {
		TEMPERATURE=$(cat /sys/class/thermal/thermal_zone0/temp)
		RESULT=$(echo "scale=1;($TEMPERATURE/1000)"|bc)"°"\⋮
		LEFT_PROMPT="\[${fg}5m\]\u\[${fg}5m\]@\[${fg}5m\]\h\[${fg}5m\]:\[${fg}12m\]\w\[${st}\]"
		RIGHT_PROMPT="\[${fg}4m\]⋮\[${fg}4m\]$(/bin/ls -1 -A | /usr/bin/wc -l | /bin/sed 's: ::g')F:$(/bin/ls -hsAF | /bin/grep -m 1 total | /bin/sed 's/total //')\[${fg}4m\]⋮\[${fg}4m\]$RESULT\[${st}\]"
		#GIT_BRANCH="\[${fg}60m\]$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\/\1/')\[${st}\]"
		PS1="${debian_chroot:+($debian_chroot)}$LEFT_PROMPT$RIGHT_PROMPT\[${fg}130m\]⌗\[${st}\] "
		#hash_cmd="md5sum";current_hash="$(${hash_cmd} ~/.bashrc)";if [ "${bashprofile_hash}" != "${current_hash}" ];then old_hash="${bashprofile_hash}";export bashprofile_hash="${current_hash}";if [ "${old_hash}" == "" ];then return;fi;export bashprofile_hash="${current_hash}";source ~/.bashrc;echo -e ${fg}68m" • Reloaded${st}";return;fi
}

	else
	PS1="${debian_chroot:+($debian_chroot)}\u@\h: \w\a"
fi

unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
	xterm*|rxvt*)
		PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
		;;
	*)
		;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias dir='dir --color=always'
	alias egrep='egrep --color=always'
	alias fgrep='fgrep --color=always'
	alias grep='grep --color=always'
	alias ls='ls --color=always'
	alias vdir='vdir --color=always'
	alias fdisk='fdisk --color=always'
fi
# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias l='ls -CF'
alias la='ls --color=always -hsAF | sort'
alias ll='ls -alF'

# ssh
alias clssh='truncate -s 0 ~/.ssh/known_hosts 2> /dev/null && printf ${fg}65m" • SSH host is cleared%s\n"'
alias sshl='ssh 192.168.1.2 -p 63731'

# net
alias ports='netstat -tulanp'

alias c='reset'
alias clb='truncate -s 0 /etc/banner 2> /dev/null && printf "${fg}65m"" • Banner is cleared%s\n"'
alias clh='cat /dev/null > ~/.bash_history && history -c && printf "${fg}65m"" • History is cleared%s\n"'
alias clt='shopt -s extglob | rm -rf /tmp/!(opkg.lock) 2> /dev/null && printf " • Temp folder is cleared%s\n"'
alias h='htop'
alias iperf='iperf3 -s -D 2> /dev/null && printf "${fg}65m"" • iPerf is started!%s\n"'
alias rd='rm -fr'
alias sh='sort .bash_history | uniq >> .bash_history'
alias trim='fstrim -av'
alias un='uname -a'
alias dist='cat /etc/openwrt_release'

# chips temperature
alias temp='grep "[0-9]" /sys/class/thermal/thermal_zone0/temp'
alias wtemp='cat /sys/class/ieee80211/phy*/hwmon*/temp1_input'

# app versions
alias av='aria2c -v | GREP_COLORS="mt=38;5;101" grep -P "(^.*:$)|$" | GREP_COLORS="mt=38;5;100" grep -P "(^\s.*$)|$"'
alias bv='bash --version | GREP_COLORS="mt=38;5;72" grep -zoPi "(^GNU bash| \d\.\d\.\d+\(\d\))" | sed -e "s/$/\n/"'
alias cpv='c++ --version'
alias cv='cmake --version | grep -P "(^cmake)"'
alias gv='grep -V'
alias gemv='gem -v'
alias hv='htop -V'
alias lv='lighttpd -V | GREP_COLORS="mt=38;5;2" grep -P "(\+)|$" | GREP_COLORS="mt=38;5;1" grep -P "(^\s+\-)|$" | sd "^\n" "" | GREP_COLORS="mt=38;5;7" grep -P "^.*\:|$"'
alias makev='sudo make -v | grep -P "Make"'
alias mozv='jpegtran-static -version'
alias npmv='npm -v'
alias nv='node -v'
alias ov='oxipng -V'
alias perlv='perl -v'
alias pipv='pip3 --version'
alias rubyv='ruby -v'
alias rustv='rustc --version'
alias rv='rclone version'
alias shellcheckv='shellcheck -V | GREP_COLORS="mt=38;5;2" grep -P "(^\w+)(\:|\s)"'
alias smbv='sudo samba -V'
alias sshv='ssh -V'
alias tv='transmission-daemon -V'
alias uv='upx -V | GREP_COLORS="mt=38;5;6" grep -zoPi "upx\s\d\.\d\.\d" | sed -e "s/$/\n/"'

# disk io speed
alias rsr='dd if=/tmp/zero of=/dev/null bs=4k count=100000' # read-speed test ram
alias rss='dd if=/dev/zero of=/var/log/zero bs=4k count=100000 oflag=dsync'
alias rsss='dd if=/dev/zero of=/var/log/zero bs=1G count=1 oflag=direct'
alias un='uname -noprsv | GREP_COLORS="mt=38;5;2" grep -P "Khadas|$"'
alias wsr='dd if=/dev/zero of=/tmp/zero bs=4k count=100000' # write-speed test ram

# fio
alias fz='fio --filename=/dev/zram1 --rw=read --direct=1 --bs=1M --ioengine=libaio --runtime=25 --numjobs=1 --time_based --group_reporting --name=seq_read --iodepth=16'
alias fmtd='fio --filename=/dev/mtdblock0 --rw=read --direct=1 --bs=1M --ioengine=libaio --runtime=25 --numjobs=1 --time_based --group_reporting --name=seq_read --iodepth=16'
alias fn='fio --filename=/dev/nvme0n1 --rw=read --direct=1 --bs=1M --ioengine=libaio --runtime=25 --numjobs=1 --time_based --group_reporting --name=seq_read --iodepth=16'
alias fm='fio --filename=/dev/mmcblk0 --rw=read --direct=1 --bs=1M --ioengine=libaio --runtime=25 --numjobs=1 --time_based --group_reporting --name=seq_read --iodepth=16'

# directory navigation
alias b='cd -'
alias e='cd /etc'
alias m='cd /mnt'
alias t='cd /tmp'
alias ti='cd /tmp/images'
alias u='cd ..'
alias ub='cd /usr/bin'
alias w='cd /www/'

# opkg
alias oi='opkg update > /dev/null && opkg install'
alias or='opkg remove > /dev/null'
alias up='opkg update > /dev/null && 	echo -e "${fg}65m"Packages list updated! | indent'
alias upg='opkg upgrade'

# chmod
alias 600='chmod 600'
alias 644='chmod 644'
alias 755='chmod 755'
alias 777='chmod 777'

# chmod some dir & folders
alias chmb='chmod +x /usr/local/bin/* && echo $($fg 68)" • Binary are now executable"$(${st})'
alias chms='chmod +x ~/.scripts/* && echo -e "${fg}68m" • Scripts are now executable'
alias chmssh='chmod 700 ~/.ssh && chmod 600 ~/.ssh/id_* && chmod 600 ~/.ssh/config && chmod 600 ~/.ssh/authorized_keys && echo ${fg}12m" • ssh keys are now right permission"${st}'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

function all_done() {
	printf ${fg}64m"Done%s\n"${st}
}

function po() {
	if (df | grep -qP '(webdav|http)')
	then umount /backup > /dev/null | printf ${fg}68m' • Unmounting webdav...'${st} && all_done && printf ${fg}68m' • Powering off...'${st} && all_done && sleep 1s && poweroff
	else printf ${fg}68m' • Powering off... ' && sleep 1s && all_done && poweroff
	fi
}

function re() {
	if ( df | grep -qP '(webdav|http)' )
	then umount /backup > /dev/null | printf ${fg}68m' • Unmounting webdav...'${st} && all_done && printf ${fg}68m' • Rebooting...'${st} && all_done && sleep 1s && reboot
	else printf ${fg}68m' • Rebooting... '${st} && sleep 1s && all_done && sleep 1s && reboot now
	fi
}

function exe() {
	file * | grep -P "ELF" 2> /dev/null | sed -E "s/(:.*)(statically)(.*)/:${fg}64m \2${st}/" | sed -E "s/(:.*)(dynamically)(.*)/:${fg}3m \2${st}/" | sed -E "s/(:.*)(debug_info)(.*)/:${fg}13m \2${st}/" | sed -E "s/(:.*)(static-pie)(.*)/:${fg}6m \2${st}/" | sed -E "s/(:.*)(PE32)(.*)/:${fg}6m \2 Windows${st}/"
}

function df() {
	command df -h | { read -r line; echo "$line"; sort -k 5,1; } | GREP_COLORS="mt=38;5;242" grep -P "(?-i)(G|M|K)\b|$" | GREP_COLORS="mt=38;5;189" grep -P "(devtmpfs|tmpfs|ext4|vfat)|$" | GREP_COLORS="mt=38;5;181" grep -P "(udev)|$" | GREP_COLORS="mt=38;5;181" grep -P "(overlay(?:fs:/)?)|$" | GREP_COLORS="mt=38;5;104" grep -P "(?i)(^/dev/[a-z0-9]+)|$" | GREP_COLORS="mt=00;32" grep -P "(\s\d%)|(\s[0-4][0-9]%)|$" | GREP_COLORS="mt=38;5;183" grep -P "(/dev/(sd[a-z][0-9])|/dev/(sd[a-z]))|$" | GREP_COLORS="mt=38;5;1" grep -P "(\s[8-9][0-9]%|\s100%)|$" | GREP_COLORS="mt=38;5;220" grep -P "([5-7][0-9]%)|$" | GREP_COLORS="mt=38;5;65" grep -P "(?-i)(F.*)|$" #| sd "https://webdav.cloud.mail.ru" ${fg}69m "webdav        "$(${st})| sd "\s{14}" ""
}

function disk() {
	lsblk | GREP_COLORS="mt=38;5;94" grep -P "(├─|└─)|$" | GREP_COLORS="mt=38;5;2" grep -P "(sd[a-z][0-9]+)\s|$" | GREP_COLORS="mt=38;5;242" grep -P "(?-i)(?<=\d)(G|M|K|B)\s|$" | GREP_COLORS="mt=38;5;101" grep -P "^(mmcblk|sd|zram|mtdblock|nvme)[a-z0-9]+|$" | GREP_COLORS="mt=38;5;143" grep -P "(nbd[0-9]+)|$" | GREP_COLORS="mt=38;5;100" grep -P "(sd|nvme0n1|mmcblk0)[a-z][0-9]+|$" | GREP_COLORS="mt=38;5;65" grep -P "(NAME|MAJ:MIN|RM|SIZE|RO|TYPE|MOUNTPOINTS)|$"
}

function d() {
	paste <(du -abhd 1 2>/dev/null |  sed 's/\s.*//') <(ls --color=always -1 -A -UF) #| sort -h
}

function list() {
	opkg list-installed | GREP_COLORS="mt=38;5;101" grep -oP "^([a-z0-9-]+)|$" | indent #  && opkg list-installed | wc -l | sed -E "s/^(\d+)/Total \1/g"
}

function li() {
	install_time=$(opkg status kernel | awk '$1=="Installed-Time:" {print $2}'); opkg status | awk '$1=="Package:" {package=$2} $1=="Status:" {user_inst=/ user/ && / installed/} $1=="Installed-Time:" && $2!='$install_time' && user_inst {print package}' | sort | GREP_COLORS="mt=38;5;101" grep -oP "^([a-z0-9-]+)|$" | indent || echo -e "${fg}3m • Log not found!${st}"
}

function sb() {
	binary=$(grep --color='never' -rIL . )
	for binary in ${binary[@]}
	do if [[ ! -x "$binary" ]]
		then echo "${fg}146m${binary}${st}${fg}3m file format not recognized${st}"
		else strip -ps "$binary" && echo ${fg}146m"${binary}${st} was stripped"
		fi
	done
}

function indent() {
	ghost=$(echo -e ${fg}4m •${st})
	sed -r "s/^(.)/${ghost} \1/g"
}

function btest() {
	time bash -i -c "echo -n"
}

function col() {
	for c in {1..256}
	do
		echo -en "\r" • "$fg${c}m""$c""${st}""\n"
	done
}

function color() {
	awk 'BEGIN{
    s="/\\/\\/\\/\\/\\"; s=s s s s s s s s;
    for (colnum = 0; colnum<77; colnum++) {
        r = 255-(colnum*255/76);
        g = (colnum*510/76);
        b = (colnum*255/76);
        if (g>255) g = 510-g;
        printf "\033[48;2;%d;%d;%dm", r,g,b;
        printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
        printf "%s\033[0m", substr(s,colnum+1,1);
    }
    printf "\n";
	}'
}

function nmapc() {
	nmap -p 1-65000 20 192.168.1.$1 | GREP_COLORS="mt=38;5;2" grep -P "(open)|$" | GREP_COLORS="mt=38;5;1" grep -P "(closed)|$" | GREP_COLORS="mt=38;5;6" grep -P "(PORT|SERVICE|STATE)|$" | GREP_COLORS="mt=38;5;33" grep -P "\s(\w+|\w+\-\w+|\w+|\w+\-\w+\-\w+)$|$" | GREP_COLORS="mt=38;5;63" grep -P "(^[0-9]+)|$"
}

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

# functions
export -f indent
# system-wide variable
export PATH="$PATH:$HOME/.scripts"
# grep colors
export GREP_COLORS='sl=49;38;5;189:cx=49;39:mt=49;38;5;203;1:fn=49;38;5;229:ln=49;38;5;177:bn=49;38;5;178;1:se=49;38;5;64'
# colored LC
export LS_COLORS='bd=38;5;68:ca=38;5;17:cd=38;5;113;1:di=38;5;68:do=38;5;127:ex=38;5;208;1:pi=38;5;126:fi=0:ln=target:mh=38;5;222;1:no=0:or=48;5;196;38;5;232;1:ow=38;5;220;1:sg=48;5;3;38;5;0:su=38;5;220;1;3;100;1:so=38;5;197:st=38;5;86;48;5;234:tw=48;5;235;38;5;139;3:*LS_COLORS=48;5;89;38;5;197;1;3;4;7:*README=38;5;220;1:*README.rst=38;5;220;1:*README.md=38;5;220;1:*LICENSE=38;5;220;1:*COPYING=38;5;220;1:*INSTALL=38;5;220;1:*COPYRIGHT=38;5;220;1:*AUTHORS=38;5;220;1:*HISTORY=38;5;220;1:*CONTRIBUTORS=38;5;220;1:*PATENTS=38;5;220;1:*VERSION=38;5;220;1:*NOTICE=38;5;220;1:*CHANGES=38;5;220;1:*.log=38;5;190:*.txt=38;5;253:*.adoc=38;5;184:*.asciidoc=38;5;184:*.etx=38;5;184:*.info=38;5;184:*.markdown=38;5;184:*.md=38;5;184:*.mkd=38;5;184:*.nfo=38;5;184:*.pod=38;5;184:*.rst=38;5;184:*.tex=38;5;184:*.textile=38;5;184:*.bib=38;5;178:*.json=38;5;178:*.jsonl=38;5;178:*.jsonnet=38;5;178:*.libsonnet=38;5;142:*.ndjson=38;5;178:*.msg=38;5;178:*.pgn=38;5;178:*.rss=38;5;178:*.xml=38;5;178:*.fxml=38;5;178:*.toml=38;5;178:*.yaml=38;5;178:*.yml=38;5;178:*.RData=38;5;178:*.rdata=38;5;178:*.xsd=38;5;178:*.dtd=38;5;178:*.sgml=38;5;178:*.rng=38;5;178:*.rnc=38;5;178:*.cbr=38;5;141:*.cbz=38;5;141:*.chm=38;5;141:*.djvu=38;5;141:*.pdf=38;5;141:*.PDF=38;5;141:*.mobi=38;5;141:*.epub=38;5;141:*.docm=38;5;111;4:*.doc=38;5;111:*.docx=38;5;111:*.odb=38;5;111:*.odt=38;5;111:*.rtf=38;5;111:*.odp=38;5;166:*.pps=38;5;166:*.ppt=38;5;166:*.pptx=38;5;166:*.ppts=38;5;166:*.pptxm=38;5;166;4:*.pptsm=38;5;166;4:*.csv=38;5;78:*.tsv=38;5;78:*.ods=38;5;112:*.xla=38;5;76:*.xls=38;5;112:*.xlsx=38;5;112:*.xlsxm=38;5;112;4:*.xltm=38;5;73;4:*.xltx=38;5;73:*.pages=38;5;111:*.numbers=38;5;112:*.key=38;5;166:*config=1:*cfg=1:*conf=1:*rc=1:*authorized_keys=1:*known_hosts=1:*.ini=1:*.plist=1:*.viminfo=1:*.pcf=1:*.psf=1:*.hidden-color-scheme=1:*.hidden-tmTheme=1:*.last-run=1:*.merged-ca-bundle=1:*.sublime-build=1:*.sublime-commands=1:*.sublime-keymap=1:*.sublime-settings=1:*.sublime-snippet=1:*.sublime-project=1:*.sublime-workspace=1:*.tmTheme=1:*.user-ca-bundle=1:*.epf=1:*.git=38;5;197:*.gitignore=38;5;240:*.gitattributes=38;5;240:*.gitmodules=38;5;240:*.awk=38;5;172:*.bash=38;5;172:*.bat=38;5;172:*.BAT=38;5;172:*.sed=38;5;172:*.sh=38;5;172:*.zsh=38;5;172:*.vim=38;5;172:*.kak=38;5;172:*.ahk=38;5;41:*.py=38;5;41:*.ipynb=38;5;41:*.rb=38;5;41:*.gemspec=38;5;41:*.pl=38;5;208:*.PL=38;5;160:*.t=38;5;114:*.msql=38;5;222:*.mysql=38;5;222:*.pgsql=38;5;222:*.sql=38;5;222:*.tcl=38;5;64;1:*.r=38;5;49:*.R=38;5;49:*.gs=38;5;81:*.clj=38;5;41:*.cljs=38;5;41:*.cljc=38;5;41:*.cljw=38;5;41:*.scala=38;5;41:*.sc=38;5;41:*.dart=38;5;51:*.asm=38;5;81:*.cl=38;5;81:*.lisp=38;5;81:*.rkt=38;5;81:*.lua=38;5;81:*.moon=38;5;81:*.c=38;5;81:*.C=38;5;81:*.h=38;5;110:*.H=38;5;110:*.tcc=38;5;110:*.c++=38;5;81:*.h++=38;5;110:*.hpp=38;5;110:*.hxx=38;5;110:*.ii=38;5;110:*.M=38;5;110:*.m=38;5;110:*.cc=38;5;81:*.cs=38;5;81:*.cp=38;5;81:*.cpp=38;5;81:*.cxx=38;5;81:*.cr=38;5;81:*.go=38;5;81:*.f=38;5;81:*.F=38;5;81:*.for=38;5;81:*.ftn=38;5;81:*.f90=38;5;81:*.F90=38;5;81:*.f95=38;5;81:*.F95=38;5;81:*.f03=38;5;81:*.F03=38;5;81:*.f08=38;5;81:*.F08=38;5;81:*.nim=38;5;81:*.nimble=38;5;81:*.s=38;5;110:*.S=38;5;110:*.rs=38;5;81:*.scpt=38;5;219:*.swift=38;5;219:*.sx=38;5;81:*.vala=38;5;81:*.vapi=38;5;81:*.hi=38;5;110:*.hs=38;5;81:*.lhs=38;5;81:*.agda=38;5;81:*.lagda=38;5;81:*.lagda.tex=38;5;81:*.lagda.rst=38;5;81:*.lagda.md=38;5;81:*.agdai=38;5;110:*.zig=38;5;81:*.v=38;5;81:*.pyc=38;5;240:*.tf=38;5;168:*.tfstate=38;5;168:*.tfvars=38;5;168:*.css=38;5;125;1:*.less=38;5;125;1:*.sass=38;5;125;1:*.scss=38;5;125;1:*.htm=38;5;125;1:*.html=38;5;125;1:*.jhtm=38;5;125;1:*.mht=38;5;125;1:*.eml=38;5;125;1:*.mustache=38;5;125;1:*.coffee=38;5;074;1:*.java=38;5;074;1:*.js=38;5;074;1:*.mjs=38;5;074;1:*.jsm=38;5;074;1:*.jsp=38;5;074;1:*.php=38;5;81:*.ctp=38;5;81:*.twig=38;5;81:*.vb=38;5;81:*.vba=38;5;81:*.vbs=38;5;81:*Dockerfile=38;5;155:*.dockerignore=38;5;240:*Makefile=38;5;155:*MANIFEST=38;5;243:*pm_to_blib=38;5;240:*.nix=38;5;155:*.dhall=38;5;178:*.rake=38;5;155:*.am=38;5;242:*.in=38;5;242:*.hin=38;5;242:*.scan=38;5;242:*.m4=38;5;242:*.old=38;5;242:*.out=38;5;242:*.SKIP=38;5;244:*.diff=48;5;197;38;5;232:*.patch=48;5;197;38;5;232;1:*.bmp=38;5;97:*.dicom=38;5;97:*.tiff=38;5;97:*.tif=38;5;97:*.TIFF=38;5;97:*.cdr=38;5;97:*.flif=38;5;97:*.gif=38;5;97:*.icns=38;5;97:*.ico=38;5;97:*.jpeg=38;5;97:*.jpg=38;5;97:*.nth=38;5;97:*.png=38;5;97:*.psd=38;5;97:*.pxd=38;5;97:*.pxm=38;5;97:*.xpm=38;5;97:*.webp=38;5;97:*.jxl=38;5;97:*.ai=38;5;99:*.eps=38;5;99:*.epsf=38;5;99:*.drw=38;5;99:*.ps=38;5;99:*.svg=38;5;99:*.avi=38;5;114:*.divx=38;5;114:*.IFO=38;5;114:*.m2v=38;5;114:*.m4v=38;5;114:*.mkv=38;5;114:*.MOV=38;5;114:*.mov=38;5;114:*.mp4=38;5;114:*.mpeg=38;5;114:*.mpg=38;5;114:*.ogm=38;5;114:*.rmvb=38;5;114:*.sample=38;5;114:*.wmv=38;5;114:*.3g2=38;5;115:*.3gp=38;5;115:*.gp3=38;5;115:*.webm=38;5;115:*.gp4=38;5;115:*.asf=38;5;115:*.flv=38;5;115:*.ts=38;5;115:*.ogv=38;5;115:*.f4v=38;5;115:*.VOB=38;5;115;1:*.vob=38;5;115;1:*.ass=38;5;117:*.srt=38;5;117:*.ssa=38;5;117:*.sub=38;5;117:*.sup=38;5;117:*.vtt=38;5;117:*.3ga=38;5;137;1:*.S3M=38;5;137;1:*.aac=38;5;137;1:*.amr=38;5;137;1:*.au=38;5;137;1:*.caf=38;5;137;1:*.dat=38;5;137;1:*.dts=38;5;137;1:*.fcm=38;5;137;1:*.m4a=38;5;137;1:*.mod=38;5;137;1:*.mp3=38;5;137;1:*.mp4a=38;5;137;1:*.oga=38;5;137;1:*.ogg=38;5;137;1:*.opus=38;5;137;1:*.s3m=38;5;137;1:*.sid=38;5;137;1:*.wma=38;5;137;1:*.ape=38;5;136;1:*.aiff=38;5;136;1:*.cda=38;5;136;1:*.flac=38;5;136;1:*.alac=38;5;136;1:*.mid=38;5;136;1:*.midi=38;5;136;1:*.pcm=38;5;136;1:*.wav=38;5;136;1:*.wv=38;5;136;1:*.wvc=38;5;136;1:*.afm=38;5;66:*.fon=38;5;66:*.fnt=38;5;66:*.pfb=38;5;66:*.pfm=38;5;66:*.ttf=38;5;66:*.otf=38;5;66:*.woff=38;5;66:*.woff2=38;5;66:*.PFA=38;5;66:*.pfa=38;5;66:*.7z=38;5;40:*.a=38;5;40:*.arj=38;5;40:*.bz2=38;5;40:*.cpio=38;5;40:*.gz=38;5;40:*.lrz=38;5;40:*.lz=38;5;40:*.lzma=38;5;40:*.lzo=38;5;40:*.rar=38;5;40:*.s7z=38;5;40:*.sz=38;5;40:*.tar=38;5;40:*.tgz=38;5;40:*.warc=38;5;40:*.WARC=38;5;40:*.xz=38;5;40:*.z=38;5;40:*.zip=38;5;40:*.zipx=38;5;40:*.zoo=38;5;40:*.zpaq=38;5;40:*.zst=38;5;40:*.zstd=38;5;40:*.zz=38;5;40:*.apk=38;5;215:*.ipa=38;5;215:*.deb=38;5;215:*.rpm=38;5;215:*.jad=38;5;215:*.jar=38;5;215:*.cab=38;5;215:*.pak=38;5;215:*.pk3=38;5;215:*.vdf=38;5;215:*.vpk=38;5;215:*.bsp=38;5;215:*.dmg=38;5;215:*.crx=38;5;215:*.xpi=38;5;215:*.r[0-9]{0,2}=38;5;239:*.zx[0-9]{0,2}=38;5;239:*.z[0-9]{0,2}=38;5;239:*.part=38;5;239:*.iso=38;5;124:*.bin=38;5;124:*.nrg=38;5;124:*.qcow=38;5;124:*.sparseimage=38;5;124:*.toast=38;5;124:*.vcd=38;5;124:*.vmdk=38;5;124:*.accdb=38;5;60:*.accde=38;5;60:*.accdr=38;5;60:*.accdt=38;5;60:*.db=38;5;60:*.fmp12=38;5;60:*.fp7=38;5;60:*.localstorage=38;5;60:*.mdb=38;5;60:*.mde=38;5;60:*.sqlite=38;5;60:*.typelib=38;5;60:*.nc=38;5;60:*.pacnew=38;5;33:*.un~=38;5;241:*.orig=38;5;241:*.BUP=38;5;241:*.bak=38;5;241:*.o=38;5;241:*core=38;5;241:*.mdump=38;5;241:*.rlib=38;5;241:*.dll=38;5;241:*.swp=38;5;244:*.swo=38;5;244:*.tmp=38;5;244:*.sassc=38;5;244:*.pid=38;5;248:*.state=38;5;248:*lockfile=38;5;248:*lock=38;5;248:*.err=38;5;160;1:*.error=38;5;160;1:*.stderr=38;5;160;1:*.aria2=38;5;241:*.dump=38;5;241:*.stackdump=38;5;241:*.zcompdump=38;5;241:*.zwc=38;5;241:*.pcap=38;5;29:*.cap=38;5;29:*.dmp=38;5;29:*.DS_Store=38;5;239:*.localized=38;5;239:*.CFUserTextEncoding=38;5;239:*.allow=38;5;112:*.deny=38;5;196:*.service=38;5;45:*@.service=38;5;45:*.socket=38;5;45:*.swap=38;5;45:*.device=38;5;45:*.mount=38;5;45:*.automount=38;5;45:*.target=38;5;45:*.path=38;5;45:*.timer=38;5;45:*.snapshot=38;5;45:*.application=38;5;116:*.cue=38;5;116:*.description=38;5;116:*.directory=38;5;116:*.m3u=38;5;116:*.m3u8=38;5;116:*.md5=38;5;116:*.properties=38;5;116:*.sfv=38;5;116:*.theme=38;5;116:*.torrent=38;5;116:*.urlview=38;5;116:*.webloc=38;5;116:*.lnk=38;5;39:*CodeResources=38;5;239:*PkgInfo=38;5;239:*.nib=38;5;57:*.car=38;5;57:*.dylib=38;5;241:*.entitlements=1:*.pbxproj=1:*.strings=1:*.storyboard=38;5;196:*.xcconfig=1:*.xcsettings=1:*.xcuserstate=1:*.xcworkspacedata=1:*.xib=38;5;208:*.asc=38;5;192;3:*.bfe=38;5;192;3:*.enc=38;5;192;3:*.gpg=38;5;192;3:*.signature=38;5;192;3:*.sig=38;5;192;3:*.p12=38;5;192;3:*.pem=38;5;192;3:*.pgp=38;5;192;3:*.p7s=38;5;192;3:*id_dsa=38;5;192;3:*id_rsa=38;5;192;3:*id_ecdsa=38;5;192;3:*id_ed25519=38;5;192;3:*.32x=38;5;213:*.cdi=38;5;213:*.fm2=38;5;213:*.rom=38;5;213:*.sav=38;5;213:*.st=38;5;213:*.a00=38;5;213:*.a52=38;5;213:*.A64=38;5;213:*.a64=38;5;213:*.a78=38;5;213:*.adf=38;5;213:*.atr=38;5;213:*.gb=38;5;213:*.gba=38;5;213:*.gbc=38;5;213:*.gel=38;5;213:*.gg=38;5;213:*.ggl=38;5;213:*.ipk=38;5;213:*.j64=38;5;213:*.nds=38;5;213:*.nes=38;5;213:*.sms=38;5;213:*.8xp=38;5;121:*.8eu=38;5;121:*.82p=38;5;121:*.83p=38;5;121:*.8xe=38;5;121:*.stl=38;5;216:*.dwg=38;5;216:*.ply=38;5;216:*.wrl=38;5;216:*.pot=38;5;7:*.pcb=38;5;7:*.mm=38;5;7:*.gbr=38;5;7:*.scm=38;5;7:*.xcf=38;5;7:*.spl=38;5;7:*.Rproj=38;5;11:*.sis=38;5;7:*.1p=38;5;7:*.3p=38;5;7:*.cnc=38;5;7:*.def=38;5;7:*.ex=38;5;7:*.example=38;5;7:*.feature=38;5;7:*.ger=38;5;7:*.ics=38;5;7:*.map=38;5;7:*.mf=38;5;7:*.mfasl=38;5;7:*.mi=38;5;7:*.mtx=38;5;7:*.pc=38;5;7:*.pi=38;5;7:*.plt=38;5;7:*.pm=38;5;7:*.rdf=38;5;7:*.ru=38;5;7:*.sch=38;5;7:*.sty=38;5;7:*.sug=38;5;7:*.tdy=38;5;7:*.tfm=38;5;7:*.tfnt=38;5;7:*.tg=38;5;7:*.vcard=38;5;7:*.vcf=38;5;7:*.xln=38;5;7:*.iml=38;5;166:'
