# Useful groovy snippets for your next Jenkinsfile / script :muscle:

## Selectivly load class, only if exists

In cases running an import might fail the process -
```
import jenkins.model.Jenkins
```
We cannot use `try{}catch(){}` for it. The solution is to load it differently -
```
try {
    selectedClass = "jenkins.model.Jenkins" as Class
    println "Working from Jenkins controller, loading jenkins Class..."
} catch (Exception ex) {
    println "Could not load Jenkins.model, will load CLIBuilder..."
    selectedClass = "groovy.cli.commons.CliBuilder" as Class
    CliMode = true
}
```

## Using CLI Builder in groovy
We can run `./my-script.groovy --file-to-process "/tmp/list.txt"` using CLI Builder.
This way can be done like this example:
```
import groovy.cli.commons.CliBuilder // or load using previous example
if (CliMode){
    // CLI Commands definition
    def cli = new CliBuilder(usage: 'This is an example CLI for groovy')

    cli.with {
        h(longOpt: 'help', 'Usage Information \n')
        f(type: String, longOpt: 'file-to-process','list.txt file full path')
        d(type: String, longOpt: 'destination','destination file full path')
    }

    def options = cli.parse(args)

    if(options.h) {
        cli.usage()
        return
    }

    if(options.f){
        listFilePath = options.f
    }
    else {
        throw new Exception("In CLI mode, please use \"-f\" for source casc")
    }

    if(options.d){
        destinationFilePath = options.d
    }
    else {
        throw new Exception("In CLI mode, please use \"-d\" for destination casc")
    }
    // CLI is configured
}
```

## Cleanup pipeline for all builds with "libs" folder:
```
pipeline {
    options {
        timestamps()
    }
    agent { label "master||built-in" }
    stages {
        stage('Cleanup') {
            steps {
                script {
                        libsDir = "libs"

                        Jenkins.instance.getAllItems(Job.class).each{job ->
                            println "Checking " + job.getFullDisplayName()
                            def jobBuilds = job.getBuilds()
                            if (jobBuilds.size() > 0){
                            jobBuilds.each { build ->
                                if (!build.isBuilding()){
                                    def folder_to_clean="${build.getRootDir()}/${libsDir}";
                                    
                                    def dir = new File(folder_to_clean)
                                    if (dir.exists()) {
                                        println "Deleting libs from " + folder_to_clean;
                                        def rm_libs = ["bash", "-c", "rm -r " + folder_to_clean];
                                        def rm_command = rm_libs.execute();
                                        def outputStream = new StringBuffer();
                                        rm_command.waitForProcessOutput(outputStream, System.err);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
```

### Requires the following signature approvals:
```
staticMethod jenkins.model.Jenkins getInstance
method hudson.model.ItemGroup getAllItems java.lang.Class
method hudson.model.Item getFullDisplayName
method hudson.model.Job getBuilds
method hudson.model.Run isBuilding
method hudson.model.PersistenceRoot getRootDir
```