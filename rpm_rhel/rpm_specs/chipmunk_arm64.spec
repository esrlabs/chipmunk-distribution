%define version @VERSION@
# disable check-buildroot (normally /usr/lib/rpm/check-buildroot) with:
%define __arch_install_post %{nil}

%define __os_install_post %{nil}
Name:		chipmunk
Version:	%{version}
Release:	0
Summary:	chipmunk is a fast logfile viewer that can deal with huge logfiles (>10 GB)
License:	https://github.com/esrlabs/chipmunk/blob/master/LICENSE.txt
URL:		https://github.com/esrlabs/chipmunk
Source0:	%{name}@%{version}-linux-portable.tgz

%description
chipmunk is a fast logfile viewer that can deal with huge logfiles (>10 GB). It powers a super fast search and is supposed to be a useful tool for developers who have to analyze logfiles.

%prep
##%setup -n %{name}-%{version}.linux
[ "$RPM_BUILD_ROOT" != "/" ] && rm -rf $RPM_BUILD_ROOT
#mkdir -p $RPM_BUILD_ROOT/
tar -xvzf %{_topdir}/SOURCES/*.tgz -C %{_topdir}/BUILD

%install
mkdir -p -m777 $RPM_BUILD_ROOT%{_bindir}
mkdir -p -m777 $RPM_BUILD_ROOT/usr/lib/%{name}
cp -r %{_topdir}/BUILD/. $RPM_BUILD_ROOT/usr/lib/%{name}
sudo ln -sf /usr/lib/%{name}/chipmunk $RPM_BUILD_ROOT%{_bindir}

%clean
[ "$RPM_BUILD_ROOT" != "/" ] && rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
/usr/lib/%{name}/.
%{_bindir}/chipmunk

%changelog
* Mon Dec 11 2023 Sameer
-