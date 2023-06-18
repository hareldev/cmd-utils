# Useful Jenkins console scripts :muscle:

## List failed jobs in a pipeline

This script will list all builds that were not succeed in the pipeline. This includes the following states: `ABORTED`, `FAILURE` [as listed here](https://javadoc.jenkins-ci.org/hudson/model/Result.html). Also, `null` will be reported for cases were the jon is still running.

1 placeholder should be replaced:
* `place-pipeline-name-here`

```
import hudson.model.Result

Jenkins.instance.getItemByFullName('folder-name/place-pipeline-name-here').builds.findAll { it.result != Result.SUCCESS }.each {
  println "#${it.number} Status:${it.result} \n    ${it.absoluteUrl}"
}

null
```

## Stop stuck / frozen build

Stuck or frozen pipelines could be released by aborting the specific build that is currently running using the following script from console -

2 placeholders should be replaced:
* `place-pipeline-name-here`
* `build_num`

```
Jenkins.instance.getItemByFullName("place-pipeline-name-here")
        .getBuildByNumber(build_num)
        .finish(hudson.model.Result.ABORTED, new java.io.IOException("Aborting build"));
```

## Delete last N builds

2 placeholders should be replaced:
* Min Builds to keep
* `place-pipeline-name-here`

```

// setting increased timeout to make sure commands will not abort, as it could take up to 1min:
System.setProperty("httpKeepAliveTimeout","60000")
System.setProperty("httpsKeepAliveTimeout","60000")
// still 504 Gateway Time-out after this change, need to investigate https://issues.jenkins.io/browse/JENKINS-59267

import jenkins.model.Jenkins
import hudson.model.Job

MIN_BUILD_LOGS = 7

def sixMonthsAgo = new Date() - 180

Jenkins.instance.getItemByFullName('folder-name/place-pipeline-name-here').each { job ->
  println job.getFullDisplayName()
  
  def recent = job.builds.limit(MIN_BUILD_LOGS)
  
  def buildsToDelete = job.builds.findAll {
    !recent.contains(it) && ! (it.getTime() > sixMonthsAgo)
  }
  
  if (!buildsToDelete) {
    println "nothing to do"
  }
  for (build in buildsToDelete) {
    println "Preparing to delete: " + build + build.getTime()
    // ["bash", "-c", "rm -r " + build.getRootDir()].execute()
    // build.delete()
  }
}

```

## Delete Workflows from all builds
There are situations where `workflow` XML files are getting large in size, and it needs to be removed in order to preserve disk space.
[Example related post](https://community.jenkins.io/t/can-i-delete-workflow-xml-files/4095)

1 placeholder should be replaced:
* `place-pipeline-name-here`
```
System.setProperty("httpKeepAliveTimeout","60000")
System.setProperty("httpsKeepAliveTimeout","60000")

import jenkins.model.Jenkins
import hudson.model.Job

job_name_to_cleanup="place-pipeline-name-here"

def calculateFolderSize(path){
  def du_string = "du -s ${path}";
  def du_command = du_string.execute();
  def outputStream = new StringBuffer();
  du_command.waitForProcessOutput(outputStream, System.err);
  return outputStream.toString().split()[0].toInteger();
}

Jenkins.instance.getAllItems(Job.class).each{job ->
  if (job.name != job_name_to_cleanup){
    return
  }
  
  println "Checking " + job.getFullDisplayName()
  def jobBuilds=job.getBuilds()
  if (jobBuilds.size() > 0){
    println "${jobBuilds.size()} builds found"
    jobBuilds.each { build ->
      if (!build.isBuilding()){
          def folder_to_clean="${build.getRootDir()}/workflow/*.xml";
          def build_folder_size_before = calculateFolderSize(build.getRootDir());
          
          println "Deleting workflow from " + build;
          def rm_list = ["bash", "-c", "rm " + folder_to_clean];
          def rm_command = rm_list.execute();
          def outputStream = new StringBuffer();
          rm_command.waitForProcessOutput(outputStream, System.err);
        
          def build_folder_size_after = calculateFolderSize(build.getRootDir());
          println "${(build_folder_size_before-build_folder_size_after)/1024}MB of disk space saved!"
      }
    }
  }
}
return
```