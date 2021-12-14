# Toggle "there is work" vs "there is no work"
got_work = "1"


def should_do_work(_wildcards_unused):
    has_work = checkpoints.get_work.get().output[0].exists
    if has_work:
        return ["output/work.done"]
    return []

rule all:
    message: "all"
    input:
        should_do_work

checkpoint get_work:
    message: "get_work"
    input:
        "input/input.txt"
    output:
        "output/work.txt"
    shell:
        """
        if [ {got_work} == "1" ]; then
            cp {input} {output}
        fi
        """

rule do_work:
    message: "do_work"
    input:
        "output/work.txt"
    output:
        "output/result.txt"
    shell:
        "touch {output}"

rule upload_result:
    message: "upload_result"
    input:
        "output/result.txt"
    output:
        "output/work.done"
    shell:
        "touch {output}"
