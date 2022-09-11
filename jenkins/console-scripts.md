# Useful Jenkins console scripts :muscle:

## List failed jobs in a pipeline

This script will list all builds that were not succeed in the pipeline. This includes the following states: `ABORTED`, `FAILURE` [as listed here](https://javadoc.jenkins-ci.org/hudson/model/Result.html).

1 placeholder should be replaced:
* `place-pipeline-name-here`

```
import hudson.model.Result

Jenkins.instance.getItem('place-pipeline-name-here').builds.findAll { it.result != Result.SUCCESS }.each {
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