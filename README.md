# git-pre-push-hook-in-powershell
A git pre-push hook written in powershell which runs MStest on a list of test assemblies and aborts the push if not all tests pass

#Contents
-------------------
- pre-push (bash script)
  + This launches the powershell script, which runs the unit tests in MStest
- pre-push.ps1 (powershell script)
  + This contains the powershell code
  + Runs MStest once for each unit test container (typically something like *.UnitTests.dll)
  + Parses output and displays list of failed tests
  + If all of the tests pass, the push succeeds 

#How to use
--------------------
Download the two files and put them in your projects .git/hooks folder.
