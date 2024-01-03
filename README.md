# carlo_dir
This is a template carlo_dir for monte-moos. It is a directory with all necesary information to run monte-moos. It is meant to be cloned and modified for each user.  

## Setup 

1. Clone monte-moos
```bash
$ cd ~  
$ git clone git@github.mit.edu:kevin00/monte-moos.git  monte-moos
```

2. Make your carlo_dir from the template
```bash
$ git clone git@github.mit.edu:kevin00/carlo_dir_template.git   my_carlo_dir
$ cd my_carlo_dir  
$ ls   
     README.md  
     job_dirs/  
     monte_info 
     repo_links.txt
$ git remote rm origin # So it doesn't reference the template
$ # Go to your github account and make a new repository. Note the url printed on the webpage (ex: git@github.mit.edu:username/my_carlo_dir)
$ git remote add origin your-repos-url # Add your repo url here. ex: git@github.mit.edu:username/my_carlo_dir.git
$ git branch -M main
$ git push -u origin main # Push to the host!
```

3. Add the following lines to your .bashrc file
```bash
$ vim ~/.bashrc  

##########################################
# monte-moos setup
##########################################
export MONTE_MOOS_BASE_DIR="/home/monte/monte-moos"
export PATH="${PATH}:${MONTE_MOOS_BASE_DIR}/global_scripts"
export CARLO_DIR_LOCATION="${HOME}/my_carlo_dir"
source ${CARLO_DIR_LOCATION}/monte_info 

```

4. Edit the monte_info file to ensure things are in the right location. In particular, make sure the **MONTE_MOOS_HOST_SSH_KEY** and **MONTE_MOOS_USERNAME** are correct.
```bash
$ cd my_carlo_dir
$ vim monte_info 

# In particular, check the locations of the following variables:
#   MONTE_MOOS_HOST_SSH_KEY
#   MONTE_MOOS_USERNAME

```

5. Add the password
```bash
$ echo “Ask Kevin for password” > .password   
$ ls -a  
     monte_info   
     job_dirs/  
     repo_links.txt  
     .password  
```


<br/><br/>
# How to's
## Running  alpha once
    
```bash  
$ pwd  
/home/users/my_carlo_dir  
$ cd job_dirs/example_directory/tutorials/alpha_tutorial  
$ ls  
alpha_job    
post_process_results.sh   
$ monte_run_job.sh --job_file=alpha_job  
```

## Running a local queue
```bash
$ pwd  
~/my_carlo_dir   
$ ls job_dirs
       example_directory/
$ echo example_directory/tutorials/alpha_tutorial/alpha_job 10 > host_job_queue.txt  
$ monte_client_loop.sh -y -nh  
```


## Running a queue from the host
```bash  
$ pwd  
~/my_carlo_dir     
$ monte_client_loop.sh -y  
```