# Git commands which were used in this task
  | Command      | Explanation |
  | ----------- | ----------- | 
  | git init | create a new local repository | 
  | git clone git@github.com:vostapch/test_50_Cent.git | Create a working copy of a local repository  |
  | git add * | Add all files to staging |
  | git commit -m "Commit message" | Commit changes to head (but not yet to the remote repository) | 
  | git push origin main | Send changes to the main branch of your remote repository |
  | git status | List the files you've changed and those you still need to add or commi |

Before doing all of this manupulation you need to add/create your ssh.pub key, do not forget to do ssh-add /.ssh/id_rsa and only after that you can send and receive files from the remote repository.
As a good practise please always use Secure Method(pub.keys)
