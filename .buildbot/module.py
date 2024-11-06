from buildbot.plugins import *

def configure(c):
    factory = util.BuildFactory()
    factory.addStep(steps.Git(repourl=repository_url, mode='incremental'))
    factory.addStep(steps.ShellCommand(command=["docker", "build", "."]))
    c['change_source'].append(changes.GitPoller(
        repository_url,
        workdir='gitpoller-workdir', branch=branch_name,
        pollInterval=15)
    )
    c['builders'].append(util.BuilderConfig(
        name=builder_name,
        workernames=["docker-worker"],
        factory=factory
    ))
    c['schedulers'].append(schedulers.ForceScheduler(
        name="force",
        builderNames=[builder_name])
    )
    c['schedulers'].append(schedulers.SingleBranchScheduler(
        name="all",
        change_filter=util.ChangeFilter(branch=branch_name),
        treeStableTimer=None,
        builderNames=[builder_name])
    )