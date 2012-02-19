j2se_readme()
{
	cat << EOF
Package for $j2se_title
---

This package has been automatically created by make-jpkg ($version).
All files from the original distribution should have been installed in
the directory $j2se_base. Please take a look at this directory for
further information.

EOF
}


j2se_changelog()
{
	cat << EOF
$j2se_package ($j2se_version) stable; urgency=low

  * This package was created by make-jpkg ($version).

 -- $maintainer_name <$maintainer_email>  $(date -R)

EOF
}


j2se_control()
{
	cat << EOF
Source: $j2se_package
Section: non-free/devel
Priority: optional
Maintainer: $maintainer_name <$maintainer_email>
Build-Depends: debhelper (>= 7.0.0)
Standards-Version: 3.7.2

EOF
}


j2se_copyright()
{
	cat << EOF
----------------------------------------------------------------------

This file contains a copy of all copyright files found in the original
distribution. The original copyright files and further information can
be found in the directory $j2se_base and its
subdirectories.

----------------------------------------------------------------------
EOF
	(
		cd "$install_dir"
		find * -type f -iname copyright |
		while read file; do
			cat << EOF

File: /$file

----------------------------------------------------------------------

EOF
			cat "$file"
			cat << EOF

----------------------------------------------------------------------
EOF
		done
	)
}


j2se_install_scripts()
{
	cat > "$debian_dir/postinst" << EOF
#!/bin/bash
PATH="/usr/sbin:/usr/bin:/sbin:/bin"
set -e

[ "\$1" = "configure" ] || exit 0

EOF
	cat "$lib_dir/$j2se_package/install" >> "$debian_dir/postinst"
	cat >> "$debian_dir/postinst" << EOF
#DEBHELPER#
EOF
	chmod 755 "$debian_dir/postinst"
	cat > "$debian_dir/prerm" << EOF
#!/bin/bash
PATH="/usr/sbin:/usr/bin:/sbin:/bin"
set -e

[ "\$1" != "remove" ] && [ "\$1" != "deconfigure" ] && exit 0

EOF
	cat "$lib_dir/$j2se_package/remove" >> "$debian_dir/prerm"
	cat >> "$debian_dir/prerm" << EOF
#DEBHELPER#
EOF
	chmod 755 "$debian_dir/prerm"
}


j2se_info()
{
	cat << EOF
version="$version"
j2se_version="$j2se_version"
maintainer_name="$maintainer_name"
maintainer_email="$maintainer_email"
date="$(date +%Y/%m/%d)"
EOF
}


j2se_build()
{
	cd "$tmp"
	echo "Create debian package:"

	#export DH_VERBOSE=1
	export DH_COMPAT=7
	export DH_OPTIONS=--tmpdir="$install_dir"

	echo "    dh_testdir"
	dh_testdir
	echo "    dh_testroot"
	dh_testroot
	echo "    dh_installchangelogs"
	dh_installchangelogs
	# Problem: dh_installchangelogs thinks this is a native package.
	echo "    dh_installdocs"
	dh_installdocs
	# dh_install
	# dh_link
	# Conditionally wrapping this as not all JRE/JDKs have man directories
	if [ -e "$install_dir/$j2se_base/man" ]; then
		echo "    dh_compress"
		dh_compress $(find "$install_dir/$j2se_base/man" -type f ! -name "*.gz")
	fi
	echo "    dh_fixperms"
	dh_fixperms
	echo "    dh_installdeb"
	dh_installdeb
	echo "    dh_shlibdeps"
	ldpath=
	for dir in $(find "$install_dir" -type f -name "*.so*" -printf "%h\n" | sort -u); do
		if [ -z "$ldpath" ]; then
			ldpath="$dir"
		else
			ldpath="$ldpath:$dir"
		fi
	done
	# suppress some warnings
	dh_shlibdeps -l"$ldpath" 2>&1 |
	{ grep -v "warning: format of \`NEEDED lib.*\.so' not recognized" >&2 || true; }
	echo "    dh_gencontrol"
	dh_gencontrol
	echo "    dh_md5sums"
	dh_md5sums
	echo "    dh_builddeb"
	dh_builddeb --destdir="$tmp"
	local deb_filename="$(echo "${j2se_package}_"*.deb)"
	echo "    copy $deb_filename into directory $working_dir/"
	cp -va "$deb_filename" "$working_dir/"
	if [ -n "$genchanges" ]; then
		echo "    dpkg-genchanges"
		local changes_filename="${deb_filename%.deb}.changes"
		dpkg-genchanges -b -u. > "$changes_filename"
		echo "    copy $changes_filename into directory $working_dir/"
		cp -va "$changes_filename" "$working_dir/"
	fi
	cat << EOF

The Debian package has been created in the current directory. You can
install the package as root (e.g. dpkg -i $deb_filename).

EOF
}
