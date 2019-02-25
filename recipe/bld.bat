@echo ON
nmake /f Makefile.vc CFG=release
if errorlevel 1 exit 1
