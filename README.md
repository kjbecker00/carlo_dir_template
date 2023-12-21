# carlo_dir
This is a template carlo_dir for monte-moos

-----------Setup-----------
$ cd ~
$ git clone git@github.mit.edu:kevin00/monte-moos.git
$ git clone git@github.mit.edu:kevin00/carlo_dir.git 
$ cd carlo_dir
$ ls
monte_info 
job_dirs/
repo_links.txt
$ emacs monte_info # edit to ensure things are in the right location
$ echo “European_Swallow” > .password
$ ls -a
monte_info 
job_dirs/
repo_links.txt
.password

-----------Running  alpha once-----------
$ pwd
~/carlo_dir
$ source monte_info  # to set variables 
$ cd job_dirs/example_directory/tutorials/alpha_tutorial
$ ls
alpha_job
post_process_results.sh
$ monte_run_job.sh --job_file=alpha_job


-----------Running  a local queue-----------
$ pwd
~/carlo_dir
$ source monte_info 
$ echo job_dirs/example_directory/tutorials/alpha_tutorial/alpha_job 10 > host_job_queue.txt
$ monte_client_loop.sh -y -nh


The following is not working yet, but this is what it would look like :

-----------Running  a queue from the host-----------
$ pwd
~/carlo_dir
$ source monte_info 
$ monte_client_loop.sh -y

