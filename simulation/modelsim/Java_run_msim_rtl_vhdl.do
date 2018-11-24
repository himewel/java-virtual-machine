transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {/home/hime/Documentos/Java/ULA.vhd}
vcom -93 -work work {/home/hime/Documentos/Java/Stack.vhd}
vcom -93 -work work {/home/hime/Documentos/Java/RAM.vhd}
vcom -93 -work work {/home/hime/Documentos/Java/PC.vhd}
vcom -93 -work work {/home/hime/Documentos/Java/Main.vhd}
vcom -93 -work work {/home/hime/Documentos/Java/CONTROLE.vhd}
vcom -93 -work work {/home/hime/Documentos/Java/VAR.vhd}
vcom -93 -work work {/home/hime/Documentos/Java/BRANCH.vhd}

