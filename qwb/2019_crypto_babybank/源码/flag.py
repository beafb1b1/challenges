import hashlib
def getflag(teamtoken):
    return "flag{"+hashlib.sha256("1q2w3e4razsxdcfv"+hashlib.md5(teamtoken).hexdigest()).hexdigest()+"}"