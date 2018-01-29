#
# DO NOT EDIT THIS FILE
#
# It is automatically generated by grub-mkconfig using templates
# from /etc/grub.d and settings from /etc/default/grub
#

### BEGIN /etc/grub.d/30_os-prober_proxy ###
menuentry "Windows 7 (loader) (на /dev/sda1)" --class windows --class os $menuentry_id_option 'osprober-chain-20E44321E442F894' {
	insmod part_msdos
	insmod ntfs
	set root='hd0,msdos1'
	if [ x$feature_platform_search_hint = xy ]; then
	  search --no-floppy --fs-uuid --set=root --hint-bios=hd0,msdos1 --hint-efi=hd0,msdos1 --hint-baremetal=ahci0,msdos1  20E44321E442F894
	else
	  search --no-floppy --fs-uuid --set=root 20E44321E442F894
	fi
	parttool ${root} hidden-
	chainloader +1
}


set timeout_style=menu
if [ "${timeout}" = 0 ]; then
  set timeout=10
fi
### END /etc/grub.d/30_os-prober_proxy ###

### BEGIN /etc/grub.d/31_header ###
if [ -s $prefix/grubenv ]; then
  set have_grubenv=true
  load_env
fi
if [ "${next_entry}" ] ; then
   set default="${next_entry}"
   set next_entry=
   save_env next_entry
   set boot_once=true
else
   set default="Windows 7 (loader) (на /dev/sda1)"
fi

if [ x"${feature_menuentry_id}" = xy ]; then
  menuentry_id_option="--id"
else
  menuentry_id_option=""
fi

export menuentry_id_option

if [ "${prev_saved_entry}" ]; then
  set saved_entry="${prev_saved_entry}"
  save_env saved_entry
  set prev_saved_entry=
  save_env prev_saved_entry
  set boot_once=true
fi

function savedefault {
  if [ -z "${boot_once}" ]; then
    saved_entry="${chosen}"
    save_env saved_entry
  fi
}
function recordfail {
  set recordfail=1
  if [ -n "${have_grubenv}" ]; then if [ -z "${boot_once}" ]; then save_env recordfail; fi; fi
}
function load_video {
  if [ x$feature_all_video_module = xy ]; then
    insmod all_video
  else
    insmod efi_gop
    insmod efi_uga
    insmod ieee1275_fb
    insmod vbe
    insmod vga
    insmod video_bochs
    insmod video_cirrus
  fi
}

if [ x$feature_default_font_path = xy ] ; then
   font=unicode
else
insmod part_msdos
insmod ext2
set root='hd0,msdos5'
if [ x$feature_platform_search_hint = xy ]; then
  search --no-floppy --fs-uuid --set=root --hint-bios=hd0,msdos5 --hint-efi=hd0,msdos5 --hint-baremetal=ahci0,msdos5  6b37d764-332e-4e5b-ab6c-0011da37bb92
else
  search --no-floppy --fs-uuid --set=root 6b37d764-332e-4e5b-ab6c-0011da37bb92
fi
    font="/usr/share/grub/unicode.pf2"
fi

if loadfont $font ; then
  set gfxmode=auto
  load_video
  insmod gfxterm
  set locale_dir=$prefix/locale
  set lang=en_US
  insmod gettext
fi
terminal_output gfxterm
if [ "${recordfail}" = 1 ] ; then
  set timeout=30
else
  if [ x$feature_timeout_style = xy ] ; then
    set timeout_style=menu
    set timeout=3  # Fallback normal timeout code in case the timeout_style feature is
  # unavailable.
  else
    set timeout=3
  fi
fi
### END /etc/grub.d/31_header ###

### BEGIN /etc/grub.d/32_debian_theme ###
set menu_color_normal=white/black
set menu_color_highlight=black/light-gray
if background_color 60,59,55; then
  clear
fi

color_normal=light-gray/black

if [ -e ${prefix}/themes/ubuntu-mate/theme.txt ]; then
  insmod png
  theme=${prefix}/themes/ubuntu-mate/theme.txt
fi
### END /etc/grub.d/32_debian_theme ###

### BEGIN /etc/grub.d/41_custom_proxy ###

if [ -f  ${config_directory}/custom.cfg ]; then
  source ${config_directory}/custom.cfg
