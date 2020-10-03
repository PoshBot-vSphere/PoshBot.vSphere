# Contributing to the PoshBot.vSphere Plugin
We are so happy you are willing to help! Honestly, whether it's code related (new commands, code fixes, enhancements, bugs) or even non-code contributions (documentation, spelling, videos, localization) we will 100% accept the help!  Also - we are here to help.  This is a great project that was born out of the VMware {Code} 2020 Hackathon.  Hackathons promote learning and we intend to keep it that way. This is a great project to start to get used to things like forking and pull requests - reach out if you have any questions at all.

***Note*** The dev branch is the main working branch on this repo - it's where you will find all of the new features, functionality, and bug fixes. You can only submit Pull Requests to the dev branch.  Master is protected and will only be updated when we deem enough functionality to warrant a new release to the PowerShell Gallery.

The PoshBot.vSphere plugin follows the GitHub flow methodology.  Basically, fork the repository, pull it down local, create a branch (based off dev), commit some changes, push to back to your forked copy, and issue a Pull Request.  We will review and merge!  It's as easy as that!

If you know exactly what's happening - go ahead and contribute away - if you need a little push, let me walk you through a common scenario of creating a new command...

## Common Scenario for creating a new PoshBot.vSphere command
1. First things first, you will need to fork this repo to your own GitHub account.  This part is easy, and completely GUI based.  Head to this repositories [landing page](https://github.com/PoshBot-vSphere/PoshBot.vSphere).  See that cool little `Fork` option in the top right hand corner - yeah, click it!

1. Create a new directory and clone the repository (only need to do this once)
```
mkdir c:\pb
cd c:\pb
git clone https://github.com/mwpreston/PoshBot.vSphere.git
```
2. Make sure master branch is up to date (it will be fine during the first clone, but subsequently we should always check to be sure you have latest code before creating a branch)
```
git checkout master
git pull
```
3. Create new branch based off of master. I usually name these with my initials, then sort of what will be included in the branch.
```
git checkout master
git checkout -b mwp-vmpowerstatus
```
4. You can make sure you are on your feature branch by issuing
```
git branch
```
5. Go ahead and make your changes (You may need to copy files over from your working copy of the module) - unless you clone the repo directly into $PSModulePath - things get crazy here lol).  When you are done making changes commit them, or commit along the way, depends how you work.
If there are new files you need to add with
```
git add .
```
and then commit
```
git commit -a -m 'commit message'
```

6. When you are ready to issue a PR, push your branch up to GitHub. YOu should have direct access to the repo
```
git push --set-upstream origin <branchname>
IE
git push --set-upstream origin mwp-vmpowerstatus
```
7. Go to the repo and issue a new Pull Request, based off of your branch
```
Pull Requests-> New Pull Request
Use master as base, and your branch as compare
Click 'Create Pull Request'
You can add a little description around what is changed/added
Tag me as a reviewer if you want...  Otherwise I will just watch the repo
Click 'Create Pull Request'
```
8. Thats it, I'll go in and review and approve and merge!  Done!  Once CI is setup it should copy all changes over to the poshbot-master bot we have setup in the Slack!

I would probably create a new branch for each command you create and issue PRs subsequently, probably easier IMO.  Any questions, just ask...

