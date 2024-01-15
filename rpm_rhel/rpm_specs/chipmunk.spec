%define version @VERSION@
Name:		chipmunk
Version:	%{version}
Release:	0
Summary:	chipmunk is a fast logfile viewer that can deal with huge logfiles (>10 GB)
License:	https://github.com/esrlabs/chipmunk/blob/master/LICENSE.txt
URL:		https://github.com/esrlabs/chipmunk
Source0:	%{name}@%{version}-linux-portable.tar.gz
BuildArch:	x86_64

%description
chipmunk is a fast logfile viewer that can deal with huge logfiles (>10 GB). It powers a super fast search and is supposed to be a useful tool for developers who have to analyze logfiles.

%prep
##%setup -n %{name}-%{version}.linux
[ "$RPM_BUILD_ROOT" != "/" ] && rm -rf $RPM_BUILD_ROOT
#mkdir -p $RPM_BUILD_ROOT/
tar -xvzf %{_topdir}/SOURCES/*.tar.gz -C %{_topdir}/BUILD

%install
mkdir -p -m777 $RPM_BUILD_ROOT%{_bindir}
mkdir -p -m777 $RPM_BUILD_ROOT/usr/lib/%{name}
#cp -r %{_topdir}/BUILD/. $RPM_BUILD_ROOT
cp -r %{_topdir}/BUILD/. $RPM_BUILD_ROOT/usr/lib/%{name}
sudo ln -sf /usr/lib/%{name}/chipmunk $RPM_BUILD_ROOT%{_bindir}
#sudo install -m777 %{_topdir}/BUILD/%{name} $RPM_BUILD_ROOT%{_bindir}/%{name}/%{name}
#mkdir -p $RPM_BUILD_ROOT/usr/bin
#cp -R %{_topdir}/BUILD/ $RPM_BUILD_ROOT
#sudo install -m 0755 $RPM_BUILD_ROOT/chipmunk /usr/bin/%{name}-%{version}
#rm -rf $RPM_BUILD_ROOT%{_datadir}/doc/%{name}
#mkdir -p "$RPM_BUILD_ROOT"
#cp -R %{_topdir}/* "$RPM_BUILD_ROOT"
#sudo mkdir -p -m777 /usr/local/lib/%{name}
#cp -R $RPM_BUILD_ROOT/* /usr/local/lib/%{name}
#sudo ln -sf /usr/local/lib/%{name}/%{name} /usr/local/bin/%{name}
#sudo ln -sf /usr/local/bin/%{name} $HOME/Desktop/%{name}

%clean
[ "$RPM_BUILD_ROOT" != "/" ] && rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
/usr/lib/%{name}/.
%{_bindir}/chipmunk

%changelog
* Tue Nov 07 2023 sameer
-