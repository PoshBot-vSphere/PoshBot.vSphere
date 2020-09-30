# Contributing to the PoshBot.vSphere Plugin

## Steps for hackathon team to push code to the repo
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