# vlt.git.git_status

  GIT_STATUS - return git working tree status
 
  [UPTODATE, CHANGES, UNTRACKED_PRESENT] = vlt.git.git_status(DIRNAME)
 
  Examines whether a git working tree is up to date with its current branch
 
  UPTODATE is 1 if the working tree is up-to-date, and 0 if not.
  CHANGES is 1 if the working tree has changes to be committed, and 0 if not.
  UNTRACKED_PRESENT is 1 if there are untracked files present, and 0 if not.
 
  An error is generated if DIRNAME is not a GIT directory.
 
  See also: vlt.git.git_isgitdirectory
