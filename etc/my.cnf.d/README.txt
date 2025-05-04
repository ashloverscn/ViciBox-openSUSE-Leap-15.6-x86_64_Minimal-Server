#
# ViciBox v.12.0 MariaDB 10.6.X config for OpenSuSE Leap 15.6
# 
# Recommended hardware for this config file :
#  - 8-Core CPU 2.0Ghz or up (Real cores!!! not threads)
#  - 16GB of RAM for 250 or less agents, 32GB or up for more agents
#  - At least 512GB of SSD configured in a RAID1 (Hardware or Linux MD)
#
#
#
# Tips, Tricks, and Cheats :
#  - ALL DISCRETIONARY BUDGET SHOULD GO TOWARDS FAST DATABASE DRIVES, 
#      FOLLOWED BY RAM, FOLLOWED BY CPU. That's the order of importance
#      for your standard ViciDial database before custom stuff gets
#      thrown into the mix. More info below.
#
#  - Just go with 1TB SSD's in any flavor. You can use a pair of NVMe  
#      or SATA in a software MD RAID1 array and boot from it just fine.
#      A 2019+ SATA SSD will easily handle 150 or so agents. If you need
#      more then NVMe is the way to go. If you really need to get all of 
#      the database performance you can then use some inexpensive SATA
#      drives for root and then a pair of dedidicated fast NVMe drives 
#      mounted under /srv/mysql/data . This will make sure all the extra
#      IO happening on the system like binary logs and normal system logs
#      won't be competing with MariaDB and it's access to the database.
#
#  - If given a choice, more GHz is better then more CPU within the same
#      generation of CPU. For example a CPU with 8-cores at 2.1GHz gives
#      you a performance metric of 16.8 (Cores x GHz). A 6-core CPU at
#      3.0GHz gives you a performance metric of 18. So for MariaDB the
#      6-Core CPU at 3.0GHz would be faster then the 8-core CPU at 2.1GHz.
#      Your average 300-agent call center is quite happy with an 8-core
#      CPU until the custom report developers and management gets in 
#      there and starts data mining. Use a replciation server for that!!!
#
#  - There's not a very compelling reason to go much above 128GB of RAM
#      with ViciDial. Since the workload is write intensive you end up in
#      a cycle of everything waiting for 1 thread to write some data so
#      they can read it. Eventually you end up with a sort of hot data
#      set that uses roughly X amount of memory to operate. When you hit
#      that point the drive is now the bottleneck and all memory can do
#      is try to buffer IO to/from it. This same single-thread issue also
#      become a problem for RAM based storage like tmpfs just at a higher
#      scale.
#
#  - NVMe drives are the way to go by far, but SATA will work for smaller
#      sub-100 agent call centers. The limiting factor is the drives IOPS
#
#  - Try to use CPU-attached NVMe slots where possible. This removes the
#      PCH from being a bottleneck. If you have one drive on CPU and a
#      second on PCH then you will be fine.
#
#  - If you feel the need to tune this config file, you need to tune for
#      a 50/50 read to write workload. If anything, error on the side of
#      a higher write workload. Googling MariaDB performance tuning that
#      uses something like WordPress as the target workload is not really
#      comprable to a ViciDial workload. Wordpress is a read-intensive
#      application. ViciDial is a write-intensive application. The MariaDB
#      tune they need for best performance are different.
#
#  - There are no magic tuning or settings that can fix inadequate
#      hardware. Run 'iostat -dkx 1' and see how utilized your non-NVMe
#      drives are. If it's above 90%, there is no fix for that. NVMe drives
#      do not typically hit port bandwidth limits. Instead you'll see cache
#      saturation issues where the performance will drop down closer to the
#      non-cache random write speed. That's your limiting factor with NVMe.
#
