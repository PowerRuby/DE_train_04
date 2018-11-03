# Training Material for PowerRuby Community Edition v2

## Let us experiment with Active Job framework

With this training project our objective is to show how to configure **Active Job** with [Sideqik](https://rubygems.org/gems/sidekiq/versions/5.2.2). 

**Sideqik** provides a simple backgroud processing mechanism for Ruby [with free or commercial arrangements](https://sidekiq.org). Rails **Active Job** is a framework for declaring jobs and making them run on different queuing backends and Sidekiq is one of these.

Rails provides a basic generator for jobs that essentially creates for you a Ruby source file inside the **app/jobs** directory.

By executing the following command:

`/PowerRuby/prV2R4/bin/rails generate job clever_utility`

what we get is a Ruby script named *clever\_utility\_job.rb* 


```ruby
class CleverUtilityJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
  end
end
```

it is then our task to modify the **perform** method of the **CleverUtilityJob** class (note that the first letter capitalizing is repeated after each underscore in our original command input argument for the job class name). We simply add a delay of 15 seconds and a log operation:


```ruby
class CleverUtilityJob < ApplicationJob
  queue_as :default

  def perform(*args)
    sleep 15
    logger.info "Logging this message after a delay of 15 seconds."
  end
end
```

## Configuring queuing backend 

Specifying a queuing backend is very simple: just add the following Ruby line inside the **Application** class in the **config/application.rb** file:

```ruby
    config.active_job.queue_adapter = :sidekiq
```

To install the last version of this project, saving you all the editing for the project, we execute the following command:

```
POWER_RUBY/RAILSNEW RAILSAPP(TrainMeOnPowerRuby)
                    HTTPSRV(ACTJOB)             
                    EXTPORT(12121)              
                    INTPORT(21212)              
                    CRT(*GITHUB)
                    GTSRC('DE_train_04')       
```

As explained in a previous project you can benefit from reading through the single commit actions for the project in GitHub.
This helps understanding up to the maximum detail what was needed to have this project executing.

Now let us use **QSH** after setting Qshell for multi-threading (see previous tutorials).
If we now open a `rails console` session we can exercise our job class directly:

```
  $                                                                            
> cd /www/ACTJOB/htdocs/TrainMeOnPowerRuby/current                             
  /www/ACTJOB/htdocs/TrainMeOnPowerRuby/v02                                    
  $                                                                            
> /PowerRuby/prV2R4/bin/rails console                                          
  Loading development environment (Rails 5.1.6)                                
  irb(main):001:0>                                                             
> CleverUtilityJob.perform_later  
  CleverUtilityJob.perform_later                                               
  Enqueued CleverUtilityJob (Job ID: 7863e7be-bb53-4077-b3bb-0eaa988127f6) to Sidekiq(default)                                                              
  => #<CleverUtilityJob:0x23868cec @arguments=[], @job_id="7863e7be-bb53-4077-b3bb-0eaa988127f6", @queue_name="default", @priority=nil, @executions=0, @provider_job_id="4aaa195b985ccd340a74e145">                                      
  irb(main):002:0>                                                             
> 
```

We can check in **development.log**:

```
[ActiveJob] Enqueued CleverUtilityJob (Job ID: 7863e7be-bb53-4077-b3bb-0eaa988127f6) to Sidekiq(default)
```

A successful submission of our job is recorded but **no processing has actually been performed**. Why?



## Launching Sidekiq

We need to launch a new job for Sidekiq to be allowed to play a role in our project.

By executing Sidekiq **having our project path as the current directory** we are creating an independent job that will take care of the CleverUtilityJob class we have previolusly configured.

The rails console will be our **Sidekiq client** and the process just started will be our **Sidekiq server**.
This client-server arrangement is implemented on top of a middleware we introduced in training project [DE\_train\_03](https://github.com/PowerRuby/DE_train_03/blob/master/README.md): **Redis**.

Now we can start the Sidekiq server this way: `/PowerRuby/prV2R4/bin/sidekiq`  

```
         m,
         `$b
    .ss,  $$:         .,d$
    `$$P,d$P'    .,md$P"'
     ,$$$$$bmmd$$$P^'
   .d$$$$$$$$$$P'
   $$^' `"^$$$'       ____  _     _      _    _
   $:     ,$$:       / ___|(_) __| | ___| | _(_) __ _
   `b     :$$        \___ \| |/ _` |/ _ \ |/ / |/ _` |
          $$:         ___) | | (_| |  __/   <| | (_| |
          $$         |____/|_|\__,_|\___|_|\_\_|\__, |
        .d$$                                       |_|

2018-11-03T19:24:30.837Z 350077 TID-4fufxd INFO: Running in ruby 2.4.4p296 (2018-03-28 revision 63013) [powerpc-aix7.1]
2018-11-03T19:24:30.837Z 350077 TID-4fufxd INFO: See LICENSE and the LGPL-3.0 for licensing details.
2018-11-03T19:24:30.837Z 350077 TID-4fufxd INFO: Upgrade to Sidekiq Pro for more features and support: http://sidekiq.org
2018-11-03T19:24:30.837Z 350077 TID-4fufxd INFO: Booting Sidekiq 5.2.2 with redis options {:id=>"Sidekiq-server-PID-350077", :url=>nil}
2018-11-03T19:24:30.839Z 350077 TID-4fufxd INFO: Starting processing, hit Ctrl-C to stop
```

## Submitted jobs being served

We are ready to try again invoking the **perform_later** method over our class (inside Rails console):

```
  $                                                                            
> cd /www/ACTJOB/htdocs/TrainMeOnPowerRuby/current                             
  /www/ACTJOB/htdocs/TrainMeOnPowerRuby/v02                                    
  $                                                                            
> /PowerRuby/prV2R4/bin/rails console                                          
  Loading development environment (Rails 5.1.6)                                
  irb(main):001:0>                                                             
> CleverUtilityJob.perform_later                                               
  CleverUtilityJob.perform_later                                               
  Enqueued CleverUtilityJob (Job ID: 81a3b87e-5ad4-4510-8850-777ec43a8a35) to Sidekiq(default)                                                              
  => #<CleverUtilityJob:0x23839370 @arguments=[], @job_id="81a3b87e-5ad4-4510-8850-777ec43a8a35", @queue_name="default", @priority=nil, @executions=0, @provider_job_id="5a059c5f1d5e06c3992c71fc">                                      
  irb(main):002:0>   
> CleverUtilityJob.perform_later                                               
  CleverUtilityJob.perform_later                                               
  Enqueued CleverUtilityJob (Job ID: 63add9ef-1ab8-4f5b-b82f-81f2cacc58c3) to Sidekiq(default)                                                              
  => #<CleverUtilityJob:0x237f79fc @arguments=[], @job_id="63add9ef-1ab8-4f5b-b82f-81f2cacc58c3", @queue_name="default", @priority=nil, @executions=0, @provider_job_id="4e2dbc51a35d8eb47cd17b26">                                      
  irb(main):003:0>                                                                                                                         

```

We executed **CleverUtilityJob.perform_later** twice on the Rails console session: each request caused the middleware to notify Sidekiq about generating requests with unique IDs that will be executed on the **Sideqik server**. 
This is what we read inside **development.log**:

```
[ActiveJob] Enqueued CleverUtilityJob (Job ID: 81a3b87e-5ad4-4510-8850-777ec43a8a35) to Sidekiq(default)
[ActiveJob] [CleverUtilityJob] [81a3b87e-5ad4-4510-8850-777ec43a8a35] Performing CleverUtilityJob (Job ID: 81a3b87e-5ad4-4510-8850-777ec43a8a35) from Sidekiq(default)
[ActiveJob] [CleverUtilityJob] [81a3b87e-5ad4-4510-8850-777ec43a8a35] Logging this message after a delay of 15 seconds.
[ActiveJob] [CleverUtilityJob] [81a3b87e-5ad4-4510-8850-777ec43a8a35] Performed CleverUtilityJob (Job ID: 81a3b87e-5ad4-4510-8850-777ec43a8a35) from Sidekiq(default) in 15036.93ms
[ActiveJob] Enqueued CleverUtilityJob (Job ID: 63add9ef-1ab8-4f5b-b82f-81f2cacc58c3) to Sidekiq(default)
[ActiveJob] [CleverUtilityJob] [63add9ef-1ab8-4f5b-b82f-81f2cacc58c3] Performing CleverUtilityJob (Job ID: 63add9ef-1ab8-4f5b-b82f-81f2cacc58c3) from Sidekiq(default)
[ActiveJob] [CleverUtilityJob] [63add9ef-1ab8-4f5b-b82f-81f2cacc58c3] Logging this message after a delay of 15 seconds.
[ActiveJob] [CleverUtilityJob] [63add9ef-1ab8-4f5b-b82f-81f2cacc58c3] Performed CleverUtilityJob (Job ID: 63add9ef-1ab8-4f5b-b82f-81f2cacc58c3) from Sidekiq(default) in 15030.84ms
```


## What's next?

Now let us suppose to sumbit jobs from our Web interface rather than Rails console. 
We can imagine to merge this functionality with the ability to trigger events on the browser session by means of **Action Cable** framework (we presented in previous Training Project). 

The goal of next project is to create a more useful example that, leveraging on what we have learnt until now, will be
able to inspire you ideas for your own projects with Rails inside IBM i.

If you are interested in sharing your own experiences while developing with **PowerRuby** let us know through **support@powerruby.com**. Our focus is to create very simple projects meant at explaining few features each time (reducing overlapping with other training projects).
    
    

Enjoy **PowerRuby CE2**!
