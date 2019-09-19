import hashlib
def getflag(teamtoken):
    return "flag{"+hashlib.sha256("1q2w3e4razsxdcfv"+hashlib.md5(teamtoken).hexdigest()).hexdigest()+"}"

print getflag("8716e0d814ac15f15bb52cac668a40de")
