# Combines the git add, commit, and push commands into one script
git add -A
if [ $# -eq 0 ]; then
    git commit -m "Pushing Quick Commit";
else
    git commit -m "$*";
fi
git push;
