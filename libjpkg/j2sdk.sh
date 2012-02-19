j2sdk_readme()
{
	j2se_readme
}


j2sdk_changelog()
{
	j2se_changelog
}


j2sdk_control()
{
	j2se_control
	cat << EOF
Package: $j2se_package
Architecture: any
Depends: \${shlibs:Depends}
Recommends: libasound2, libx11-6, libxext6, libxi6, libxt6, libxtst6, java-common (>= 0.24), locales, unixodbc
Provides: java-virtual-machine, java-runtime, java2-runtime, java5-runtime, java6-runtime, java-compiler, java-sdk, java2-sdk, java5-sdk, java6-sdk, j2sdk$j2se_release, j2re$j2se_release
Description: $j2se_title
 The Java(TM) 2 SDK is a development environment for building
 applications, applets, and components that can be deployed on the
 Java(TM) platform.
 .
 The Java(TM) 2 SDK software includes tools useful for developing and
 testing programs written in the Java programming language and running
 on the Java platform. These tools are designed to be used from the
 command line. Except for appletviewer, these tools do not provide a
 graphical user interface.
 .
 This package has been automatically created by make-jpkg ($version).
EOF
}


j2sdk_copyright()
{
	j2se_copyright
}


j2sdk_install_scripts()
{
	j2se_install_scripts
}


j2sdk_info()
{
	j2se_info
}


j2sdk_build()
{
	j2se_build
}


# build debian package
j2sdk_run()
{
	echo
	diskfree "$j2se_required_space"
	read_maintainer_info
	j2se_package="j2sdk$j2se_release-$j2se_vendor"
	j2se_base="/usr/lib/jvm/j2sdk$j2se_release-$j2se_vendor"
	local target="$install_dir$j2se_base"
	install -d -m 755 "$( dirname "$target" )"
	extract_bin "$archive_path" "$j2se_expected_min_size" "$target"
	rm -rf "$target/.systemPrefs"
	j2sdk_readme > "$debian_dir/README.Debian"
	j2sdk_changelog > "$debian_dir/changelog"
	j2sdk_control > "$debian_dir/control"
	j2sdk_copyright > "$debian_dir/copyright"
	j2sdk_install_scripts
	install -d "$target/debian"
	j2sdk_info > "$target/debian/info"
	j2sdk_build
}
