# carlo_dir
This is a template carlo_dir for monte-moos.  

## Setup 

Clone the repo
```bash
$ cd ~  
$ git clone git@github.mit.edu:kevin00/monte-moos.git  
$ git clone git@github.mit.edu:kevin00/carlo_dir.git   
$ cd carlo_dir  
$ ls   
     monte_info   
     job_dirs/  
     repo_links.txt  
```

Edit the monte_info file to ensure things are in the right location  
```bash
$ emacs monte_info # edit to ensure things are in the right location  
```

Add the password
```bash
$ echo “Ask Kevin for password” > .password   
$ ls -a  
     monte_info   
     job_dirs/  
     repo_links.txt  
     .password  
```

Add the following to your .bashrc file
```bash
$ vim ~/.bashrc  


##########################################
# monte-moos
##########################################
export MONTE_MOOS_BASE_DIR="/home/monte/monte-moos"
export PATH="${PATH}:${MONTE_MOOS_BASE_DIR}/global_scripts"
export CARLO_DIR_LOCATION="${HOME}/carlo_dir"
source ~/carlo_dir/monte_info  
```


<br/><br/>
# How to's
## Running  alpha once
    
```bash  
$ pwd  
/home/users/carlo_dir  
$ cd job_dirs/example_directory/tutorials/alpha_tutorial  
$ ls  
alpha_job    
post_process_results.sh   
$ monte_run_job.sh --job_file=alpha_job  
```

## Running a local queue
```bash
$ pwd  
~/carlo_dir   
$ ls job_dirs
       example_directory/
$ echo example_directory/tutorials/alpha_tutorial/alpha_job 10 > host_job_queue.txt  
$ monte_client_loop.sh -y -nh  
```


## Running a queue from the host
```bash  
$ pwd  
~/carlo_dir     
$ monte_client_loop.sh -y  
```