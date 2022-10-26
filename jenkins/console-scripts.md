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