elif [ -z "${config_directory}" -a -f  $prefix/custom.cfg ]; then
  source $prefix/custom.cfg;
fi
### END /etc/grub.d/41_custom_proxy ###

### BEGIN /etc/grub.d/42_linux_xen ###

### END /etc/grub.d/42_linux_xen ###

### BEGIN /etc/grub.d/43_memtest86+ ###
menuentry 'Memory test (memtest86+)' {
	insmod part_msdos
	insmod ext2
	set root='hd0,msdos5'
	if [ x$feature_platform_search_hint = xy ]; then
	  search --no-floppy --fs-uuid --set=root --hint-bios=hd0,msdos5 --hint-efi=hd0,msdos5 --hint-baremetal=ahci0,msdos5  6b37d764-332e-4e5b-ab6c-0011da37bb92
	else
	  search --no-floppy --fs-uuid --set=root 6b37d764-332e-4e5b-ab6c-0011da37bb92
	fi
	knetbsd	/boot/memtest86+.elf
}
menuentry 'Memory test (memtest86+, serial console 115200)' {
	insmod part_msdos
	insmod ext2
	set root='hd0,msdos5'
	if [ x$feature_platform_search_hint = xy ]; then
	  search --no-floppy --fs-uuid --set=root --hint-bios=hd0,msdos5 --hint-efi=hd0,msdos5 --hint-baremetal=ahci0,msdos5  6b37d764-332e-4e5b-ab6c-0011da37bb92
	else
	  search --no-floppy --fs-uuid --set=root 6b37d764-332e-4e5b-ab6c-0011da37bb92
	fi
	linux16	/boot/memtest86+.bin console=ttyS0,115200n8
}
### END /etc/grub.d/43_memtest86+ ###

### BEGIN /etc/grub.d/44_linux_proxy ###
menuentry "Memory test (memtest86+, serial console 115200, mode:live)" --class ubuntu --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-simple-6b37d764-332e-4e5b-ab6c-0011da37bb92' {
	recordfail
	load_video
	gfxmode $linux_gfx_mode
	insmod gzio
	if [ x$grub_platform = xxen ]; then insmod xzio; insmod lzopio; fi
	insmod part_msdos
	insmod ext2
	set root='hd0,msdos5'
	if [ x$feature_platform_search_hint = xy ]; then
	  search --no-floppy --fs-uuid --set=root --hint-bios=hd0,msdos5 --hint-efi=hd0,msdos5 --hint-baremetal=ahci0,msdos5  6b37d764-332e-4e5b-ab6c-0011da37bb92
	else
	  search --no-floppy --fs-uuid --set=root 6b37d764-332e-4e5b-ab6c-0011da37bb92
	fi
	linux	/boot/vmlinuz-4.8.0-59-generic root=UUID=6b37d764-332e-4e5b-ab6c-0011da37bb92 ro  quiet splash $vt_handoff
	initrd	/boot/initrd.img-4.8.0-59-generic
}

function gfxmode {
	set gfxpayload="${1}"
	if [ "${1}" = "keep" ]; then
		set vt_handoff=vt.handoff=7
	else
		set vt_handoff=
	fi
}
if [ "${recordfail}" != 1 ]; then
  if [ -e ${prefix}/gfxblacklist.txt ]; then
    if hwmatch ${prefix}/gfxblacklist.txt 3; then
      if [ ${match} = 0 ]; then
        set linux_gfx_mode=keep
      else
        set linux_gfx_mode=text
      fi
    else
      set linux_gfx_mode=text
    fi
  else
    set linux_gfx_mode=keep
  fi
else
  set linux_gfx_mode=text
fi
export linux_gfx_mode



### END /etc/grub.d/44_linux_proxy ###

### BEGIN /etc/grub.d/45_uefi-firmware ###
### END /etc/grub.d/45_uefi-firmware ###

### BEGIN /etc/grub.d/46_custom ###
# This file provides an easy way to add custom menu entries.  Simply type the
# menu entries you want to add after this comment.  Be careful not to change
# the 'exec tail' line above.
### END /etc/grub.d/46_custom ###

### BEGIN /etc/grub.d/48_custom_proxy ###
### END /etc/grub.d/48_custom_proxy ###
